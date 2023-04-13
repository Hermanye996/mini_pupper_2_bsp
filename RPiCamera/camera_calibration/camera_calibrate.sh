#!/bin/bash
#
# This script calibrate a Raspberry Pi monocular camera.
# Version: 1.0
# Date: 2023-04-13
# maintainer: Herman Ye(Hermanye233@icloud.com)
# Reference: https://navigation.ros.org/tutorials/docs/camera_calibration.html

import os

# Exit the script immediately if a command exits with a non-zero status
#set -x
set -e

# Install dependencies
sudo apt install ros-humble-camera-calibration-parsers -y
sudo apt install ros-humble-camera-info-manager -y
sudo apt install ros-humble-launch-testing-ament-cmake -y

# Check if the camera_calibration_ws directory exists
if [ -d ~/camera_calibration_ws ]; then
  echo "Deleting ~/camera_calibration_ws..."
  rm -rf ~/camera_calibration_ws
  echo "Done."
fi

# Build Image Pipeline from source
mkdir -p ~/camera_calibration_ws/src
cd ~/camera_calibration_ws/src
git clone -b humble https://github.com/ros-perception/image_pipeline.git
cd ~/camera_calibration_ws
colcon build
# Create checkerboard from https://calib.io/pages/camera-calibration-pattern-generator
# Or use the checkerboard PDF in 

# Add workspace setup to .bashrc
if ! grep -q "source ~/camera_calibration_ws/install/setup.bash" ~/.bashrc ; then
    echo "source ~/camera_calibration_ws/install/setup.bash" >> ~/.bashrc
fi
source ~/.bashrc

# Check calibration conditions
read -p "Have you downloaded and printed the checkerboard PDF and attached it on a flat surface? (yes/no) " answer1

if [[ "$answer1" =~ [Yy]([Ee][Ss])? ]]; then
    read -p "Have you started the monocular camera node that publishes a valid topic /image_raw? (yes/no) " answer2

    if [[ "$answer2" =~ [Yy]([Ee][Ss])? ]]; then
        read -p "Do you have a well-lit area clear of obstructions and other checkerboard patterns? (yes/no) " answer3

        if [[ "$answer3" =~ [Yy]([Ee][Ss])? ]]; then
            echo "You're all set for camera calibration. Let's get started!"
        else
            echo "Please make sure you have a well-lit area clear of obstructions and other checkerboard patterns before proceeding with camera calibration."
            read -n 1 -s -r -p "Press any key to exit."
            exit 1
        fi
    else
        echo "Please start the monocular camera node that publishes a valid topic /camera/image_raw before proceeding."
        read -n 1 -s -r -p "Press any key to exit."
        exit 1
    fi
else
    echo "Please download and print the checkerboard PDF and place it on a flat surface before proceeding."
    read -n 1 -s -r -p "Press any key to exit."
    exit 1
fi

# Run the camera calibrator in a new terminal
gnome-terminal -- bash -c "ros2 run camera_calibration cameracalibrator --size 7x9 --square 0.02 --ros-args -r image:=/image_raw -p camera:=/camera; exec bash"

# Wait for the user to complete the calibration
read -n 1 -s -r -p "After the camera calibration is complete, press any key in this terminal to save the calibration configuration."

# Uncompress the calibration data
cd /tmp
tar -xvf /tmp/calibrationdata.tar.gz

# Modify the camera_name in the yaml file
sed -i '/camera_name:/s/.*/camera_name: mmal_service_16.1/' ost.yaml

# Remind users to input IP address and password
sudo apt install sshpass -y
clear
read -p "Please enter the remote server IP address: " remote_host
read -s -p "Please enter the remote server password: " remote_password
echo " "
username="ubuntu"

# Transfer local file to remote server
echo "Deleting existing camera calibration files in pupper..."
sshpass -p "$remote_password" ssh -o StrictHostKeyChecking=no $username@$remote_host 'sudo rm -rf ~/.ros/camera_info/*'
echo "Transferring file..."
sshpass -p "$remote_password" scp /tmp/ost.yaml $username@$remote_host:~/.ros/camera_info/mmal_service_16.1.yaml
sshpass -p "$remote_password" ssh $username@$remote_host 'chmod 777 ~/.ros/camera_info/mmal_service_16.1.yaml'

# Reboot after transfer completion
read -p "Transfer complete,Press Enter to continue...
Don't forget to reboot pupper."
#sshpass -p "$remote_password" ssh $username@$remote_host 'sudo reboot'
