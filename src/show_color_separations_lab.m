function Show_Color_Separations_Lab(im)
    im = rgb2lab(im);
    figure('Position', [10 10 1400 1200] )
    subplot(2, 2, 1)
    imshow(im)
    title("Full Color", 'FontSize', 10)

    subplot(2, 2, 2)
    imshow(im(:, :, 1), [])
    title("L", 'FontSize', 10)

    subplot(2, 2, 3)
    imshow(im(:, :, 2), [])
    title("a*", 'FontSize', 10)

    subplot(2, 2, 4)
    imshow(im(:, :, 3), [])
    title("b*", 'FontSize', 10)

end