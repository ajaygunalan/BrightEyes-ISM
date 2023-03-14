%% Design the sampling matrix
clear; close all; clc;
image_rows = 513;
image_cols = 513;
[A, samplerMatrix, samplerLinearIdx, CR] = DesignSamplingMatrix(image_rows, image_cols);

%% Do the SPAD array in loop.
N = 9;
detector = zeros(image_rows, image_cols, N);
detector_measurments = zeros(image_rows, image_cols, N);
detector_recon = zeros(image_rows, image_cols, N);
for i = 1:N
    img_name = ['data/detector_', num2str(i), '.png'];
    img = imread(img_name);
 
    img_processed = preprocess(img, image_rows, image_cols);
    
    % Store resized image in detector array
    detector(:, :, i) = img_processed;
    
    % Perform some operations on the image here, if needed
    % Show the image
    imshow(detector(:, :, i));
    
    %% Define the image going to be sample
    sample = detector(:, :, i);
    %% Get Measurments
    detector_measurments(:,:,i) = samplerMatrix.*sample;
    %% Save measurments in a separate file
    imwrite(detector_measurments(:,:,i), ['data/measure_', num2str(i), '.png']);
    x =  sample(:);
    y = x(samplerLinearIdx);
    %% Reconstruct it
    [detector_recon(:,:,i), t] = csAj(A, y, image_rows, image_cols);
    
    %% Save reconstructed image in a separate file
    imwrite(detector_recon(:,:,i), ['data/recon_', num2str(i), '.png']);
    
end