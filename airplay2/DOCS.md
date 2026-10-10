# AirPlay 2 Receiver

Macht dein Home Assistant zu einem AirPlay-2-Lautsprecher (Shairport Sync + NQPTP).
Der Ton wird über die in HAOS gewählte Audioausgabe ausgegeben
(*Einstellungen → System → Hardware → Audio*).

## Optionen

| Option | Bedeutung |
|---|---|
| `name` | Name, der in AirPlay angezeigt wird |
| `output_device` | ALSA-Gerät, Standard `default` (= HAOS-Audioausgabe) |
| `mixer_control_name` | Optional: ALSA-Mixer für Hardware-Lautstärke. Leer = Software-Lautstärke |
| `interpolation` | `soxr` (beste Qualität), `basic` oder `auto` |
| `allow_session_interruption` | Ein anderes Gerät darf laufende Wiedergabe übernehmen |
| `session_timeout` | Sekunden, nach denen eine inaktive Sitzung beendet wird |
| `log_level` | `debug` für ausführliche Logs |

## Hinweise

- Das Add-on nutzt das Host-Netzwerk (nötig für mDNS und die Ports 319/320 UDP von NQPTP).
- Der Mdns/Bonjour-Dienst des Hosts (Avahi) wird über D-Bus genutzt.
- iPhone/Mac und Home Assistant müssen im selben Netz/VLAN sein.
- Läuft bereits ein anderer Shairport-Sync- oder NQPTP-Dienst auf dem Host, vorher beenden.
