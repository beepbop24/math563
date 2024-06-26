function [deblurred_x, k, loss] = primaldualdr(b, x_original, t, rho, gamma, maxiter, tol, analysis, x_initial, kernel, norm_prox, problem)

    % function that computes Primal Douglas-Rachford Splitting
    % INPUTS: blurred image b, step size t, relaxation parameter rho,
    % denoizing parameter gamma, number of max iterations maxiter, initial 
    % guess x_initial, blurring kernel and type of norm to use for the
    % prox of g
    % OUTPUTS: deblurred image 

    % importing multiplyingMatrix methods to compute matrix multiplication
    % with parameter value u=t;
    [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, t);

    % initialization of p and q values
    p_k = x_initial;
    q1_k = applyK(p_k);
    q2_k = applyD1(p_k);
    q3_k = applyD2(p_k);
    
    % initialization of loss array
    loss = zeros(1, maxiter);
    
    % main algorithm
    for k=1:maxiter

        % applies prox_{tf}
        x_k = boxProx(p_k);

        % using Moreau decomposition to compute
        % prox_{sg^*} (y) = y - s*prox_{1/s * g} (y/s)
        z1_k = q1_k - t*norm_prox(q1_k/t, 1/t, b); 
        [temp_z2, temp_z3] = isoProx(q2_k/t, q3_k/t, 1/t, gamma);
        z2_k = q2_k - t*temp_z2;
        z3_k = q3_k - t*temp_z3;
        

        % applies [I -t*A]^T to ([2x^k - p^{k-1} 2z^k - q^{k-1}]^T)
        % from equation (9)
        temp = 2*x_k - p_k - t*applyKTrans(2*z1_k-q1_k) - t*applyD1Trans(2*z2_k-q2_k) - ...
            t*applyD2Trans(2*z3_k-q3_k);  
        
        % applies (I+t^2*A^TA)^{-1} 
        w_k = invertMatrix(temp);

        % applies 2z_k - q_k + t*A(w_k)
        v1_k = 2*z1_k-q1_k + t*applyK(w_k);
        v2_k = 2*z2_k-q2_k + t*applyD1(w_k);  
        v3_k = 2*z3_k-q3_k + t*applyD2(w_k);  
        
        % updating primal and dual variables
        p_k = p_k+rho*(w_k-x_k);

        q1_k = q1_k+rho*(v1_k-z1_k);
        q2_k = q2_k+rho*(v2_k-z2_k);
        q3_k = q3_k+rho*(v3_k-z3_k);

        deblurred_x = boxProx(p_k);

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