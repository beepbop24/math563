function x_sol = optsolver(problem, algorithm, x_initial, kernel, b, i)

    % selects correct norm & gamma to use for the function g (l1 or l2)
    [norm_prox, gamma] = proxproblem(problem);

    if strcmp(algorithm, 'douglasrachfordprimal') == 1
        % need to decompose x_initial to right format for this algorithm
        deblurred_x = primaldr(b, i.tprimaldr, i.rhoprimaldr, gamma, i.maxiter, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'douglasrachfordprimaldual') == 1
        % need to decompose x_initial to right format for this algorithm
        deblurred_x = primaldualdr(b, i.tprimaldualdr, i.rhoprimaldualdr, gamma, i.maxiter, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'admm') == 1

    elseif strcmp(algorithm, 'chambollepock') == 1
        % need to decompose x_initial to right format for this algorithm
        deblurred_x = chambollepock(b, i.tcp, i.scp, gamma, i.maxiter, x_initial, kernel, norm_prox);

    else
        error('Not a Valid Algorithm')
    end
end