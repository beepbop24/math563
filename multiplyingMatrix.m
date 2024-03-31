function [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, u)
    % INPUTS: blurred image b, blurring kernel, and scaling of matrix computations u
    % OUTPUTS: methods to apply A and A^T to x and apply
    % (I+u*u*A*A^T)^{-1}(x)
    
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
    % matrix and the eigenvalues of I + u*u*K^TK + u*u*D^TD; here t is the
    % stepsizes

    applyMat = @(x) x + applyKTrans(applyK(x)) + applyDTrans(applyD(x));
    eigValsMat = ones(numRows, numCols) + u*u*eigArry_KTrans.*eigArry_K + u*u*eigArry_D1Trans.*eigArry_D1...
        + u*u*eigArry_D2Trans.*eigArry_D2;

    %R^(m x n) Computing (I + u*u*K^T*K + u*u*D^T*D)^(-1)*x
    invertMatrix = @(x) ifft2(fft2(x)./eigValsMat); 

end