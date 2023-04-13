# Calibrate RPi Camera in Your Mini Pupper


## Step 1: Prepare Calibration Materials

### 1. Download the Checkerboard

You can create your checkerboard from [calib.io](https://calib.io/pages/camera-calibration-pattern-generator). The checkerboard parameters should be:

| Parameter | Value |
| --- | --- |
| Target Type | Checkerboard |
| Board Width | 297 |
| Board Height | 210 |
| Rows | 8 |
| Columns | 10 |
| Checker Width | 20 |

Alternatively, you can find **a checkerboard we prepared** in `/camera_calibration` named `calib.io_checker_297x210_8x10_20.pdf`.

### 2. Print the Checkerboard

Print the checkerboard on A4 paper.

### 3. Attach the Checkerboard to a Flat Surface

Attach the checkerboard to a flat surface, such as the surface of a box or a large flat board.
![cable_and_camera](/imgs/camera_checkerboard.jpg) 
## Step 2: Check Your Camera Node


Start the monocular camera node that publishes a valid topic `/image_raw`.

## Step 3: Run the Camera Calibration Script

Run the script and follow the instructions in the terminal:

```bash
cd ~/mini_pupper_2_bsp/RPiCamera/camera_calibration
. camera_calibrate.sh
```

Note: This bash script is based on the [Nav2 tutorial for camera calibration](https://navigation.ros.org/tutorials/docs/camera_calibration.html). For more information about camera calibration, please refer to it.

## Step 4: Calibrate

To achieve high-quality calibration results during camera calibration, it is important to pay attention to the following aspects of motion:

1.  Translation: To cover all possible positions of the calibration board, different translation motions can be used, such as moving forward/backward, left/right, up/down, or a combination of these motions. When moving the camera, it is important to keep its optical axis perpendicular to the calibration board and ensure that the calibration board's pattern is fully captured by the camera.
    
2.  Rotation: To cover all possible orientations of the camera, different rotation motions can be used, such as rotating around the camera's optical axis, horizontal axis, vertical axis, or a combination of these rotations. When rotating the camera, it is important to keep the calibration board's plane perpendicular to the camera's optical axis and ensure that the calibration board's pattern is fully captured by the camera.
    
3.  Different Distances and Angles: To capture the calibration board's image at different distances and angles, different distances and angles can be used, such as close distance, far distance, different heights, different angles, or a combination of these distances and angles. When capturing the calibration board's image, it is important to ensure that the pattern is fully captured by the camera and the calibration board's edges are not cut off.
    

In summary, the motion during camera calibration should be as diverse as possible to ensure the accuracy and robustness of the calibration results. When capturing the calibration board's image, it is important to avoid factors that could affect the image quality, such as occlusion, motion blur, and mirror reflection, to obtain clear and accurate calibration images.

## Step 5: Reboot and Check Performance
### Reboot the Mini Pupper and Check Topic Information

SSH to your pupper and reboot it:

```bash
sudo reboot
```

SSH to your pupper and check topic information:

```bash
ros2 topic echo /camera_info
```

The information in `/camera_info` should be the same as the calibration configuration files on your PC:

```bash
cat /tmp/ost.yaml  # on your PC
```
### Run camera RViz demo
Performance developed.

TODO