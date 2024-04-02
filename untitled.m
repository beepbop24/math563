
%% CODE TO TEST ALGORITHMS
% cameraman -- importing image + kernel and noise

image_x = imread("testimages/cameraman.jpg");
image_x = rgb2gray(image_x);

image_x = double(image_x(:, :, 1));
mn = min(image_x(:));
image_x = image_x - mn;
mx = max(image_x(:));
image_x = image_x/mx;

%resizefactor = 0.1;
%image_x = imresize(image_x, resizefactor);

kernel = fspecial('gaussian', [10 10], 15);

b = imfilter(image_x, kernel);
b = imnoise(b,'salt & pepper', 0.5);

% show image for test
figure('Name','original image')
imshow(image_x,[])

figure('Name','image before deblurring')
imshow(b,[])

%% DEFAULT PARAMETER VALUES
% maximum number of iterations
i.maxiter = 500;

% denoising for l1 and l2 loss
i.gammal1 = 0.049;
i.gammal2 = 0.049;

% relaxation parameter (rho in (0, 2)) and step size t > 0 for Primal
% Douglas-Rachford Splitting
i.rhoprimaldr = 2.0;
i.tprimaldr = 0.1;

% relaxation parameter (rho in (0, 2)) and step size t > 0 for Primal Dual
% Douglas-Rachford Splitting
i.rhoprimaldualdr = 1.5;
i.tprimaldualdr = 0.05;

% step size parameters for the Chambolle-Pock Algorithm
i.tcp = 0.1;
i.scp = 0.1;


%% TEST ALGO 1
[applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, i.tcp);

[m, n] = size(b);
z1_0 = image_x; %rand(m, n);
z21_0 = applyK(z1_0);
z22_0 = applyD1(z1_0);
z23_0 = applyD2(z1_0);

z2_0 = cat(3, z21_0, z22_0, z23_0);

problem = 'l1';
[norm_prox, gamma] = proxproblem(problem, i);
tol = 10;

[deblurred_x, k, loss] = chambollepock(b, image_x, 0.01, 0.01, 0.5, i.maxiter, tol, z1_0, z2_0, z1_0, kernel, norm_prox);

figure();
imshow(deblurred_x,[])
     