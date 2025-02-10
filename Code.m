clear
clc

% Load templates and input image
template_happy = imread('template_happy.jpg');
template_sad = imread('template_sad.jpg');
input_img = imread(['input8.jpg']);

% Resize templates and input image
template_happy = imresize(template_happy, [400, 300]);
template_sad = imresize(template_sad, [400, 300]);
input_img = imresize(input_img, [400, 300]);

% Convert templates to grayscale
template_happy_gray = rgb2gray(template_happy);
template_sad_gray = rgb2gray(template_sad);

% Convert input image to grayscale
img_gray = rgb2gray(input_img);
img_blurred = imgaussfilt(img_gray, 2);
edges = edge(img_blurred, 'canny');

% Use template matching for happy template
corr_result_happy = normxcorr2(template_happy_gray, img_gray);
[y_peak_happy, x_peak_happy] = find(corr_result_happy == max(corr_result_happy(:)));

% Use template matching for sad template
corr_result_sad = normxcorr2(template_sad_gray, img_gray);
[y_peak_sad, x_peak_sad] = find(corr_result_sad == max(corr_result_sad(:)));

% Display templates and input image
figure;
subplot(1,3,1);
imshow(template_happy);
title('Happy Template');

subplot(1,3,2);
imshow(template_sad);
title('Sad Template');

subplot(1,3,3);
imshow(input_img);
title('Input Image');

% Convert input image to binary
binary_img = imbinarize(img_gray, 'adaptive'); % thresholding method

% Use regionprops for further processing
stats = regionprops(binary_img, 'Area', 'Centroid', 'BoundingBox');

% Determine emotion based on the highest correlation result and region properties
threshold_happy = 0.4; % Adjust as needed
threshold_sad = 0.8;   % Adjust as needed

if max(corr_result_happy(:)) > threshold_happy && max(corr_result_happy(:)) > max(corr_result_sad(:)) && max([stats.Area]) > threshold_happy
    disp('Happy expression detected!');
elseif max(corr_result_sad(:)) > threshold_sad && max(corr_result_sad(:)) > max(corr_result_happy(:)) && max([stats.Area]) > threshold_sad
    disp('Sad expression detected');
else
    disp('Uncertain mood');
end