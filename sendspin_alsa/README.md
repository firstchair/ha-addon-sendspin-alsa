# Sendspin ALSA Player

Run a [Sendspin](https://www.sendspin-audio.com) audio-player daemon inside Home Assistant, so any USB / built-in audio device on your HA host can join Music Assistant's synchronized multi-room playback.

## How it works

The add-on installs the official `sendspin-cli` Python package and starts it in daemon mode. Music Assistant runs a Sendspin server (built-in), discovers this daemon over mDNS, and treats it as a regular player.

Audio is routed through the Supervisor's PulseAudio proxy (the same channel VLC, Music Assistant Server, and Snapcast use), so the device selection in **Settings → System → Hardware → Audio** controls where Sendspin plays.

## Configuration

See the [repo README](https://github.com/firstchair/ha-addon-sendspin-alsa#configuration) for the full option reference.

## Troubleshooting

- **Player doesn't appear in MA**: confirm both add-ons can reach each other on the local network — `host_network: true` is set so the container shares the HAOS network namespace.
- **No sound**: in HA, go to **Settings → System → Hardware → Audio**, pick the correct output, and restart this add-on.
- **Out of sync**: tune `static_delay_ms` per device — small positive values delay this client, negatives delay other clients.
