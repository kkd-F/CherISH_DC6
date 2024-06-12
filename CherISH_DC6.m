%%%%%%%%%%%%% CherISH DC6 - Programming Exercise %%%%%%%%%%%%%%
clear;clc

% Add Packages/paths
zipFilePath = 'SOFAtoolbox-master.zip';
unzipDir = 'SOFAtoolbox';
if ~exist(unzipDir, 'dir')
    unzip(zipFilePath, unzipDir);
end
%restoredefaultpath;
addpath(genpath(fileparts(which("CherISH_DC6.m"))));
pkg load ltfat;
pkg load netcdf;

% Initialization
SOFAstart;
ltfatstart;

% Load HRTF set
hrtf = SOFAload('data/SCUT_KEMAR_radius_all.sofa');

% Parameter configuration
fs = hrtf.Data.SamplingRate;  % sampling rate in hertz
duration_noise = 1;           % duration of noise in second
duration_ramp = 0.01;         % duration of ramp in second
duration_signal = 1.2;        % duration of signal in second



%% 1. Gaussian white noise burst (duration 1 sec, smooth on/offset ramps 10 msec)

t = 0:1/fs:duration_noise-1/fs;               % time vector of noise
t_signal = 0:1/fs:duration_signal-1/fs;       % time vector of signal
n = randn(1, fs);                             % gaussian white noise

% smooth on/offset ramps
l_ramp = fs * duration_ramp;                  % length of ramp
ramp = linspace(0, 1, l_ramp);
s_0 = zeros(1, (length(t_signal) - length(t)) / 2);
s_1 = ones(1, length(n) - 2 * l_ramp);
w = [ramp, s_1, fliplr(ramp)];                % window function
noise = n .* w;                               % noise burst
signal = [s_0, noise, s_0];                   % signal with noise burst

% plot
figure(1);
plot(t_signal, signal, 'b');
grid on;
axis([0,1.2]);
title('Gaussian White Noise Burst');
xlabel('Time (s)');
ylabel('Amplitude');



%% 2. Spatial trajectories for the noise burst

% Load HRTF set
hrtf = SOFAload('data/SCUT_KEMAR_radius_all.sofa');

% Horizontal clockwise rotation around the listener at 1 meter radius
azimuth1 = linspace(0, 360, length(noise));       % Varying azimuth
elevation1 = zeros(size(azimuth1));               % Constant elevation
distance1 = ones(size(azimuth1));                 % Constant radius (1 meter)
spatialized_noise1 = SOFAspat(noise', hrtf, azimuth1, elevation1, distance1); % HRTF
spatialized_noise1 = spatialized_noise1(1:length(t), :);    % Match length

% Approach from left (90 degrees azimuth, decreasing radius from 1 meter to 0.2 meters)
azimuth2 = 90 * ones(size(noise));                % Constant azimuth
elevation2 = zeros(size(azimuth2));               % Constant elevation
distance2 = linspace(1, 0.2, length(noise));      % Decreasing radius
spatialized_noise2 = SOFAspat(noise', hrtf, azimuth2, elevation2, distance2); % HRTF
spatialized_noise2 = spatialized_noise2(1:length(t), :);    % Match length

% Approach from front (0 degrees azimuth, decreasing radius from 1 meter to 0.2 meters)
azimuth3 = zeros(size(noise));                    % Constant azimuth
elevation3 = zeros(size(azimuth3));               % Constant elevation
distance3 = linspace(1, 0.2, length(noise));      % Decreasing radius
spatialized_noise3 = SOFAspat(noise', hrtf, azimuth3, elevation3, distance3); % HRTF
spatialized_noise3 = spatialized_noise3(1:length(t), :);    % Match length

% Plot spatialized noises (both channels)
figure(2);

subplot(3,1,1);
plot(t, spatialized_noise1(:,1), t, spatialized_noise1(:,2));
title('Spatialized Noise 1: Horizontal Rotation');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, spatialized_noise2(:,1), t, spatialized_noise2(:,2));
title('Spatialized Noise 2: Approach from Left');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, spatialized_noise3(:,1), t, spatialized_noise3(:,2)); % Plot both channels
title('Spatialized Noise 3: Approach from Front');
xlabel('Time (s)');
ylabel('Amplitude');



%% 3. Spectrograms of the generated sounds (each channel)
figure(3);

subplot(3, 2, 1);
sgram(spatialized_noise1(:, 1), fs, 'dynrange', 60);
title('Spectrogram of Horizontal Rotation Noise (Left)');

subplot(3, 2, 2);
sgram(spatialized_noise1(:, 2), fs, 'dynrange', 60);
title('Spectrogram of Horizontal Rotation Noise (Right)');

subplot(3, 2, 3);
sgram(spatialized_noise2(:, 1), fs, 'dynrange', 60);
title('Spectrogram of Approach from Left Noise (Left)');

subplot(3, 2, 4);
sgram(spatialized_noise2(:, 2), fs, 'dynrange', 60);
title('Spectrogram of Approach from Left Noise (Right)');

subplot(3, 2, 5);
sgram(spatialized_noise3(:, 1), fs, 'dynrange', 60);
title('Spectrogram of Approach from Front Noise (Left)');

subplot(3, 2, 6);
sgram(spatialized_noise3(:, 2), fs, 'dynrange', 60);
title('Spectrogram of Approach from Front Noise (Right)');



%------------------------------------------------------------
%                         Yifei Li
%                   Updated on 12/06/2024
%------------------------------------------------------------
