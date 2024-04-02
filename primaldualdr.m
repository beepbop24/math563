function [deblurred_x, k] = primaldualdr(b, x_original, t, rho, gamma, maxiter, tol, p_0, q_0, kernel, norm_prox)

    % function that computes Primal Douglas-Rachford Splitting
    % INPUTS: blurred image b, step size t, relaxation parameter rho,
    % denoizing parameter gamma, number of max iterations maxiter, initial 
    % guess (z1_0, z2_0), blurring kernel and type of norm to use for the
    % prox of g
    % OUTPUTS: deblurred image 

    % importing multiplyingMatrix methods to compute matrix multiplication
    % with parameter value u=t;
    [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, t);

    % initialization of p and q values
    p_k = p_0;
    q1_k = q_0(:,:,1);
    q2_k = q_0(:,:,2);
    q3_k = q_0(:,:,3);
    
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

        if  norm(deblurred_x-x_original, 2) < tol
            break
        end
    end
end