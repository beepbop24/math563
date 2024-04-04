function [x_sol, summary_x] = optsolver(problem, algorithm, x_initial, x_original, kernel, b, i)
    % function that computes given algorithm to deblur image
    % INPUTS: problem ('l1' or 'l2' indicating the norm to use), 
    % algorithm (algorithm of choice from "douglasrachfordprimal",
    % "douglasrachfordprimaldual", "admm", and "chambollepock")
    % x_initial: initial guess of the correct image
    % x_original: true image
    % b: blurred & noisy image
    % i (structure containing the following hyperparameters:
    %  i.maxiter: maximum number of iterations
    %  i.gammal1, i.gammal2: denoising parameter for the l1 and l2 problems
    %  i.rhoprimaldr, i.tprimaldr: relaxation parameter 0 < rho < 2 and
    %  stepsize t > 0 used by the primal Douglas Rachford splitting algorithm
    %  i.rhoprimaldualdr, i.tprimaldualdr: elaxation parameter 0 < rho < 2
    %  and stepsize t > 0 used by the primal-dual Douglas Rachford splitting
    %  algorithm
    %  i.rhoadmm, i.tadmm: elaxation parameter 0 < rho < 2 and
    %  stepsize t > 0 used by the ADMM algorithm
    %  i.tcp, i.scp: step size parameters t>0, s>0 used by the Chambolle
    %  Pock algorithm
    %  i.tol: tolerance used to measure convergence of the loss
    %  i.analysis: boolean that specifies whether the algorithm prints
    %  info during each iteration)
    %
    % OUTPUTS: deblurred_x (deblurred image), summary_x (containing objective
    % function value, # of iterations, CPU time, loss)

    % selects correct norm & gamma to use for the function g (l1 or l2)
    [norm_prox, gamma] = proxproblem(problem, i);

    % starts timer
    timerstart = tic;

    % choice of algorithm
    if strcmp(algorithm, 'douglasrachfordprimal') == 1
        [x_sol, k, loss] = primaldr(b, x_original, i.tprimaldr, i.rhoprimaldr, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'douglasrachfordprimaldual') == 1
        [x_sol, k, loss] = primaldualdr(b, x_original, i.tprimaldualdr, i.rhoprimaldualdr, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'admm') == 1
        [x_sol, k, loss] = admm(b, x_original, i.tadmm, i.rhoadmm, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox);

    elseif strcmp(algorithm, 'chambollepock') == 1
        [x_sol, k, loss] = chambollepock(b, x_original, i.tcp, i.scp, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox);

    else
        error('Not a Valid Algorithm')
    end


    timerend = toc(timerstart);
    summary_x = summary(x_sol, b, gamma, kernel, k, i.maxiter, loss, timerend, i.tol);
end