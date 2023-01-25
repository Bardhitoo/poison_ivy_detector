function [mask] = extractCircle(image, radius, showImg)
    % get the center of image and generate a meshgrid
    dims = size(image);
    center = [round(dims(2)/2)  round(dims(1)/2)];
    [xs, ys] = meshgrid(1:dims(2), 1:dims(1));

    % calculate euclidean distance of points from the center
    dist = sqrt((xs - center(1)).^2 + (ys - center(2)).^2);
    % keep points that fall within the radius of the desired size
    mask = dist <= radius;
end

