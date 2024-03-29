
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
i.rhoprimaldualdr = 2.0;
i.tprimaldualdr = 0.1;

% step size parameters for the Chambolle-Pock Algorithm
i.tcp = 0.1;
i.scp = 0.1;


%% MULTIPLYING MATRIX
%Constructing the K and D matrices
[numRows, numCols] = size(b); %numRows = m, numCols = n

%computes the numRow x numCol matrix of the eigenvalues for K and D1 and
%D2; Here D1 = I oplus D1 in the paper and D2 = D1 oplus I.
eigArry_K = eigValsForPeriodicConvOp(kernel, numRows, numCols);
eigArry_D1 = eigValsForPeriodicConvOp([-1,1]', numRows, numCols);
eigArry_D2 = eigValsForPeriodicConvOp([-1,1], numRows, numCols);

%computes numRow x numCol matrix of the eigenvalues for K^T and D1^T and
%D2^T;
eigArry_KTrans = conj(eigArry_K);
eigArry_D1Trans = conj(eigArry_D1);
eigArry_D2Trans = conj(eigArry_D2);

%Functions which compute Kx, D1x, D2x, Dxt, K^Tx, D1^Tx, D2^Tx, and D^Ty.
%Note for all the x functions, the input x is in R^(m x n) and outputs into
%R^(m x n) except for D which outputs into 2 concat. R^(m x n) matrices;
%For D^Ty, y is two m x n matrices concatanated and outputs into R^(m x n)
applyK = @(x) applyPeriodicConv2D(x, eigArry_K);
applyD1 = @(x) applyPeriodicConv2D(x, eigArry_D1);
applyD2 = @(x) applyPeriodicConv2D(x, eigArry_D2);

applyKTrans = @(x) applyPeriodicConv2D(x, eigArry_KTrans);
applyD1Trans = @(x) applyPeriodicConv2D(x, eigArry_D1Trans);
applyD2Trans = @(x) applyPeriodicConv2D(x, eigArry_D2Trans);

applyD = @(x) cat(3, applyD1(x), applyD2(x));

applyDTrans = @(y) applyD1Trans(y(:,:,1)) + applyD2Trans(y(:, :, 2));

% Function which computes the (I + K^TK + D^TD)x where x in R^(m x n)
% matrix and the eigenvalues of I + t*t*K^TK + t*t*D^TD; here t is the
% stepsizes
s = 1; % Need to change this for the various algorithms you are applying
applyMat = @(x) x + applyKTrans(applyK(x)) + applyDTrans(applyD(x));
eigValsMat = ones(numRows, numCols) + s*s*eigArry_KTrans.*eigArry_K + s*s*eigArry_D1Trans.*eigArry_D1...
    + s*s*eigArry_D2Trans.*eigArry_D2;

%R^(m x n) Computing (I + K^T*K + D^T*D)^(-1)*x
invertMatrix = @(x) ifft2(fft2(x)./eigValsMat); 

%% TEST ALGO 1
% initializing empty arrays for xk, yk, uk, vk
rho = i.rhoprimaldualdr;
gamma = i.gammal1;

[n, m] = size(b);
x_k = zeros(n, m);
y1_k = zeros(n, m);
y2_k = zeros(n, m);
y3_k = zeros(n, m);
u_k = zeros(n, m);
v1_k = zeros(n, m);
v2_k = zeros(n, m);
v3_k = zeros(n, m);

% initializing zk
z1_k = image_x;
z21_k = applyK(z1_k);
z22_k = applyD1(z1_k);
z23_k = applyD2(z1_k);

for k=1:100
        x_k = boxProx(z1_k);
        y1_k = l1Prox(z21_k, t, b); 
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
     