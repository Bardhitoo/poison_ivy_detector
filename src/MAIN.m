%
%	Contributors of this project are:
%		* Bardh Rushiti
%		* Mohd Junaid Shaikh
%		* Saksham Bansal
%

function MAIN(filename)
    clc
    close all

    addpath("../data/poison-ivy");    
    addpath("../data/other");    
    
    % Argument Initialization
    FS = 15;
    SHOW_CIRCLE = false;
    SHOW_WATERSHED = false;
    SHOW_IMG_COLORSPACES = false;
    SHOW_KMEANS_IMG = false;
    SHOW_CORNERS = false;
    SHOW_STRONG_EDGES = false;
    
    %classification score
    score = 3;
    
    fprintf('INPUT Filename: \t%s\n', filename );

    % Read image as double
    readImg = imread( filename ); 
    image = im2double( readImg );

    % Quantize image by a factor of 16 to reduce noise
    image_quantized = round(image * 16) / 16;

    % Resizing the original image
    image = imresize(image, [4000 6000]);
    image = imresize(image, 0.3);

    % Resizing the quantized image
    image_quantized = imresize(image_quantized, [4000 6000]);
    image_quantized = imresize(image_quantized, 0.3);
    
    %% Radius Mask 
    %
    %   Radius of different size images always takes the height of the
    %   image and multiplies by 75% -> giving us a region of interest.
    %    

    im_dims = size(image);
    ratio = im_dims(1) / im_dims(2); % height / width

    % If the height is smaller than the width -> use height as the distance
    % to create the circle. Else, use width.
    if ratio < 1
        radius = im_dims(1)  / 2;
    else
        radius = im_dims(2) / 2;
    end

    % Masked image
    mask = extractCircle(image, radius, SHOW_CIRCLE); 
    image = image .* double(mask);
    image_quantized = image_quantized .* double(mask);

    % Display color separations for exploration
    if SHOW_IMG_COLORSPACES
        show_color_separations_rgb(image);
        show_color_separations_hsv(image);
        show_color_separations_lab(image);
    end

    %% Strong Edge Detection
    %
    %   Calculate the 95% percentale of edges in the given image.
    %    

    [strongEdges] = edgesExploration(image);
    
    if SHOW_STRONG_EDGES
        figure, imshow(strongEdges, []);
    end
    
    %% K-Means 1
    %
    %   K-Means as noise reduction
    %

    disp("K-Means 1 - Running...")
    k = 9;
    leafKMeans = KMeans(image_quantized, k, strongEdges, FS, SHOW_KMEANS_IMG);
    
    % Post Processing
    % Remove surfaces smaller than 15000 pixels
    post_processed_leaf = bwareaopen(leafKMeans, 15000, 4);
    post_processed_leaf_2 = imfill(post_processed_leaf, 'holes');
    post_processed_leaf_2 = imerode(post_processed_leaf_2, strel("disk", 2));
    post_processed_leaf_3 = imdilate(post_processed_leaf_2,strel("disk", 20));

    %% K-Means 2
    %
    %   K-Means as segmentation
    %

    disp("K-Means 2 - Running...")
    k = 3;
    image_preKmeans = post_processed_leaf_3 .* image_quantized;

    leafKMeans2 = KMeans(image_preKmeans, k, strongEdges, FS, SHOW_KMEANS_IMG);
   
    % Post Processing
    % Remove surfaces smaller than 15000 pixels
    post_processed_leaf2 = bwareaopen(leafKMeans2, 30000);
    post_processed_leaf2 = imerode(post_processed_leaf2,  strel("disk", 1)); 
    post_processed_leaf2 = bwareaopen(post_processed_leaf2, 10000);
    leaf = ~bwareaopen(~post_processed_leaf2, 500, 4);  
    
    %% Watershed Segmentation

    result_props = regionprops(leaf);
    
    % One gigantic blob (potentially 3 leafs)
    if sum([result_props.Area] > 160000) > 0
        mask = watershed_exploration(leaf, SHOW_WATERSHED);
        leafs_im = ~mask .* leaf;
    else
        leafs_im = leaf;
    end
    
    % watershed post processing
    leafs_im = bwareaopen(leafs_im, 15000);

    %% Neural Network Prediction

    disp("Neural Network Running...")

    % loading the trained resnet50 neural network
    load("resnet50/final_network_params.mat")

    % classifying the image provided using network
    res = categorical("ivy") == classify(trainedNetwork_1, imresize(readImg, [224 224]));

    %% Count Large Components (Number of leaves)

    disp("Counting number of leaves...")
    num_leafs = length(regionprops(bwlabel(leafs_im)));
    
    if num_leafs ~= 3
        if num_leafs == 0
            fprintf("\nNo leaves present"); 
            quit;
        end
        % decrement the classification score if it does not have 3 leaves
        score = score - 1;
    end
    
    %% Corner Detection
    
    totalCorners = 0;
    
    [labels, numLabels] = bwlabel(leafs_im);

    disp("Finding corners...")
    
    % Find eigen corners on each leaf separately

    for i = 1: numLabels
        comp = labels == i;

        % Gaussian blurring for noise reduction
        compGauss = imgaussfilt(im2double(comp), 2);
        
        % detecting edges around the leaf using sobel edge detector
        compEdge = edge(compGauss, "sobel");

        % detecting corners on the edges of the leaf
        eigenPoints = detectMinEigenFeatures(compEdge, "MinQuality",0.65, "FilterSize",15);

        % extracting important corners
        [features, valid_eigen_corners] = extractFeatures(compEdge, eigenPoints);
        
        if SHOW_CORNERS
            
            figure, imagesc(compEdge);
            title("Eigen");
            axis image;
            hold on
    
            % plot the corners
            for idx = 1 : length(valid_eigen_corners)
                point = valid_eigen_corners(idx).Location;
                plot(point(1), point(2), 'cs', 'MarkerSize', 10, 'LineWidth', 1);
            end 

        end

        totalCorners = totalCorners + length(valid_eigen_corners);
    end

    % decrement the classification score if total corners are above the
    % threshold
    if (totalCorners < 15) || (totalCorners > 25)
        score = score - 1;
    end

    % Final decision based on the classification score
    if score == 0
        disp('Final Decision: NOT A POISON IVY')

    elseif score == 3
        disp('Final Decision: POISON IVY')

    else
        disp('Final Decision: Can be a Poison Ivy')
    end
end