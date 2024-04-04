function [deblurred_x, k, loss] = admm(b, x_original, t, rho, gamma, maxiter, tol, analysis, x_initial, kernel, norm_prox)
    % function that computes ADMM
    % INPUTS: blurred image b, step size t, parameter rho,
    % denoizing parameter gamma, number of max iterations maxiter, initial 
    % guess x_initial, blurring kernel and type of norm to use for the prox of g
    % OUTPUTS: deblurred image deblurred_x, number of iterations k, loss 


    % importing multiplyingMatrix methods to compute matrix multiplication
    % with parameter value u=1;
    [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, 1);

    % Initialization of u_k, y_k, w_k, z_k
    u_k = x_initial;

    y1_k = applyK(u_k);
    y2_k = applyD1(u_k);
    y3_k = applyD2(u_k);

    w_k = u_k;

    z1_k = y1_k;
    z2_k = y2_k;
    z3_k = y3_k;

    % initialization of loss array
    loss = zeros(1, maxiter);

    % main algorithm
    for k=1:maxiter
   
        % apply A^T to y_k
        temp_1 = applyKTrans(y1_k) + applyD1Trans(y2_k) + applyD2Trans(y3_k);
        % apply A^T to z_k
        temp_2 = applyKTrans(z1_k) + applyD1Trans(z2_k) + applyD2Trans(z3_k);
    
        % update x_k
        % apply (A^TA)^(-1) to u_k+temp_1-1/t(w_k+temp_2)
        x_k = invertMatrix(u_k+temp_1-(1/t)*(w_k+temp_2));

        %update u_k
        %apply prox(t^-1f) to rho*x_k + (1-rho)*u_k+w_k/t
        u_k = boxProx(rho*x_k + (1-rho)*u_k+w_k/t);

        %apply A to x_k
        temp_3_1 = applyK(x_k) + applyD1(x_k) + applyD2(x_k);
        temp_3_2 = applyD1(x_k);
        temp_3_3 = applyD2(x_k);

        %update y_k 
        y1_k = norm_prox(rho*temp_3_1+(1-rho)*y1_k+z1_k/t,1/t,b);

        [y2_k, y3_k] = isoProx(rho*temp_3_2+(1-rho)*y2_k+z2_k/t, ...
            rho*temp_3_3+(1-rho)*y3_k+z3_k/t, 1/t, gamma);

        % update w_k
        w_k = w_k +t*(x_k - u_k);

        % update z_k
        z1_k = z1_k + t*(applyK(x_k)-y1_k);
        z2_k = z2_k + t*(applyD1(x_k)-y2_k);
        z3_k = z3_k + t*(applyD2(x_k)-y3_k);
   
        % temp output
        % apply A^T to y_k at first; apply A^T to z_k then;
        temp_4 = applyKTrans(y1_k) + applyD1Trans(y2_k) + applyD2Trans(y3_k);
        temp_5 = applyKTrans(z1_k) + applyD1Trans(z2_k) + applyD2Trans(z3_k);
    
        deblurred_x = invertMatrix(u_k + temp_4 - (1/t)*(w_k + temp_5));
 
        loss(k) = norm(deblurred_x-x_original, 2);
        timerend = "algorithm ongoing -- CPU time TBD";
        
        % print summary if wanted during each iteration
        if analysis
            temp_summary = summary(deblurred_x, b, gamma, kernel, k, maxiter, loss, timerend, tol);
        end

        % break condition if l2 norm of x-x* < tol
        if loss(k) < tol
            break
        end
    end
end
