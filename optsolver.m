function [x_sol, summary] = optsolver(problem, algorithm, x_initial, x_original, kernel, b, i, tol)

    % selects correct norm & gamma to use for the function g (l1 or l2)
    [norm_prox, gamma] = proxproblem(problem);

    if strcmp(algorithm, 'douglasrachfordprimal') == 1
        % need to decompose x_initial to right format for this algorithm
        x_sol = primaldr(b, x_original, i.tprimaldr, i.rhoprimaldr, gamma, i.maxiter, tol, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'douglasrachfordprimaldual') == 1
        % need to decompose x_initial to right format for this algorithm
        x_sol = primaldualdr(b, x_original, i.tprimaldualdr, i.rhoprimaldualdr, gamma, i.maxiter, tol, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'admm') == 1

    elseif strcmp(algorithm, 'chambollepock') == 1
        % need to decompose x_initial to right format for this algorithm
        x_sol = chambollepock(b, x_original, i.tcp, i.scp, gamma, i.maxiter, tol, x_initial, kernel, norm_prox);

    else
        error('Not a Valid Algorithm')
    end
end