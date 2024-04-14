function image_x = importimage(path)
    % function that makes image black and white and pixel values between 0
    % and 1
    % INPUTS: filepath to image 
    % OUTPUTS: matrix representing image in black in white with 0 < x < 1

    image_x = imread(path);
    image_x = rgb2gray(image_x);

    image_x = double(image_x(:, :, 1));
    mn = min(image_x(:));
    image_x = image_x - mn;
    mx = max(image_x(:));
    image_x = image_x/mx;
end