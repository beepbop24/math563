function deblurred_x = primaldr(b, t, rho, gamma, maxiter, z1_0, z2_0, kernel, norm_prox)
    % function that computes Primal Douglas-Rachford Splitting
    % INPUTS: blurred image b, step size t, relaxation parameter rho,
    % denoizing parameter gamma, number of max iterations maxiter, initial 
    % guess (z1_0, z2_0), blurring kernel and type of norm to use for the
    % prox of g
    % OUTPUTS: deblurred image 

    % importing multiplyingMatrix methods to compute matrix multiplication
    % with parameter value u=1;
    [applyK, applyD1, applyD2, applyKTrans, applyD1Trans, applyD2Trans, invertMatrix] = multiplyingMatrix(b, kernel, 1);
    
    % initialization of z1 and z2 values
    z1_k = z1_0;
    z21_k = z2_0(:,:,1);
    z22_k = z2_0(:,:,2);
    z23_k = z2_0(:,:,3);

    % main algorithm
    for k=1:maxiter
        % applies prox_{tf}
        x_k = boxProx(z1_k);

        % applies prox_{tg}
        y1_k = norm_prox(z21_k, t, b); 
        [y2_k, y3_k] = isoProx(z22_k, z23_k, t, gamma);

        % applies A^T to (2y^k - z_2^{k-1})
        temp = applyKTrans(2*y1_k-z21_k) + applyD1Trans(2*y2_k-z22_k) + ...
            applyD2Trans(2*y3_k-z23_k);  
        
        % applies (I+A^TA)^{-1} 
        u_k = invertMatrix(2*x_k-z1_k+temp);

        % applies A(u_k)
        v1_k = applyK(u_k);
        v2_k = applyD1(u_k);  
        v3_k = applyD2(u_k);  
        
        % updating primal and dual variables
        z1_k = z1_k+rho*(u_k-x_k);

        z21_k = z21_k+rho*(v1_k-y1_k);
        z22_k = z22_k+rho*(v2_k-y2_k);
        z23_k = z23_k+rho*(v3_k-y3_k);

        %if loss < tol 
        %end
    end
    
    % output image
    deblurred_x = boxProx(z1_k);
   
end