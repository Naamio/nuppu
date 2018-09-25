# Nuppu as a systemd unit

In order to deploy nuppu as a systemd unit:

1. Copy `nuppu.service` to the machine with `scp deploy/systemd/nuppu.service root@${MACHINE_IP}:~/`
2. Enable the service with `systemctl enable path/to/nuppu.service`.
2. Start the service with `systemctl start nuppu.service`
3. See the logs using `journalctl -u nuppu.service`

## Updating this unit

If this config is updated:

1. Copy the updated `nuppu.service` to the same location in the machine.
2. Run `systemctl daemon-reload` to reload the units.
3. Restart the service with `systemctl restart nuppu.service`
