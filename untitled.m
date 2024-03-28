
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

kernel = fspecial('gaussian', [15 15], 10);

b = imfilter(image_x, kernel);
b = imnoise(b,'salt & pepper', 0.5);

% show image for test
figure('Name','image post deblurring')
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
i.rhoprimaldualdr = 2.0;
i.tprimaldualdr = 0.1;

% step size parameters for the Chambolle-Pock Algorithm
i.tcp = 0.1;
i.scp = 0.1;

%% TEST ALGO 1
% initializing empty arrays for xk, yk, uk, vk
t = 0.1;
rho = 2;
maxiter=500;
gamma = 0.049;

n = size(b, 1);
x_k = zeros(n);
y1_k = zeros(n);
y2_k = zeros(n);
y3_k = zeros(n);
u_k = zeros(n);
v1_k = zeros(n);
v2_k = zeros(n);
v3_k = zeros(n);

% initializing zk
z1_k = rand(n);
z21_k = applyK(z1_k);
z22_k = applyD1(z1_k);
z23_k = applyD2(z1_k);

for k=1:100
        x_k = boxProx(z1_k);
        y1_k = l1Prox(z1_k, t, b); 
        [y2_k, y3_k] = isoProx(z22_k, z23_k, t, gamma);

        % applies A^T to (2y^k - z_2^{k-1})
        temp = applyKTrans(2*y1_k-z21_k) + applyD1Trans(2*y2_k-z22_k) + ...
            applyD2Trans(2*y3_k-z23_k);  

        u_k = invertMatrix(2*x_k-z1_k+temp);

        v1_k = applyK(u_k);
        v2_k = applyD1(u_k);  
        v3_k = applyD2(u_k);  

        z1_k = z1_k+rho*(u_k-x_k);

        z21_k = z21_k+rho*(v1_k-y1_k);
        z22_k = z22_k+rho*(v2_k-y2_k);
        z23_k = z23_k+rho*(v3_k-y3_k);

        %if res < tol 
            %break;
        %end
end
     