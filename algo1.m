function image_x = algo1(b, t, rho, gamma, z1_0, z21_0, z22_0, z23_0, maxiter)
    % function that computes the Primal Douglas-Rachford Splitting
    % initial guess
    z1_k = z1_0;
    z21_k = z21_0;
    z22_k = z22_0;
    z23_k = z23_0;

    for k=1:maxiter
        x_k = boxProx(z1_k);
        y1_k = l1Prox(z21_k, t, b); 
        [y2_k, y3_k] = isoProx(z22_k, z23_k, t, gamma);

        % applies A^T to (2y^k - z_2^{k-1})
        temp = applyKTrans(2*y1_k-z21_k) + applyD1Trans(2*y2_k-z22_k) + ...
            applyD2Trans(2*y3_k-z23_k);  

        u_k = invertMatrix(2*x_k-z1_k+temp);

        % applies A(u_k)
        v1_k = applyK(u_k);
        v2_k = applyD1(u_k);  
        v3_k = applyD2(u_k);  

        z1_k = z1_k+rho*(u_k-x_k);

        z21_k = z21_k+rho*(v1_k-y1_k);
        z22_k = z22_k+rho*(v2_k-y2_k);
        z23_k = z23_k+rho*(v3_k-y3_k);

        %if loss < tol 
            %break;
        %end
    end

    image_x = boxProx(z1_k);
   
end