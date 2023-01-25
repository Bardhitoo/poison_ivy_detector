function Show_Color_Separations_hsv(im)
    im = rgb2hsv(im);
    figure('Position', [10 10 1400 1200] )
    subplot(2, 2, 1)
    imshow(im)
    title("Full Color", 'FontSize', 10)

    subplot(2, 2, 2)
    imshow(im(:, :, 1), [])
    title("Hue", 'FontSize', 10)

    subplot(2, 2, 3)
    imshow(im(:, :, 2), [])
    title("Saturation", 'FontSize', 10)

    subplot(2, 2, 4)
    imshow(im(:, :, 3), [])
    title("Value", 'FontSize', 10)

end