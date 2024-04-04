function image_x = importimage(path)
    image_x = imread(path);
    image_x = rgb2gray(image_x);

    image_x = double(image_x(:, :, 1));
    mn = min(image_x(:));
    image_x = image_x - mn;
    mx = max(image_x(:));
    image_x = image_x/mx;
end