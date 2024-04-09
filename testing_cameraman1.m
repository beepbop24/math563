
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
gamma_values = [0.0001, 0.00025, 0.0005, 0.001, 0.0025, 0.005, 0.1, 0.25, 0.5, 1];

[deblurred_x1, gamma_loss1] = testinggamma('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i, gamma_values);
[deblurred_x2, gamma_loss2] = testinggamma('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i, gamma_values);
[deblurred_x3, gamma_loss3] = testinggamma('l1', 'admm', z1_0, image_x, kernel, b, i, gamma_values);
[deblurred_x4, gamma_loss4] = testinggamma('l1', 'chambollepock', z1_0, image_x, kernel, b, i, gamma_values);

[deblurred_x5, gamma_loss5] = testinggamma('l2', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i, gamma_values);
[deblurred_x6, gamma_loss6] = testinggamma('l2', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i, gamma_values);
[deblurred_x7, gamma_loss7] = testinggamma('l2', 'admm', z1_0, image_x, kernel, b, i, gamma_values);
[deblurred_x8, gamma_loss8] = testinggamma('l2', 'chambollepock', z1_0, image_x, kernel, b, i, gamma_values);


% visualizing the data
h1 = figure(1);
plot(log10(gamma_values), gammal1_loss1)
hold on
plot(log10(gamma_values), gammal1_loss2)
hold on
plot(log10(gamma_values), gammal1_loss3)
hold on
plot(log10(gamma_values), gammal1_loss4)
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('log10(gamma)')
ylabel('loss')
title('Value of Loss for 4 Algorithms Depending on Value of Gamma Hyperparameter -- l1 Problem')
saveas(h1, 'gamma_l1','jpeg');


% visualizing the data
h2 = figure(2);
plot(log10(gamma_values), gammal2_loss1)
hold on
plot(log10(gamma_values), gammal2_loss2)
hold on
plot(log10(gamma_values), gammal2_loss3)
hold on
plot(log10(gamma_values), gammal2_loss4)
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('log10(gamma)')
ylabel('loss')
title('Value of Loss for 4 Algorithms Depending on Value of Gamma Hyperparameter -- l2 Problem')
saveas(h2, 'gamma_l2','jpeg');


%% TESTING FOR s (CHAMBOLLE-POCK) (l1 AND l2 problem) 
% initial testing to provide overview of dynamics
i.gammal1 = 0.049;
i.gammal2 = 0.049;

s_values = [0.0001, 0.00025, 0.0005, 0.001, 0.0025, 0.005, 0.1, 0.25, 0.5, 1];

[deblurred_x1, s_loss1] = testingscp('l1', z1_0, image_x, kernel, b, i, s_values);
[deblurred_x2, s_loss2] = testingscp('l2', z1_0, image_x, kernel, b, i, s_values);


% visualizing the data
h3 = figure(3);
plot(log10(s_values), sl1_loss)
hold on
plot(log10(s_values), sl2_loss)
hold off
legend('l1 problem', 'l2 problem')
xlabel('log10(s)')
ylabel('loss')
title('Value of Loss for Chambolle-Pock Algorithm Depending on Value of Step Size s')
saveas(h3, 's_loss','jpeg');

     