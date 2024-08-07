# Car Camera Player

## About

Allows playback of recordings from the 70mai Dash Cam by placing both front and rear recordings in a single window, with the ability to adjust their layout for easier viewing.

Preview images show possible window position settings.

## Functionality

First, a dialog window opens for file selection. If the file name does NOT match the pattern (length > 7, first 2 letters are "EV" or "NO", last 4 letters are ".mp4", and the fifth letter (recording type) is 'B' or 'F'), a message will be displayed as shown in the first image.

If the file name matches the pattern, the program will create playlist, by searching the directory containing the selected file for all recordings of the same type that also match the pattern.

The next step is to find an alternative recording. If a 'B' (back) recording is selected, the program will look for an 'F' (front) recording, and vice versa. The search starts in the same directory for a file with the same name but a different type. If such a file is found, it is used as the alternative. If the file does not exist, the program searches the parent directory (for example: if the selected file is 'F', the alternative file will be searched in "../Back", and if the selected file is 'B', the alternative file will be searched in "../Front"). These two options were chosen based on how files are organized on my drive. If no alternative file is found in any location, only the selected file will be used.

The interface allows displaying the alternative recording (the smaller one) in five options: [Right Top, Right Bottom, Left Bottom, Left Top, Invisible], adjusting the volume, and swapping the main and alternative recordings.

## Images

![p0](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p0.png "p0") 

![p1](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p1.png "p1") 

![p2](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p2.png "p2") 

![p3](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p3.png "p3") 

![p4](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p4.png "p4") 

![p5](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p5.png "p5") 

![p6](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p6.png "p6") 

![p7](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p7.png "p7") 

![p8](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p8.png "p8") 

![p9](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p9.png "p9") 

![p10](https://github.com/Cezary-Androsiuk/CarCameraPlayer/blob/master/images/p10.png "p10") 
