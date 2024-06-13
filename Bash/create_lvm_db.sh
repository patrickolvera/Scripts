apt update
apt install -y lvm2
vgcreate sqlvgmain [/dev/sda]
lvcreate -l [extents] sqlvgmain -name lvol0
mkfs.xfs [/dev/mapper/..]
mkdir /var/lib/msyql/
vim /etc/fstab
# mount lvm dev in fstab
mount -a


