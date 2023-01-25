function [strongEdges] = edgesExploration(im_g)

    SHOW_EDGE_COMPONENTS = false;
    FS = 15;
    
    im_g = rgb2lab(im_g);

    im_g = im_g(:, :, 2);

    % sobel filtering edges along x, sweeping in both directions
  
    f_sobel_dIdx = [ -1 -2 -3 -2 -1 ; 
                      0  0  0  0  0 ; 
                      0  0  0  0  0 ;
                      0  0  0  0  0 ;
                     +1 +2 +3 +2 +1 ] /(4*9);


    f_sobel_dIdx_ = [+1 +2 +3 +2 +1 ; 
                      0  0  0  0  0 ;
                      0  0  0  0  0 ;
                      0  0  0  0  0 ;
                     -1 -2 -3 -2 -1 ] /(4*9);


    % sobel filtering edges along y, sweeping in both directions
    f_sobel_dIdy   = f_sobel_dIdx.';
    f_sobel_dIdy_  = f_sobel_dIdx_.';
    
    % applying filter across all directions
    dIdx            = imfilter( im_g, f_sobel_dIdx, 'same', 'repl' );
    dIdy            = imfilter( im_g, f_sobel_dIdy, 'same', 'repl' );
    dIdx_           = imfilter( im_g, f_sobel_dIdx_, 'same', 'repl' );
    dIdy_           = imfilter( im_g, f_sobel_dIdy_, 'same', 'repl' );

    % Finding edge magnitudes
    dImag           = sqrt( dIdy.^2  + dIdx.^2 + dIdy_.^2  + dIdx_.^2);
    
    if ( SHOW_EDGE_COMPONENTS )
        figure('Position', [10 10 1800 1400] );
        subplot( 2, 2, 1 );
        imagesc( im_g ); colormap( gray ); axis image; title('Imput Image', 'FontSize', FS );
    
        subplot( 2, 2, 2 );
        imagesc( dIdx ); colormap( gray ); axis image;  title('dIdx', 'FontSize', FS );
    
        subplot( 2, 2, 3 );
        imagesc( dIdy ); colormap( gray ); axis image; title('dIdy', 'FontSize', FS );
    
        subplot( 2, 2, 4 );
        imagesc( dImag ); 
        colormap( gray ); 
        axis image;
        title('Edge Magnitude', 'FontSize', FS );
        colorbar;
    end 
   
    % getting the 95th percentile value
    edgeStrength = prctile(dImag(:), 95);
    % make a mask of all the values greater than the 95th percentile
    strongMask = dImag > edgeStrength;
    % apply mask to the edges 
    strongEdges = strongMask .* dImag;
end
