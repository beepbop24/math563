function [deblurred_x, k] = chambollepock(b, x_original, t, s, gamma, maxiter, tol, x_0, y_0, z_0, kernel, norm_prox)
    % function that computes Primal Douglas-Rachford Splitting
    % INPUTS: blurred image b, step size t, relaxation parameter rho,
    % denoizing parameter gamma, number of max iterations maxiter, initial 
    % guess (z1_0, z2_0), blurring kernel and type of norm to use for the
    % prox of g
    % OUTPUTS: deblurred image 

    % importing multiplyingMatrix methods to compute matrix multiplication
    % with parameter value u=1 (u is irrelevant here -- there is no
    % invertMatrix)
    [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans] = multiplyingMatrix(b, kernel, 1);
    
    % initialization of x, y and z values
    x_k = x_0;
    y1_k = y_0(:,:,1);
    y2_k = y_0(:,:,2);
    y3_k = y_0(:,:,3);
    z_k = z_0;

    % main algorithm
    for k=1:maxiter

        % applies y^{k-1} + s*A*z^{k-1}
        temp_y1 = y1_k + s*applyK(z_k);
        temp_y2 = y2_k + s*applyD1(z_k);
        temp_y3 = y3_k + s*applyD2(z_k);
        
        % using Moreau decomposition to compute
        % prox_{sg^*} (y) = y - s*prox_{1/s * g} (y/s)
        y1_k = temp_y1 - s*norm_prox(temp_y1/s, 1/s, b); 
        [prox_temp_y2, prox_temp_y3] = isoProx(temp_y2/s, temp_y3/s, 1/s, gamma);
        y2_k = temp_y2 - s*prox_temp_y2;
        y3_k = temp_y3 - s*prox_temp_y3;

        % applies x^{k-1} - t*A*y^k
        temp_x = x_k - t*applyKTrans(y1_k) - t*applyD1Trans(y1_k) - t*applyD2Trans(y1_k);  

        % computes new values of x_k and z_k
        xk_prev = x_k;
        x_k = boxProx(temp_x);
        z_k = 2*x_k - xk_prev;

        % output image
        deblurred_x = x_k;

        % break condition if l2 norm of x-x* < tol (can be specified by
        % user)
        if norm(deblurred_x - x_original, 2) < tol
            break
        end
    end
end