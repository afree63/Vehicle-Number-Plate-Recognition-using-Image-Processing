% Vehicle Number Plate Recognition (VNPR) in MATLAB

% Read the input image
inputImage = imread('vehicle_image.jpg');

% Display the original image
figure;
imshow(inputImage);
title('Original Image');

% Convert the image to grayscale
grayImage = rgb2gray(inputImage);

% Use edge detection to find edges in the image
edgeImage = edge(grayImage, 'Sobel');

% Display the edge-detected image
figure;
imshow(edgeImage);
title('Edge-detected Image');

% Perform morphological operations to enhance the edges
se = strel('rectangle', [5, 5]);
dilatedImage = imdilate(edgeImage, se);

% Display the dilated image
figure;
imshow(dilatedImage);
title('Dilated Image');

% Find connected components in the image
cc = bwconncomp(dilatedImage);

% Get region properties to filter out small regions
stats = regionprops(cc, 'BoundingBox', 'Area');

% Filter out small regions
validRegions = stats([stats.Area] > 100);

% Display the image with bounding boxes around the detected regions
figure;
imshow(inputImage);
hold on;

for i = 1:numel(validRegions)
    rectangle('Position', validRegions(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

hold off;
title('Detected Regions');

% Extract the license plate region
if ~isempty(validRegions)
    licensePlate = imcrop(inputImage, validRegions(1).BoundingBox);
    
    % Display the extracted license plate
    figure;
    imshow(licensePlate);
    title('Extracted License Plate');
    
    % Perform OCR on the license plate region
    ocrResults = ocr(licensePlate, 'TextLayout', 'Block');
    
    % Display the recognized text
    fprintf('Recognized License Plate: %s\n', ocrResults.Text);
else
    fprintf('No license plate detected.\n');
end
