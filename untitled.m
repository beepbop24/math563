
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

% other parameters
i.tol = 0.1;
i.analysis = false;

%% TESTING ALL ALGORITHMS
[m, n] = size(b);
z1_0 = rand(m, n);

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


%% TESTING FOR GAMMA (l1 AND l2 problem) 
% initial testing to provide overview of dynamics
i.tol = 0.1;
i.analysis = false;
i.maxiter=500;

gammal1_values = [0.00005, 0.0001, 0.0005, 0.001, 0.005, 0.1, 0.5, 1, 5, 10];
gammal2_values = [0.00005, 0.0001, 0.0005, 0.001, 0.005, 0.1, 0.5, 1, 5, 10];

gammal1_loss1 = zeros(1, 10);
gammal1_loss2 = zeros(1, 10);
gammal1_loss3 = zeros(1, 10);
gammal1_loss4 = zeros(1, 10);

gammal2_loss1 = zeros(1, 10);
gammal2_loss2 = zeros(1, 10);
gammal2_loss3 = zeros(1, 10);
gammal2_loss4 = zeros(1, 10);


for k=1:10
    i.gammal1 = gammal1_values(k);
    i.gammal2 = gammal2_values(k);

    % tests for l1 problem
    [deblurred_x1, summary1] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
    [deblurred_x2, summary2] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
    [deblurred_x3, summary3] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);
    [deblurred_x4, summary4] = optsolver('l1', 'chambollepock', z1_0, image_x, kernel, b, i);

    gammal1_loss1(k) = summary1.loss;
    gammal1_loss2(k) = summary2.loss;
    gammal1_loss3(k) = summary3.loss;
    gammal1_loss4(k) = summary4.loss;


    % tests for l2 problem
    [deblurred_x5, summary5] = optsolver('l2', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
    [deblurred_x6, summary6] = optsolver('l2', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
    [deblurred_x7, summary7] = optsolver('l2', 'admm', z1_0, image_x, kernel, b, i);
    [deblurred_x8, summary8] = optsolver('l2', 'chambollepock', z1_0, image_x, kernel, b, i);

    gammal2_loss1(k) = summary5.loss;
    gammal2_loss2(k) = summary6.loss;
    gammal2_loss3(k) = summary7.loss;
    gammal2_loss4(k) = summary8.loss;

end


% visualizing the data
h1 = figure(1);
plot(log10(gammal1_values), gammal1_loss1)
hold on
plot(log10(gammal1_values), gammal1_loss2)
hold on
plot(log10(gammal1_values), gammal1_loss3)
hold on
plot(log10(gammal1_values), gammal1_loss4)
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('log10(gamma)')
ylabel('loss')
title('Value of Loss for 4 Algorithms Depending on Value of Gamma Hyperparameter -- l1 problem')
saveas(h1, 'gamma_l1','jpeg');


% visualizing the data
h2 = figure(2);
plot(log10(gammal2_values), gammal2_loss1)
hold on
plot(log10(gammal2_values), gammal2_loss2)
hold on
plot(log10(gammal2_values), gammal2_loss3)
hold on
plot(log10(gammal2_values), gammal2_loss4)
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('log10(gamma)')
ylabel('loss')
title('Value of Loss for 4 Algorithms Depending on Value of Gamma Hyperparameter -- l2 Problem')
saveas(h2, 'gamma_l2','jpeg');




     