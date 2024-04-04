
%% DIFFERENT IMAGES & KERNELS TO TEST ALGORITHMS
% img 1 -- most tests (small image)
image_x = importimage("testimages/cameraman.jpg");

kernel = fspecial('gaussian', [10 10], 15);

b = imfilter(image_x, kernel);
b = imnoise(b,'salt & pepper', 0.5);

% show image for test
figure('Name','original image')
imshow(image_x,[])

figure('Name','image before deblurring')
imshow(b,[])


% img 2 -- bigger image
%resizefactor = 0.1;
%image_x = imresize(image_x, resizefactor);

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
i.tprimaldualdr = 0.1;

% relaxation parameter (rho in (0, 2)) and step size t > 0 for Alternating
% Direction Method of Multipliers
i.rhoadmm = 1.5;
i.tadmm = 0.1;

% step size parameters for the Chambolle-Pock Algorithm
i.tcp = 0.1;
i.scp = 0.1;


%% TESTING ALL ALGORITHMS
[m, n] = size(b);
z1_0 = rand(m, n);
z21_0 = applyK(z1_0);
z22_0 = applyD1(z1_0);
z23_0 = applyD2(z1_0);

z2_0 = cat(3, z21_0, z22_0, z23_0);

problem = 'l1';
[norm_prox, gamma] = proxproblem(problem, i);
i.tol = 10;
i.analysis = true;
i.maxiter=10;

[deblurred_x1, summary1] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
[deblurred_x2, summary2] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
[deblurred_x3, summary3] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);
[deblurred_x4, summary4] = optsolver('l1', 'chambollepock', z1_0, image_x, kernel, b, i);

figure();
imshow(deblurred_x1,[])

figure();
imshow(deblurred_x2,[])

figure();
imshow(deblurred_x3,[])

figure();
imshow(deblurred_x4,[])
     