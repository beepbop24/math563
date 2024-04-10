%% DIFFERENT IMAGES & KERNELS TO TEST ALGORITHMS
% img 1 -- most tests (small image)
image_x = importimage("testimages/cameraman.jpg");

kernel = fspecial('gaussian', [10 10], 15);

b = imfilter(image_x, kernel);
b = imnoise(b,'salt & pepper', 0.5);

%% DEFAULT PARAMETER VALUES
% maximum number of iterations
i.maxiter = 500;

% denoising for l1 and l2 loss
i.gammal1 = 0.049;
i.gammal2 = 0.049;

i.scp = 0.1;

%%
% l1 problem to three algorithms 
z1_0 = rand(m,n);
i.tol = 0.0001;
i.analysis = false;
i.maxiter=500;

rhoprimaldr = 0:0.1:1.5;
rhoprimaldualdr = 0:0.1:1.5;
rhoadmm = 0:0.1:1.5;
i.tprimaldr = 0.01;
i.tprimaldualdr = 0.01;
i.tadmm = 0.01;
%i.stp = 0.1;
rhol1_loss1 = zeros(1, 16);
rhol1_loss2 = zeros(1, 16);
rhol1_loss3 = zeros(1, 16);


for j=1:16
    i.rhoprimaldr = rhoprimaldr(j);
    i.rhoprimaldualdr = rhoprimaldualdr(j);
    i.rhoadmm = rhoadmm(j);
    [deblurred_x1, summary1] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
    [deblurred_x2, summary2] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
    [deblurred_x3, summary3] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);
    rhol1_loss1(j) = summary1.loss;
    rhol1_loss2(j) = summary2.loss;
    rhol1_loss3(j) = summary3.loss;

    


end

figure();
plot(log(rhoprimaldr),rhol1_loss1)
hold on;

plot(log(rhoprimaldualdr), rhol1_loss2)
hold on;

plot(log(rhoadmm),rhol1_loss3)
hold off;

legend('primaldr', 'primaldualdr', 'admm')

%%
% l2 problem to three algorithms 
z1_0 = rand(m,n);
i.tol = 0.0001;
i.analysis = false;
i.maxiter=500;

rhoprimaldr = 0:0.1:1.5;
rhoprimaldualdr = 0:0.1:1.5;
rhoadmm = 0:0.1:1.5;
i.tprimaldr = 0.01;
i.tprimaldualdr = 0.01;
i.tadmm = 0.01;
rhol2_loss1 = zeros(1, 16);
rhol2_loss2 = zeros(1, 16);
rhol2_loss3 = zeros(1, 16);


