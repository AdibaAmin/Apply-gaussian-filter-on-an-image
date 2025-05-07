% Read and convert the image to grayscale if needed
img = imread('A1_20200204012.png');
if ndims(img) == 3
    img = rgb2gray(img);
end
img = double(img);
[rows, cols] = size(img);

% Define Prewitt kernels (3x3)
PrewittX = [-1  0  1;
            -1  0  1;
            -1  0  1];

PrewittY = [-1 -1 -1;
             0  0  0;
             1  1  1];

% Manual zero-padding
 % Padding width: one pixel on each side
padded_rows = rows + 2 * 1;
padded_cols = cols + 2 * 1;
padded_img = zeros(padded_rows, padded_cols);  % Create a matrix of zeros

% Copy the original image into the center of the padded image
for i = 1:rows
    for j = 1:cols
        padded_img(i + 1, j + 1) = img(i, j);
    end
end

% Apply Prewitt filter manually
gradient_magnitude = zeros(rows, cols);

for i = 1:rows
    for j = 1:cols
        % Extract the current 3x3 region from the padded image
        region = padded_img(i:i+2, j:j+2);
        % Compute horizontal and vertical gradients
        gx = sum(region(:) .* PrewittX(:));
        gy = sum(region(:) .* PrewittY(:));
        % Compute the gradient magnitude (edge strength)
        gradient_magnitude(i, j) = sqrt(gx^2 + gy^2);
    end
end

% Normalize the result to be in range [0,255]
gradient_magnitude = gradient_magnitude / max(gradient_magnitude(:)) * 255;
gradient_magnitude = uint8(gradient_magnitude);

% Display original and filtered images
figure;
subplot(1,2,1), imshow(uint8(img)), title('Original Image');
subplot(1,2,2), imshow(gradient_magnitude), title('Prewitt Edge Detection');
