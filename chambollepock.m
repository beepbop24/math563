function [deblurred_x, k, loss] = chambollepock(b, x_original, t, s, gamma, maxiter, tol, analysis, x_initial, kernel, norm_prox, problem)
    % function that computes Primal Douglas-Rachford Splitting
    % INPUTS: blurred image b, step size t, relaxation parameter rho,
    % denoizing parameter gamma, number of max iterations maxiter, initial 
    % guess x_initial, blurring kernel and type of norm to use for the
    % prox of g
    % OUTPUTS: deblurred image 

    % importing multiplyingMatrix methods to compute matrix multiplication
    % with parameter value u=1 (u is irrelevant here -- there is no
    % invertMatrix)
    [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans] = multiplyingMatrix(b, kernel, 1);

    conv_test_x = eye(size(x_initial));
    conv_test_y1 = applyK(conv_test_x);
    conv_test_y2 = applyD1(conv_test_x);
    conv_test_y3 = applyD2(conv_test_x);

    if (t*s*norm([conv_test_y1; conv_test_y2; conv_test_y3], 2)^2) > 1
        disp("Warning: Chambolle-Pock Convergence Conditions Not Met");
    end 
    
    % initialization of x, y and z values
    x_k = x_initial;
    y1_k = applyK(x_k);
    y2_k = applyD1(x_k);
    y3_k = applyD2(x_k);
    z_k = x_k;

    % initialization of loss array
    loss = zeros(1, maxiter);
    
    % main algorithm
    for k=1:maxiter

        % applies y^{k-1} + s*A*z^{k-1}
        temp_y1 = y1_k + s*applyK(z_k);
        temp_y2 = y2_k + s*applyD1(z_k);
        temp_y3 = y3_k + s*applyD2(z_k);
        
        % using Moreau decomposition to compute
        % prox_{(s*gamma) g^*} (y) = y - (s*gamma) prox_{1/(s*gamma) * g}(y/(s*gamma))
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

        loss(k) = abs(objectivefunction(deblurred_x, b, gamma, kernel, problem)...
            - objectivefunction(x_original, b, gamma, kernel, problem));
        timerend = "algorithm ongoing -- CPU time TBD";
    
        % print summary if wanted during each iteration
        if analysis
            temp_summary = summary(deblurred_x, b, gamma, kernel, k, maxiter, loss, timerend, tol, problem);
        end

        % break condition if l2 norm of x-x* < tol
        if loss(k) < tol
            break
        end
    end
end