for j=1:16
    i.rhoprimaldr = rhoprimaldr(j);
    i.rhoprimaldualdr = rhoprimaldualdr(j);
    i.rhoadmm = rhoadmm(j);
    [deblurred_x1, summary1] = optsolver('l2', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
    [deblurred_x2, summary2] = optsolver('l2', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
    [deblurred_x3, summary3] = optsolver('l2', 'admm', z1_0, image_x, kernel, b, i);
    rhol2_loss1(j) = summary1.loss;
    rhol2_loss2(j) = summary2.loss;
    rhol2_loss3(j) = summary3.loss;

    


end

figure();
plot(log(rhoprimaldr),rhol2_loss1)
hold on;

plot(log(rhoprimaldualdr), rhol2_loss2)
hold on;

plot(log(rhoadmm),rhol2_loss3)
hold off;

%%
% test for t
% l1 problem to three algorithms 
z1_0 = rand(m,n);
i.tol = 0.0001;
i.analysis = false;
i.maxiter=500;

%rhoprimaldr = 0:0.1:1.5;
i.rhoprimaldr = 0.5;
i.rhoprimaldualdr = 0.8;
i.rhoadmm = 1.30;
i.stp = 0.1;
%rhoprimaldualdr = 0:0.1:1.5;
%rhoadmm = 0:0.1:1.5;
tprimaldr = [0.003,0.005,0.007,0.01,0.05,0.1,0.5,1,1.5];
tprimaldualdr = [0.003,0.005,0.007,0.01,0.05,0.1,0.5,1,1.5];
tadmm = [0.003,0.005,0.007,0.01,0.05,0.1,0.5,1,1.5];
tcp = [0.003,0.005,0.007,0.01,0.05,0.1,0.5,1,1.5];
%i.tprimaldr = 0.01;
%i.tprimaldualdr = 0.01;
%i.tadmm = 0.01;
tl1_loss1 = zeros(1, 9);
tl1_loss2 = zeros(1, 9);
tl1_loss3 = zeros(1, 9);
tl1_loss4 = zeros(1, 9);

for j=1:9
    i.tprimaldr = tprimaldr(j);
    i.tprimaldualdr = tprimaldualdr(j);
    i.tadmm = tadmm(j);
    i.tcp = tcp(j);
    [deblurred_x1, summary1] = optsolver('l1', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
    [deblurred_x2, summary2] = optsolver('l1', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
    [deblurred_x3, summary3] = optsolver('l1', 'admm', z1_0, image_x, kernel, b, i);
    [deblurred_x4, summary4] = optsolver('l1', 'chambollepock', z1_0, image_x, kernel, b, i);
    tl1_loss1(j) = summary1.loss;
    tl1_loss2(j) = summary2.loss;
    tl1_loss3(j) = summary3.loss;
    tl1_loss4(j) = summary4.loss;

    


end

figure();
plot(log(tprimaldr),tl1_loss1)
hold on;

plot(log(tprimaldualdr), tl1_loss2)
hold on;

plot(log(tadmm),tl1_loss3)
hold on;

plot(log(tcp),tl1_loss4)
hold off;

%legend('primaldr')
%legend('primaldualdr')
%legend('admm')
%legend('chambollepock')
legend('primaldr', 'primaldualdr', 'admm','chambollepock')

%%
% test for t
% l2 problem to three algorithms 
z1_0 = rand(m,n);
i.tol = 0.0001;
i.analysis = false;
i.maxiter=500;

%rhoprimaldr = 0:0.1:1.5;
i.rhoprimaldr = 1.3;
i.rhoprimaldualdr = 0.8;
i.rhoadmm = 1.10;
i.stp = 0.1;
%rhoprimaldualdr = 0:0.1:1.5;
%rhoadmm = 0:0.1:1.5;
tprimaldr = [0.001,0.03,0.05,0.1,0.3,0.5,1,1.5];
tprimaldualdr = [0.001,0.03,0.05,0.1,0.3,0.5,1,1.5];
tadmm = [0.001,0.03,0.05,0.1,0.3,0.5,1,1.5];
tcp = [0.001,0.03,0.05,0.1,0.3,0.5,1,1.5];
%i.tprimaldr = 0.01;
%i.tprimaldualdr = 0.01;
%i.tadmm = 0.01;
tl2_loss1 = zeros(1, 8);
tl2_loss2 = zeros(1, 8);
tl2_loss3 = zeros(1, 8);
tl2_loss4 = zeros(1, 8);

for j=1:8
    i.tprimaldr = tprimaldr(j);
    i.tprimaldualdr = tprimaldualdr(j);
    i.tadmm = tadmm(j);
    i.tcp = tcp(j);
    [deblurred_x1, summary1] = optsolver('l2', 'douglasrachfordprimal', z1_0, image_x, kernel, b, i);
    [deblurred_x2, summary2] = optsolver('l2', 'douglasrachfordprimaldual', z1_0, image_x, kernel, b, i);
    [deblurred_x3, summary3] = optsolver('l2', 'admm', z1_0, image_x, kernel, b, i);
    [deblurred_x4, summary4] = optsolver('l2', 'chambollepock', z1_0, image_x, kernel, b, i);
    tl2_loss1(j) = summary1.loss;
    tl2_loss2(j) = summary2.loss;
    tl2_loss3(j) = summary3.loss;
    tl2_loss4(j) = summary4.loss;

    


end

figure();
plot(log(tprimaldr),tl2_loss1)
hold on;

plot(log(tprimaldualdr), tl2_loss2)
hold on;

plot(log(tadmm),tl2_loss3)
hold on;

plot(log(tcp),tl2_loss4)
hold off;

%legend('primaldr')
%legend('primaldualdr')
%legend('admm')
%legend('chambollepock')
legend('primaldr', 'primaldualdr', 'admm','chambollepock')