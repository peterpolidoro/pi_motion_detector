pi_motion_detector
==================

Authors:

    Peter Polidoro <polidorop@janelia.hhmi.org>

License:

    BSD


##Installation and Setup

###Setup Raspbian

[Setup Raspbian](./SETUP_RASPBIAN.md)

###Setup RaspberryPi Camera

Insert the camera cable into the RaspberryPi.

<http://www.raspberrypi.org/documentation/usage/camera/>

Power up RaspberryPi and ssh into it.

On host machine run:

```shell
ssh pi@raspberrypi
```

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
cd
sudo chmod 664 /etc/motion.conf
sudo chmod 755 /usr/bin/motion
sudo touch /tmp/motion.log
sudo chmod 775 /tmp/motion.log
```

###Configure Motion

On raspberrypi run:

```shell
sudo nano /etc/default/motion
```

Change the line to:

```shell
start_motion_daemon=yes
```

On raspberrypi run:

```shell
sudo nano /etc/motion.conf
```

Change the lines to:

```shell
daemon on
logfile /tmp/motion.log
width 352
height 288
framerate 10
area_detect 5
on_area_detected /home/pi/git/pi_motion_detector/impulse.sh
output_pictures off
target_dir /home/pi/motion/
ffmpeg_output_movies off
stream_quality 10
stream_maxrate 10
stream_localhost off
webcontrol_localhost off
locate_motion_mode on
stream_maxrate 100
```

On raspberrypi run:

```shell
mkdir ~/motion
sudo chgrp motion ~/motion
chmod -R g+w ~/motion
sudo reboot
```

