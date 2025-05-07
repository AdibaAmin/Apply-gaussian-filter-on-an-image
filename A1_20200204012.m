% Read and convert the image to grayscale if needed
img = imread('A1_20200204012.png');  % Replace with your image file
if ndims(img) == 3
    img = rgb2gray(img);
end
img = double(img);
[rows, cols] = size(img);

% Define Gaussian filter parameters
kernel_size = 7;  % Size of the Gaussian kernel 
sigma = input('Enter sigma value: ');      % Standard deviation of the Gaussian
half_k = floor(kernel_size / 2);

% Create Gaussian kernel manually (without meshgrid)
gaussian_kernel = zeros(kernel_size, kernel_size);
for i = 1:kernel_size
    for j = 1:kernel_size
        % Calculate x and y offsets from the center of the kernel
        x = j - (half_k + 1);
        y = i - (half_k + 1);
        gaussian_kernel(i, j) = exp(-(x^2 + y^2) / (2 * sigma^2)) / (2 * pi * sigma^2);
    end
end
% Normalize the kernel so that the sum is 1
gaussian_kernel = gaussian_kernel / sum(gaussian_kernel(:));

% Manual zero-padding of the image (padding of half_k pixels on each side)
padded_rows = rows + 2 * half_k;
padded_cols = cols + 2 * half_k;
padded_img = zeros(padded_rows, padded_cols);
for i = 1:rows
    for j = 1:cols
        padded_img(i + half_k, j + half_k) = img(i, j);
    end
end

% Apply Gaussian filter manually using convolution
filtered_img = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        % Extract the region of the padded image that corresponds to the kernel
        region = padded_img(i:i + kernel_size - 1, j:j + kernel_size - 1);
        % Multiply element-wise with the Gaussian kernel and sum to get the new pixel value
        filtered_img(i, j) = sum(region(:) .* gaussian_kernel(:));
    end
end

% Normalize the filtered image to the range [0,255] for display
filtered_img = filtered_img - min(filtered_img(:));
filtered_img = filtered_img / max(filtered_img(:)) * 255;
filtered_img = uint8(filtered_img);

% Display original and Gaussian filtered images side by side
figure;
subplot(1,2,1), imshow(uint8(img)), title('Original Image');
subplot(1,2,2), imshow(filtered_img), title('Gaussian Filtered Image');
