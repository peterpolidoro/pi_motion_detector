pi_motion_detector
==================

Authors:

    Peter Polidoro <polidorop@janelia.hhmi.org>

License:

    BSD


##Installation and Setup

###Setup Raspbian for WiFi

<https://github.com/peterpolidoro/pi_wifi>

###Setup RaspberryPI Camera

ssh into raspberrypi:

```shell ssh pi@raspberrypi ```

Configure:

```shell
sudo raspi-config
```

Options to change:

```shell
5 Enable Camera
<Finish> (reboot no)
```

On raspberrypi run:

```shell
sudo shutdown now
```

Insert the camera cable into the RaspberryPi.

<http://www.raspberrypi.org/documentation/usage/camera/>

Power up RaspberryPi and ssh into it.

Use raspistill to test camera. On raspberrypi run:

```shell
mkdir ~/Pictures
cd ~/Pictures
raspistill -o cam.jpg
```

On the host machine run:

```shell
scp pi@raspberrypi:~/Pictures/cam.jpg ~/Pictures/cam.jpg
feh ~/Pictures/cam.jpg
```

###Download and Install WiringPi

On raspberrypi run:

```shell
mkdir ~/git
cd ~/git
git clone git://git.drogon.net/wiringPi
cd wiringPi
./build
gpio -v
gpio readall
```

###Download this Repository

On raspberrypi run:

```shell
cd ~/git
git clone https://github.com/peterpolidoro/pi_motion_detector.git
```

###Install Motion and Modify for the RaspberryPi Camera

On raspberrypi run:

```shell
sudo apt-get install motion -y
sudo apt-get install -y libjpeg62 libjpeg62-dev libavformat53 libavformat-dev libavcodec53 libavcodec-dev libavutil51 libavutil-dev libc6-dev zlib1g-dev libmysqlclient18 libmysqlclient-dev libpq5 libpq-dev
cd /tmp
wget https://www.dropbox.com/s/xdfcxm5hu71s97d/motion-mmal.tar.gz
tar zxvf motion-mmal.tar.gz
sudo mv motion /usr/bin/motion
sudo mv motion-mmalcam.conf /etc/motion.conf
sudo chmod 664 /etc/motion.conf
sudo chmod 755 /usr/bin/motion
sudo touch /tmp/motion.log
sudo chmod 775 /tmp/motion.log
```

###Configure Motion

Mount raspberrypi filesystem to make it more convenient to modify
files. This requires setting up a root account password.

On the raspberrypi run:

```shell
sudo -i
passwd root
```

On host computer run:

```shell
sudo mkdir /mnt/raspberrypi
sudo chown $USER:$USER /mnt/raspberrypi
sshfs root@raspberrypi:/ /mnt/raspberrypi
```

Edit /mnt/raspberrypi/etc/default/motion

Change the line to:

```shell
start_motion_daemon=yes
```

Edit /mnt/raspberrypi/etc/motion.conf

Change the lines to:

```shell
daemon on
logfile /tmp/motion.log
width 352
height 288
framerate 10
threshold 1500
noise_level 32
area_detect 5
event_gap 2
output_pictures off
ffmpeg_output_movies off
locate_motion_mode off
target_dir /home/pi/motion/
stream_quality 10
stream_maxrate 10
stream_localhost off
webcontrol_localhost off
on_area_detected /home/pi/git/pi_motion_detector/impulse.sh
```

Unmount raspberrypi filesystem. On host machine run:

```shell
fusermount -u /mnt/raspberrypi
```

On raspberrypi run:

```shell
mkdir ~/motion
sudo chgrp motion ~/motion
chmod -R g+w ~/motion
sudo passwd -dl root
sudo reboot
```

