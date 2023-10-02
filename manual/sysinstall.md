# Install to disk

```
setup-alpine
lbu_commit -d

mkdir /stage
mount /dev/mmcblk0p2 /stage
setup-disk -o /media/mmcblk0p1/MYHOSTNAME.apkovl.tar.gz /stage
# (ignore errors about syslinux/extlinux)

echo "extraargs=root=/media/mmcblk0p2" > /media/mmcblk0p1/boot/uEnv.txt
```

# Set main partition to read-only in fstab

# Mount rw partition
```
mkdir /radio
echo "/dev/mmcblk0p3	/radio	ext4	rw,relatime	0	2" >> /etc/fstab
```

# Speedup NTP
Config file `/etc/chrony/chrony.conf` should contain:

```
pool pool.ntp.org iburst
driftfile /var/lib/chrony/drift
makestep 1 3
```

# Setup mpv
Enable community repo by uncommenting its line in `/etc/apk/repositories`
```
apk add mpv-libs alsa-utils alsa-utils-doc alsa-lib alsaconf
```

# Disable writing of resolv.conf by udhcpc
```
mkdir -p /etc/udhcpc/
echo 'RESOLV_CONF="no"' > /etc/udhcpc/udhcpc.conf
```
