#!/bin/bash
#Ubuntu Desktop
lxc exec rabidavid -- apt install ubuntu-desktop

#Install Xorg and x11vnc
lxc exec rabidavid -- aptitude install xorg xserver-xorg-video-dummy x11vnc
lxc exec rabidavid -- dpkg-reconfigure x11-common

#Configure Xorg to use the Dummy video adapter
Section "Monitor"
Identifier "Monitor0"
HorizSync 28.0-80.0
VertRefresh 48.0-75.0
#Modeline "1280x800"  83.46  1280 1344 1480 1680  800 801 804 828 -HSync +Vsync
# 1224x685 @ 60.00 Hz (GTF) hsync: 42.54 kHz; pclk: 67.72 MHz
Modeline "1224x685" 67.72 1224 1280 1408 1592 685 686 689 709 -HSync +Vsync
EndSection

Section "Device"
Identifier "Card0"
Option "NoDDC" "true"
Option "IgnoreEDID" "true"
Driver "dummy"
EndSection

Section "Screen"
DefaultDepth 24
Identifier "Screen0"
Device "Card0"
Monitor "Monitor0"
    SubSection "Display"
    Depth 24
#    Virtual 1280 800
    Modes "1224x685"
    EndSubSection
EndSection

#startupVNC
lxc exec rabidavid -- rm -fr .X*
lxc exec rabidavid -- su -c '/usr/bin/startx -- :1' palehorse & sleep 4
lxc exec rabidavid -- su -c '/usr/bin/x11vnc -forever -rfbport 5901 -rfbauth /home/palehorse/.vnc/passwd -auth guess -display :1 -bg -shared -noxdamage -xrandr' palehorse
