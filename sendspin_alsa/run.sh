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

CONFIG_DIR="/root/.config/sendspin"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/settings-daemon.json" <<EOF
{
  "name": "${NAME}",
  "client_id": "${CLIENT_ID}",
  "audio_device": "${AUDIO_DEVICE}",
  "audio_format": "${AUDIO_FORMAT}",
  "static_delay_ms": ${STATIC_DELAY},
  "last_server_url": "${SERVER_URL}",
  "log_level": "${LOG_LEVEL}",
  "use_mpris": false,
  "use_hardware_volume": false
}
EOF

echo "[sendspin-alsa] PulseAudio: ${PULSE_SERVER:-not-set} | output sink: ${AUDIO_OUTPUT:-default}"
echo "[sendspin-alsa] Starting daemon as: ${NAME} (id=${CLIENT_ID})"

exec sendspin daemon
