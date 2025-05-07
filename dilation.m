% Read and convert the image to grayscale if needed
img = imread('A1_20200204012.png');  % Replace with your image file name
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

% Pad the binary image with zeros to handle borders
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

dilated_img = zeros(rows, cols);

% Perform dilation manually
for i = 1:rows
    for j = 1:cols
        region = padded_bw(i:i+se_rows-1, j:j+se_cols-1);
        % Set output pixel to 1 if any pixel in the region (where se==1) is 1
        if any(region(se == 1))
            dilated_img(i, j) = 1;
        else
            dilated_img(i, j) = 0;
        end
    end
end

% Display the original and dilated images
figure;
subplot(1,2,1), imshow(bw), title('Original Binary Image');
subplot(1,2,2), imshow(dilated_img), title('Dilated Image');
