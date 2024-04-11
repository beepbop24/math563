%% TESTING WITH CAMERAMAN IMAGE FOR GAUSSIAN BLUR AND GAUSSIAN NOISE
% img 1 -- most tests (small image)
image_x = importimage("testimages/cameraman.jpg");

kernel = fspecial('gaussian', [10 10], 15);

b = imfilter(image_x, kernel);
b = imnoise(b,'gaussian', 0, 0.05);

% show image for test
figure('Name','original image')
imshow(image_x,[])

figure('Name','image before deblurring')
imshow(b,[])


%% TESTING ALL ALGORITHMS
[m, n] = size(b);
z1_0 = rand(m, n);

[deblurred_x1_base, summary1] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
[deblurred_x2_base, summary2] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
[deblurred_x3_base, summary3] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);
[deblurred_x4_base, summary4] = optsolver('l1', 'chambollepock', z1_0, image_x, kernel, b, i);

figure();
imshow(deblurred_x1_base,[])

figure();
imshow(deblurred_x2_base,[])

figure();
imshow(deblurred_x3_base,[])

figure();
imshow(deblurred_x4_base,[])


%% TESTING FOR GAMMA (l1 AND l2 problem) 
% initial testing to provide overview of dynamics
gamma_values = [0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5];

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
plot(log10(gamma_values(1:6)), gamma_loss1(1:6))
hold on
plot(log10(gamma_values(1:6)), gamma_loss2(1:6))
hold on
plot(log10(gamma_values(1:6)), gamma_loss3(1:6))
hold on
plot(log10(gamma_values(1:6)), gamma_loss4(1:6))
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('log10(gamma)')
ylabel('loss')
title('Value of Loss for 4 Algorithms Depending on Value of Gamma Hyperparameter -- l1 Problem')
saveas(h1, 'gamma_l1_gaussianNoise','jpeg');


% visualizing the data
h2 = figure(2);
plot(log10(gamma_values(1:6)), gamma_loss5(1:6))
hold on
plot(log10(gamma_values(1:6)), gamma_loss6(1:6))
hold on
plot(log10(gamma_values(1:6)), gamma_loss7(1:6))
hold on
plot(log10(gamma_values(1:6)), gamma_loss8(1:6))
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('log10(gamma)')
ylabel('loss')
title('Value of Loss for 4 Algorithms Depending on Value of Gamma Hyperparameter -- l2 Problem')
saveas(h2, 'gamma_l2_gaussianNoise','jpeg');


%% TESTING FOR s (CHAMBOLLE-POCK) (l1 AND l2 problem) 
% initial testing to provide overview of dynamics
i.gammal1 = 0.049;
i.gammal2 = 0.049;

s_values = [0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5];

[deblurred_x1, s_loss1] = testingscp('l1', z1_0, image_x, kernel, b, i, s_values);
[deblurred_x2, s_loss2] = testingscp('l2', z1_0, image_x, kernel, b, i, s_values);


% visualizing the data
h3 = figure(3);
plot(log10(s_values), s_loss1)
hold on
plot(log10(s_values), s_loss2)
hold off
legend('l1 problem', 'l2 problem')
xlabel('log10(s)')
ylabel('loss')
title('Value of Loss for Chambolle-Pock Algorithm Depending on Value of Step Size s')
saveas(h3, 's_loss_gaussianNoise','jpeg');

     