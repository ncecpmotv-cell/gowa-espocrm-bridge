#!/data/data/com.termux/files/usr/bin/sh
# Place in ~/.termux/boot/ and install the Termux:Boot app.
# Runs at device boot: wakelock + runit + all services.
termux-wake-lock
export SVDIR="$PREFIX/var/service"
service-daemon start
sleep 5
sv up mariadb 2>/dev/null
sleep 6
sv up php-fpm nginx gowa bridge 2>/dev/null
