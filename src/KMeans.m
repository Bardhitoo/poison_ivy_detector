function [leaf] = KMeans( im , k, edgeMag,  FS, SHOW_RESULT_KMEANS)
    %
    %   Compute Channels of Interest
    %
    im_lab = rgb2lab(im);
    lab_a = im_lab(:, :, 2);
    
    dims = size(im);

    [col, row] = meshgrid(1:dims(2), 1:dims(1));
    
    data = [ 0.05 * col(:), 0.05 * row(:), 2 * lab_a(:), 2 * edgeMag(:)];
     
    %
    %   Compute K-means
    %
    
    [cluster_id, kmeans_center_found] = kmeans( data, k, "MaxIter", 200, 'Replicates', 3,'Distance','sqeuclidean');
    
    %
    %  Convert the results of k-means into an image:
    % 
    
    image_by_id = reshape( cluster_id, size(im,1), size(im,2) );
    
    %
    %   Find Index of Interest
    %
        center = [dims(1)/2, dims(2)/2]; 
        width = 200; 
        height = 200;
    
    regionOfInterest = image_by_id(center(1) - width: center(1) + width, center(2) - height: center(2) + height);
    indexOfInterest = mode(regionOfInterest,'all');

    leaf = image_by_id == indexOfInterest;

    if (SHOW_RESULT_KMEANS)

        figure('Position', [10 10 1400 1200] ), 
        imagesc( image_by_id );
        title("Kmeans Segmentation", 'FontSize', FS)
        axis image;
        colorbar;
    
        figure('Position', [10 10 1400 1200] ), 
        imagesc( leaf );
        title("Poison Ivy Segmented", 'FontSize', FS)
        colormap(gray)
        axis image;
        colorbar;
    end
end

