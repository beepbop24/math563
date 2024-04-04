function [deblurred_x, k, loss] = ADMM(b, x_original, t, rho, gamma, maxiter, tol, u_0, y_0, w_0, z_0, kernel, norm_prox,u)
% function that computes ADMM
% Inputs: blurred image b, step size t, parameter rho,
% denoizing parameter gamma, number of max iterations maxiter, initial 
% guess (z1_0, z2_0), blurring kernel and type of norm to use for the prox of g
% Outputs: deblurred image, number of iterations, loss 


% importing multiplyingMatrix methods to compute matrix multiplication
% with parameter value u=1;
[applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, u);

% Initialization of u_k, y_k, w_k, z_k
%[n, m] = size(b);
u_k = u_0;

y1_k = y_0(:,:,1);
y2_k = y_0(:,:,2);
y3_k = y_0(:,:,3);

w_k = w_0;

z1_k = z_0(:,:,1);
z2_k = z_0(:,:,2);
z3_k = z_0(:,:,3);

for k=1:maxiter
    % 
    %if k == 1
        %x_k = x_initial;
    %elseif k ~= 1
        %x_k = deblurred_x_temp;
    %else
        %error("Something is wrong")
    %end
    %x_k = deblurred_x_temp;


    % apply A^T to y_k
    temp_1 = applyKTrans(y1_k) + applyD1Trans(y2_k) + applyD2Trans(y3_k);
    % apply A^T to z_k
    temp_2 = applyKTrans(z1_k) + applyD1Trans(z2_k) + applyD2Trans(z3_k);
    
    
    % update x_k apply (A^TA)^(-1) to u_k+temp_1-1/t(w_k+temp_2)
    %x_k = invertMatrix(u_k+temp_1-(1/t)*(w_k+temp_2));
    x_k = image_x;
    %update u_k
    %apply prox(t^-1f) to rho*x_k + (1-rho)*u_k+w_k/t
    u_k = boxProx(rho*x_k + (1-rho)*u_k+w_k/t);

    %apply A to x_k
    temp_3_1 = applyK(x_k) + applyD1(x_k) + applyD2(x_k);
    temp_3_2 = applyD1(x_k);
    temp_3_3 = applyD2(x_k);

    %update y_k 
    y1_k = l1Prox(rho*temp_3_1+(1-rho)*y1_k+z1_k/t,1/t,b);

    [y2_k, y3_k] = isoProx(rho*temp_3_2+(1-rho)*y2_k+z2_k/t, rho*temp_3_3+(1-rho)*y3_k+z3_k/t, 1/t, gamma);

    % update w_k
    w_k = w_k +t*(x_k - u_k);

    % update z_k
    z1_k = z1_k + t*(applyK(x_k)-y1_k);
    z2_k = z2_k + t*(applyD1(x_k)-y2_k);
    z3_k = z3_k + t*(applyD2(x_k)-y3_k);
   

    % temp output
    % apply A^T to y_k at first; apply A^T to z_k then;
    temp_4 = applyKTrans(y1_k) + applyD1Trans(y2_k) + ...
            applyD2Trans(y3_k);
    temp_5 = applyKTrans(z1_k) + applyD1Trans(z2_k) + ...
            applyD2Trans(z3_k);
    deblurred_x = invertMatrix(u_k + temp_4 - (1/t)*(w_k + temp_5));
    



    loss = norm(deblurred_x-x_original, 2);

    if loss < tol
        break
    end
    %fprintf('Just finished iteration #%d\n', k);

end

end