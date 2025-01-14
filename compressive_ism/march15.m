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
    img_name = ['data/temp/detector_', num2str(i), '.png'];
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
    imwrite(detector_measurments(:,:,i), ['data/temp/measure_', num2str(i), '.png']);
    x =  sample(:);
    y = x(samplerLinearIdx);
    %% Reconstruct it
    [detector_recon(:,:,i), t] = csAj(A, y, image_rows, image_cols);
    
    %% Save reconstructed image in a separate file
    imwrite(detector_recon(:,:,i), ['data/temp/recon_', num2str(i), '.png']);
    
end

%% Calculate Results
image_rows = 513;
image_cols = 513;

% Read the images using the imread function
confocal = imread('data/temp/Confocal-LSM.png');
compressive_confocal = imread('data/temp/Compressive-Confocal-LSM.png');
ism_apr = imread('data/temp/ISM-APR.png');
compressive_ism_apr = imread('data/temp/Compressive-ISM-apr.png');
ism_deconv = imread('data/temp/ISM-Deconvolution.png');
compressive_ism_deconv = imread('data/temp/Compressive-ISM-Deconvolution.png');

% Apply the preprocess function to each image
confocal = preprocess(confocal, image_rows, image_cols);
compressive_confocal = preprocess(compressive_confocal, image_rows, image_cols);
ism_apr = preprocess(ism_apr, image_rows, image_cols);
compressive_ism_apr = preprocess(compressive_ism_apr, image_rows, image_cols);
ism_deconv = preprocess(ism_deconv, image_rows, image_cols);
compressive_ism_deconv = preprocess(compressive_ism_deconv, image_rows, image_cols);

% Define a list of image pairs
image_pairs = {confocal, compressive_confocal; ism_apr, compressive_ism_apr; ism_deconv, compressive_ism_deconv};

% Initialize the results table
results = cell(size(image_pairs, 1), 11);
column_names = {'RelErr', 'MSE', 'PSNR', 'NCC', 'AD', 'SC', 'MD', 'NAE', 'RMSE', 'UQI', 'EME_baseLine', 'EME_reconImg', 'PCC', 'MAE'};

% Calculate the errors for each pair of images using a loop
for i = 1:size(image_pairs, 1)
    % Calculate the relative error
    results{i, 1} = RelErr(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Relative error for pair ' num2str(i) ': ' num2str(results{i, 1})]);
    
    % Calculate the mean square error
    results{i, 2} = MeanSquareError(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Mean Square Error for pair ' num2str(i) ': ' num2str(results{i, 2})]);
    
    % Calculate the peak signal-to-noise ratio
    results{i, 3} = PeakSignaltoNoiseRatio(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Peak Signal to Noise Ratio for pair ' num2str(i) ': ' num2str(results{i, 3})]);
    
    % Calculate the normalized cross-correlation
    results{i, 4} = NormalizedCrossCorrelation(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Normalized Cross-Correlation for pair ' num2str(i) ': ' num2str(results{i, 4})]);
    
    % Calculate the average difference
    results{i, 5} = AverageDifference(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Average Difference for pair ' num2str(i) ': ' num2str(results{i, 5})]);
    
    % Calculate the structural content
    results{i, 6} = StructuralContent(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Structural Content for pair ' num2str(i) ': ' num2str(results{i, 6})]);
    
    % Calculate the maximum difference
    results{i, 7} = MaximumDifference(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Maximum Difference for pair ' num2str(i) ': ' num2str(results{i, 7})]);
    
    % Calculate the normalized absolute error
    results{i, 8} = NormalizedAbsoluteError(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Normalized Absolute Error for pair ' num2str(i) ': ' num2str(results{i, 8})]);
    
    % Calculate the MSE and RMSE
    [mse , rmse] = RMSE2(image_pairs{i, 1}, image_pairs{i, 2});
    results{i, 9} = rmse;
    disp(['Root Mean Square Error ' num2str(i) ': ' num2str(results{i, 9})]);
    
    % Calculate the Universal Quality Index
    results{i, 10} = imageQualityIndex(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['Universal Quality Index ' num2str(i) ': ' num2str(results{i, 10})]);
 
    % Calculate the enhancement or measure of improvement
    results{i, 11} = eme(image_pairs{i, 1}, image_rows ,8);
    disp(['EME (baseline) ' num2str(i) ': ' num2str(results{i, 11})]);
    results{i, 12} = eme(image_pairs{i, 1}, image_rows, 8);
    disp(['EME (baseline) ' num2str(i) ': ' num2str(results{i, 12})]);
    
    % Calculate the Pearson Correlation Coefficient
    results{i, 13} = compute_PearsonCorrelationCoefficient(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['PearsonCorrelationCoefficient (baseline vs reconImg) ' num2str(i) ': ' num2str(results{i, 13})]);

    % Mean absolute error, MAE
    results{i, 14} = meanAbsoluteError(image_pairs{i, 1}, image_pairs{i, 2});
    disp(['MAE (image pair ' num2str(i) ') = ' num2str(results{i, 14})]);

end
% Convert the results cell array to a table
results_table = cell2table(results, 'VariableNames', column_names);

% Write the table to a CSV file
writetable(results_table, 'data/temp/results.csv');







% % Define the output file path
% output_file_path = 'image_quality_metrics.csv';
% % Open the output file for writing
% output_file = fopen(output_file_path, 'w');
% 
% % Write the header row to the output file
% header_row = ['Image Pair,'];
% for i = 1:length(error_function_names)
%     header_row = [header_row, error_function_names{i}, ','];
% end
% header_row = [header_row(1:end-1), '\n'];
% fprintf(output_file, header_row);
% 
% % Loop over each image pair and calculate the error metrics
% for i = 1:size(image_pairs, 1)
%     % Get the current image pair
%     img_pair = image_pairs(i,:);
%     
%     % Calculate the error metrics for the current image pair
%     row = ['Image Pair ' num2str(i) ','];
%     for j = 1:length(error_functions)
%         error_func = error_functions{j};
%         error_name = error_function_names{j};
%         error_value = error_func(img_pair{1}, img_pair{2});
%         row = [row, num2str(error_value), ','];
%     end
%     row = [row(1:end-1), '\n'];
%     
%     % Write the error metrics for the current image pair to the output file
%     fprintf(output_file, row);
% end
% 
% % Close the output file
% fclose(output_file);
% 
% % Display a message indicating that the results have been saved
% disp(['Results saved to file: ' output_file_path]);
