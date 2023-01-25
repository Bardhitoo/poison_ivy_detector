function [mask] = watershed_exploration(im, SHOW_WATERSHED)
    % Compute the euclidian distance of the inverse of the given image.
    % This implies that the region of interest is black, among a white
    % background
    negD = ~im;
    D = bwdist(negD);
    
    xm = imextendedmin(1-D, 10);
    Lim = watershed(bwdist(xm), 4);
    em = Lim == 0;

    % Dilate the mask generated
    mask = imdilate(em, strel("disk", 2));

    if SHOW_WATERSHED
        figure, imshow(im), title("temp")
        figure, imshow(D, []), title("D")
        figure, imshow(mask), title("mask")
        
        figure, imshow(imfuse(em, D))
    end
end