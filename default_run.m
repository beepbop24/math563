%%
%%%%% FILE TO RUN DEFAULT OPTSOLVER %%%%%
% NEED TO SPECIFY IMAGE
image_x = importimage("testimages/cameraman.jpg");

% SPECIFY ANY KERNEL
kernel = fspecial('gaussian', [10 10], 15);
b = imfilter(image_x, kernel);

% SPECIFY ANY NOISE
b = imnoise(b,'salt & pepper', 0.5);

% show image
figure('Name','Original Image')
imshow(image_x,[])

figure('Name','Blurred Image')
imshow(b,[])


%% SPECIFY ANY PARAMETER VALUES
% specify starting point
[m, n] = size(b);
z1_0 = rand(m, n);

% specify problem
problem = 'l1';

% specify any parameters if i=struct(); algorithm will run with defaults.
% otherwise following structure is needed:

% maximum number of iterations
i.maxiter = 500;

% denoising for l1 and l2 loss
i.gammal1 = 0.049;
i.gammal2 = 0.049;

% relaxation parameter (rho in (0, 2)) and step size t > 0 for Primal
% Douglas-Rachford Splitting
i.rhoprimaldr = 2;
i.tprimaldr = 0.1;

% relaxation parameter (rho in (0, 2)) and step size t > 0 for Primal Dual
% Douglas-Rachford Splitting
i.rhoprimaldualdr = 1.5;
i.tprimaldualdr = 0.1;

% relaxation parameter (rho in (0, 2)) and step size t > 0 for Alternating
% Direction Method of Multipliers (ADMM)
i.rhoadmm = 1.5;
i.tadmm = 0.1;

% step size parameters s > 0 , t > 0 for the Chambolle-Pock Algorithm
i.tcp = 0.1;
i.scp = 0.1;

% other parameters (basically no tolerance as default, the algorithm will
% run for the number of specified iterations), no output at each iteration
i.tol = 0;
i.analysis = false;


%% RUNNING THE ALGORITHMS

[deblurred_x1, summary1] = optsolver(problem, 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
[deblurred_x2, summary2] = optsolver(problem, 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
[deblurred_x3, summary3] = optsolver(problem, 'admm', z1_0, image_x, kernel, b, i);
[deblurred_x4, summary4] = optsolver(problem, 'chambollepock', z1_0, image_x, kernel, b, i);

% show images
figure('Name','Deblurred Image with PrimalDR')
imshow(deblurred_x1,[])

figure('Name','Deblurred Image with PrimalDualDR')
imshow(deblurred_x2,[])

figure('Name','Deblurred Image with ADMM')
imshow(deblurred_x3,[])

figure('Name','Deblurred Image with CP')
imshow(deblurred_x4,[])




     