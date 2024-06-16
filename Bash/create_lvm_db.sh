apt update
apt install -y lvm2
# Create a partition if needed using fdisk
vgcreate sqlvgmain [/dev/sda1 /dev/sda2]
lvcreate -l [extents] sqlvgmain -name lvol0
mkfs.xfs [/dev/mapper/..]
mkdir /var/lib/msyql/
vim /etc/fstab
# mount lvm dev in fstab
mount -a


