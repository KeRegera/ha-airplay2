#!/usr/bin/with-contenv bashio
# Erzeugt /etc/shairport-sync.conf aus den Add-on-Optionen

NAME="$(bashio::config 'name')"
DEVICE="$(bashio::config 'output_device')"
MIXER="$(bashio::config 'mixer_control_name')"
INTERP="$(bashio::config 'interpolation')"
TIMEOUT="$(bashio::config 'session_timeout')"
INTERRUPT="no"
bashio::config.true 'allow_session_interruption' && INTERRUPT="yes"

{
  echo 'general = {'
  echo "  name = \"${NAME}\";"
  echo '  output_backend = "alsa";'
  echo '  mdns_backend = "avahi";'
  echo "  interpolation = \"${INTERP}\";"
  echo "  allow_session_interruption = \"${INTERRUPT}\";"
  echo "  session_timeout = ${TIMEOUT};"
  echo '};'
  echo 'alsa = {'
  echo "  output_device = \"${DEVICE}\";"
  if bashio::var.has_value "${MIXER}"; then
    echo "  mixer_control_name = \"${MIXER}\";"
  fi
  echo '};'
  echo 'metadata = { enabled = "no"; };'
} > /etc/shairport-sync.conf

bashio::log.info "Konfiguration erzeugt für Gerät '${NAME}' (Ausgabe: ${DEVICE})"

# --- Eigener Avahi-Daemon (der Host-Avahi ist aus dem Container nicht erreichbar)
AV_IF="$(bashio::config 'avahi_interfaces')"
mkdir -p /etc/avahi
# Standard-Dienste (SSH/SFTP) nicht im Netz anbieten
rm -f /etc/avahi/services/*.service
{
  echo '[server]'
  echo 'host-name=ha-airplay2'
  echo 'use-ipv4=yes'
  echo 'use-ipv6=no'
  echo 'enable-dbus=yes'
  echo 'disallow-other-stacks=no'
  if bashio::var.has_value "${AV_IF}"; then
    echo "allow-interfaces=${AV_IF}"
  fi
  echo '[publish]'
  echo 'publish-hinfo=no'
  echo 'publish-workstation=no'
  echo '[wide-area]'
  echo 'enable-wide-area=no'
} > /etc/avahi/avahi-daemon.conf
bashio::log.info "Avahi-Konfiguration erzeugt (Interfaces: ${AV_IF:-alle})"
