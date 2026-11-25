# Public link from the phone (no server, no domain)

`ngrok` gives a phone-hosted EspoCRM a stable HTTPS hostname without owning a
domain and without opening any port: the agent dials out to ngrok's edge.

Free tier: one static domain (`*.ngrok-free.dev`), HTTPS, and a Basic-auth
traffic policy. Limits: monthly traffic cap and a one-time browser warning page.

## One-time setup (on the phone)

```bash
ngrok config add-authtoken <TOKEN>          # stored in ~/.config/ngrok/ngrok.yml (600)
mkdir -p ~/gowa-espo/etc
printf 'crm:%s\n' "$(python3 -c 'import secrets;print(secrets.token_urlsafe(10))')" \
  > ~/gowa-espo/etc/ngrok-auth.txt && chmod 600 ~/gowa-espo/etc/ngrok-auth.txt
```

`~/gowa-espo/etc/ngrok-policy.yml`:

```yaml
on_http_request:
  - actions:
      - type: basic-auth
        config:
          realm: "EspoCRM"
          credentials:
            - "crm:<password>"
```

Then run the service (`scripts/runit/ngrok/run`). Target is **8081** (the CRM),
never 8080 (nginx's stock landing page).

## Why proot

`ngrok` is a Go binary and reads `/etc/resolv.conf` / `/etc/ssl/certs`, which do
not exist on Android. Without the bind-mounts it fails with
`lookup connect.ngrok-agent.com on [::1]:53: connection refused`.
