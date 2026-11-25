#!/data/data/com.termux/files/usr/bin/sh
# Start / inspect the whole stack under runit. Safe to re-run.
set -u
export SVDIR="${SVDIR:-$PREFIX/var/service}"
termux-wake-lock 2>/dev/null || true
sv up mariadb php-fpm nginx gowa bridge 2>&1
sleep 3
sv status mariadb php-fpm nginx gowa bridge 2>&1
printf '\n-- health --\n'
printf 'gowa    : '; curl -s -o /dev/null -w 'http=%{http_code}\n' --max-time 5 http://127.0.0.1:3000/devices
printf 'espocrm : '; curl -s -o /dev/null -w 'http=%{http_code}\n' --max-time 5 http://127.0.0.1:8081/
printf 'bridge  : '; curl -s --max-time 5 http://127.0.0.1:8085/health; printf '\n'
