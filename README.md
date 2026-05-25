# Sendspin ALSA Add-on for Home Assistant

A Home Assistant add-on that runs a [Sendspin](https://www.sendspin-audio.com) audio player daemon, so any USB / built-in audio device attached to your Home Assistant host can join Music Assistant's synchronized multi-room playback.

> Sendspin is the native sync protocol of [Music Assistant](https://music-assistant.io). It provides sample-accurate playback across all connected clients, similar to Snapcast but built into MA out of the box. See the [Sendspin spec](https://github.com/Sendspin/spec) for protocol details.

## Why this add-on?

Music Assistant ships a Sendspin server but no out-of-the-box client for ALSA / USB audio output on Home Assistant OS. The official `sendspin-cli` daemon works on Linux but isn't packaged as an add-on. This bridges that gap.

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click **⋮ → Repositories** and add:

   ```
   https://github.com/firstchair/ha-addon-sendspin-alsa
   ```

3. Find **Sendspin ALSA Player** in the store, install, and start.
4. The new player will appear automatically in Music Assistant via mDNS.

## Configuration

| Option | Description |
|---|---|
| `name` | Friendly name shown in Music Assistant |
| `client_id` | Stable unique ID (change only if running multiple instances) |
| `audio_device` | ALSA / PulseAudio device name. Leave empty for default. |
| `audio_format` | Preferred format. Sendspin in MA is 16-bit-only for now, so `flac:48000:16:2` is the sweet spot. |
| `static_delay_ms` | Manual sync correction in milliseconds |
| `server_url` | Optional explicit MA URL (e.g. `ws://192.168.1.100:8927/sendspin`). Leave empty for mDNS auto-discovery. |
| `log_level` | `DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL` |

## Status

**Alpha.** Sendspin itself is technical preview — both the protocol and this add-on may change.

## License

Apache-2.0
