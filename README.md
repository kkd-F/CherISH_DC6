# CherISH-DC6
CherISH DC6 Programming Excercise: Please download the code as zip file, unzip the file and add the folder to path. 
Then you can see the results of following tasks by running the script CherISH_DC6.m

### 1. Create a Gaussian white noise burst 
with a duration of 1 sec and smooth on/offset ramps of 10 msec. 
[Recommendation: use sampling rate consistent with HRTF set, see point 2]

### 2. Create 3 spatial trajectories for this noise burst 
using the HRTF set SCUT_KEMAR_radius_all.sofa 
(available at https://sofacoustics.org/data/database/scut/) 
[Recommendation: use the most recent version of SOFAspat available at https://github.com/sofacoustics/SOFAtoolbox/blob/master/SOFAtoolbox/SOFAspat.m]: 
* Horizontal clockwise rotation around the listener at a distance of 1 m (varying azimuth, 0° elevation, 1 m radius)
* Approach from left (90° azimuth, 0° elevation, radius decreasing from 1 m to 0.2 m)
* Approach from front (0° azimuth, 0° elevation, radius decreasing from 1 m to 0.2 m)

### 3. Plot the spectrograms of the generated sounds 
Limit the plotted dynamic range to 60 dB. 
[Recommendation: use sgram from LTFAT (dependency of SOFAtoolbox)]
