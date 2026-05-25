#!/usr/bin/env sh
set -e

OPTIONS=/data/options.json

NAME=$(jq -r '.name // "USB Speaker"' "$OPTIONS")
CLIENT_ID=$(jq -r '.client_id // "sendspin-ha-alsa"' "$OPTIONS")
AUDIO_DEVICE=$(jq -r '.audio_device // ""' "$OPTIONS")
AUDIO_FORMAT=$(jq -r '.audio_format // "flac:48000:16:2"' "$OPTIONS")
STATIC_DELAY=$(jq -r '.static_delay_ms // 0' "$OPTIONS")
SERVER_URL=$(jq -r '.server_url // ""' "$OPTIONS")
LOG_LEVEL=$(jq -r '.log_level // "INFO"' "$OPTIONS")

# Point audio libraries at the Supervisor PulseAudio socket
export PULSE_SERVER=unix:/run/audio/pulse.sock

# Request a 200ms latency buffer from PulseAudio via the ALSA pulse plugin.
# Default is ~25ms which causes underruns in the cross-container audio path
# (sendspin -> ALSA -> pulse plugin -> hassio-audio container -> USB DAC).
export PULSE_LATENCY_MSEC=200

echo "=================================================="
echo "[sendspin-alsa] Audio environment diagnostics"
echo "=================================================="
echo "--- env vars ---"
env | grep -iE "(pulse|audio|alsa)" || echo "(no audio-related env vars)"
echo "--- /run/audio ---"
ls -la /run/audio/ 2>/dev/null || echo "(no /run/audio)"
echo "--- /etc/asound.conf ---"
cat /etc/asound.conf 2>/dev/null || echo "(no /etc/asound.conf)"
echo "--- aplay -D default (open test) ---"
aplay -D default /dev/null 2>&1 | head -5 || true
echo "--- pactl list sinks short ---"
pactl list sinks short 2>&1 | head -10 || true
echo "--- sendspin --list-audio-devices ---"
sendspin --list-audio-devices 2>&1 || true
echo "=================================================="

CONFIG_DIR="/root/.config/sendspin"
mkdir -p "$CONFIG_DIR"

# Write audio_device as null when empty so sendspin auto-selects default device
if [ -z "$AUDIO_DEVICE" ]; then
  AUDIO_DEVICE_JSON="null"
else
  AUDIO_DEVICE_JSON="\"$AUDIO_DEVICE\""
fi

cat > "$CONFIG_DIR/settings-daemon.json" <<EOF
{
  "name": "${NAME}",
  "client_id": "${CLIENT_ID}",
  "audio_device": ${AUDIO_DEVICE_JSON},
  "audio_format": "${AUDIO_FORMAT}",
  "static_delay_ms": ${STATIC_DELAY},
  "last_server_url": "${SERVER_URL}",
  "log_level": "${LOG_LEVEL}",
  "use_mpris": false,
  "use_hardware_volume": false
}
EOF

echo "[sendspin-alsa] Starting daemon as: ${NAME} (id=${CLIENT_ID})"
exec sendspin daemon
