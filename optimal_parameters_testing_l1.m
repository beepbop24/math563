%% TESTING OPTIMAL PARAMETERS WITH CAMERAMAN IMAGE FOR GAUSSIAN BLUR AND SALT & PEPPER NOISE
% img 1 -- most tests (small image)
image_x = importimage("testimages/cameraman.jpg");

kernel = fspecial('gaussian', [10 10], 15);

b = imfilter(image_x, kernel);
b = imnoise(b,'salt & pepper', 0.5);

% show image for test
figure('Name','original image')
imshow(image_x,[])

h_b = figure(1);
figure('Name','image before deblurring')
imshow(b,[])
imshow(b,[])
saveas(h_b, 'b','jpeg');

%% TESTING ALL ALGORITHMS
[m, n] = size(b);
z1_0 = rand(m, n);
i = struct();

[deblurred_x1_opt, summary1, loss1] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
[deblurred_x2_opt, summary2, loss2] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
[deblurred_x3_opt, summary3, loss3] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);

i.gammal1 = 0.005;
[deblurred_x4_opt, summary4, loss4] = optsolver('l1', 'chambollepock', z1_0, image_x, kernel, b, i);

h_opt1 = figure(1);
imshow(deblurred_x1_opt,[])
saveas(h_opt1, 'x1_opt','jpeg');

h_opt2 = figure(2);
imshow(deblurred_x2_opt,[])
saveas(h_opt2, 'x2_opt','jpeg');

h_opt3 = figure(3);
imshow(deblurred_x3_opt,[])
saveas(h_opt3, 'x3_opt','jpeg');

h_opt4 = figure(4);
imshow(deblurred_x4_opt,[])
saveas(h_opt4, 'x4_opt','jpeg');

% plot of loss vs k
h_loss = figure(5);
plot(1:500, loss1)
hold on
plot(1:500, loss2)
hold on
plot(1:500, loss3)
hold on
plot(1:500, loss4)
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('# of iterations')
ylabel('loss')
title('Value of Loss for 4 Algorithms vs Iteration Count for Tuned Hyperparameters -- l1 Problem')
saveas(h_loss, 'l1_loss_all','jpeg');

%% TESTING OPTIMAL PARAMETERS WITH MAN WITH HAT IMAGE FOR GAUSSIAN BLUR AND SALT & PEPPER NOISE
% img 2 
image_x = importimage("testimages/manWithHat.jpg");
resizefactor = 0.25;
image_x = imresize(image_x, resizefactor);

kernel = fspecial('gaussian', [10 10], 15);

b = imfilter(image_x, kernel);
b = imnoise(b,'salt & pepper', 0.5);

% show image for test
figure('Name','original image')
imshow(image_x,[])

figure('Name','image before deblurring')
imshow(b,[])

%% TESTING ALL ALGORITHMS
[m, n] = size(b);
z1_0 = rand(m, n);
i = struct();

[deblurred_x1_opt_hat, summary1_hat, loss1_hat] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
[deblurred_x2_opt_hat, summary2_hat, loss2_hat] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
[deblurred_x3_opt_hat, summary3_hat, loss3_hat] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);

i.gammal1=0.005;
[deblurred_x4_opt_hat, summary4_hat, loss4_hat] = optsolver('l1', 'chambollepock', z1_0, image_x, kernel, b, i);

h_opt_hat1 = figure(1);
imshow(deblurred_x1_opt_hat,[])
saveas(h_opt_hat1, 'x1_opt_hat','jpeg');

h_opt_hat2 = figure(2);
imshow(deblurred_x2_opt_hat,[])
saveas(h_opt_hat2, 'x2_opt_hat','jpeg');

h_opt_hat3 = figure(3);
imshow(deblurred_x3_opt_hat,[])
saveas(h_opt_hat3, 'x3_opt_hat','jpeg');

h_opt_hat4 = figure(4);
imshow(deblurred_x4_opt_hat,[])
saveas(h_opt_hat4, 'x4_opt_hat','jpeg');

% plot of loss vs k
h_loss = figure(5);
plot(1:500, loss1_hat)
hold on
plot(1:500, loss2_hat)
hold on
plot(1:500, loss3_hat)
hold on
plot(1:500, loss4_hat)
hold off
legend('primaldr', 'primaldualdr', 'admm', 'chambollepock')
xlabel('# of iterations')
ylabel('loss')
title('Value of Loss for 4 Algorithms vs Iteration Count for Tuned Hyperparameters -- l1 Problem')
saveas(h_loss, 'l1_loss_hat','jpeg');


