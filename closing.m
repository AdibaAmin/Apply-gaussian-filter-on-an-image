% closing.m
% This script performs a morphological closing on an image.
% Closing is defined as dilation followed by erosion using a 3x3 structuring element.

% Read image and convert to grayscale if needed
img = imread('A1_20200204012.png');  % Replace with your image file
if ndims(img) == 3
    img = rgb2gray(img);
end
img = double(img);

% Convert image to binary using a manual threshold
bw = img > 128;

% Define a 3x3 structuring element (all ones)
se = ones(3,3);
[se_rows, se_cols] = size(se);
half_r = floor(se_rows/2);
half_c = floor(se_cols/2);

%padding on bw image
[rows, cols] = size(bw);               % Get the dimensions of the binary image
padded_rows = rows + 2 * half_r;         % Total rows after padding
padded_cols = cols + 2 * half_c;         % Total columns after padding

% Create a new matrix filled with zeros for the padded image
padded_bw = zeros(padded_rows, padded_cols);

% Copy the original image into the center of the padded image
for i = 1:rows
    for j = 1:cols
        padded_bw(i + half_r, j + half_c) = bw(i, j);
    end
end


% Dilation Step

dilated_img = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        region = padded_bw(i:i+se_rows-1, j:j+se_cols-1);
        if any(region(se == 1))
            dilated_img(i, j) = 1;
        else
            dilated_img(i, j) = 0;
        end
    end
end

%padding on dilated img
[rows, cols] = size(dilated_img);               % Get the dimensions of the binary image
padded_rows = rows + 2 * half_r;         % Total rows after padding
padded_cols = cols + 2 * half_c;         % Total columns after padding

% Create a new matrix filled with zeros for the padded image
padded_dilated = zeros(padded_rows, padded_cols);

% Copy the original image into the center of the padded image
for i = 1:rows
    for j = 1:cols
        padded_dilated(i + half_r, j + half_c) = dilated_img(i, j);
    end
end


% Erosion Step on the Dilated Image

closed_img = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        region = padded_dilated(i:i+se_rows-1, j:j+se_cols-1);
        if all(region(se == 1))
            closed_img(i, j) = 1;
        else
            closed_img(i, j) = 0;
        end
    end
end

% Display the results: original, dilated, and closed images
figure;
subplot(1,3,1), imshow(bw), title('Original Binary Image');
subplot(1,3,2), imshow(dilated_img), title('Dilated Image');
subplot(1,3,3), imshow(closed_img), title('Closed Image');
