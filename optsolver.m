function [x_sol, summary_x, loss] = optsolver(problem, algorithm, x_initial, x_original, kernel, b, i)
    % function that computes given algorithm to deblur image
    % INPUTS: problem ('l1' or 'l2' indicating the norm to use), 
    % algorithm (algorithm of choice from "douglasrachfordprimal",
    % "douglasrachfordprimaldual", "admm", and "chambollepock")
    % x_initial: initial guess of the correct image
    % x_original: true image
    % b: blurred & noisy image
    % i (struct containing the following hyperparameters:
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
    % function value, # of iterations, CPU time, final loss) and loss array

    % DEFAULT PARAMETER VALUES -- optimal values found during testing
    % maximum number of iterations
    defaults.maxiter = 500;

    % denoising for l1 and l2 loss
    defaults.gammal1 = 0.049;
    defaults.gammal2 = 0.049;

    % relaxation parameter (rho in (0, 2)) and step size t > 0 for Primal
    % Douglas-Rachford Splitting
    defaults.rhoprimaldr = 2;
    defaults.tprimaldr = 0.1;

    % relaxation parameter (rho in (0, 2)) and step size t > 0 for Primal Dual
    % Douglas-Rachford Splitting
    defaults.rhoprimaldualdr = 1.5;
    defaults.tprimaldualdr = 0.1;

    % relaxation parameter (rho in (0, 2)) and step size t > 0 for Alternating
    % Direction Method of Multipliers
    defaults.rhoadmm = 1.5;
    defaults.tadmm = 0.1;

    % step size parameters s > 0, t > 0 for the Chambolle-Pock Algorithm
    defaults.tcp = 0.1;
    defaults.scp = 0.1;

    % other parameters (basically no tolerance as
    % default, the algorithm will run for the number of specified iterations)
    defaults.tol = 0;
    defaults.analysis = false;

    % setting i values with default if not specified in user input
    default_names = fieldnames(defaults);
    i_names = fieldnames(i);
    missing = find(~ismember(default_names, i_names));

    for k = 1:length(missing)
        i.(default_names{missing(k)}) = defaults.(default_names{missing(k)});
    end


    % selects correct norm & gamma to use for the function g (l1 or l2)
    [norm_prox, gamma] = proxproblem(problem, i);

    % starts timer
    timerstart = tic;

    % choice of algorithm
    if strcmp(algorithm, 'douglasrachfordprimal') == 1
        [x_sol, k, loss] = primaldr(b, x_original, i.tprimaldr, i.rhoprimaldr, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox, problem);

    elseif strcmp(algorithm, 'douglasrachfordprimaldual') == 1
        [x_sol, k, loss] = primaldualdr(b, x_original, i.tprimaldualdr, i.rhoprimaldualdr, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox, problem);

    elseif strcmp(algorithm, 'admm') == 1
        [x_sol, k, loss] = admm(b, x_original, i.tadmm, i.rhoadmm, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox, problem);

    elseif strcmp(algorithm, 'chambollepock') == 1
        [x_sol, k, loss] = chambollepock(b, x_original, i.tcp, i.scp, gamma, i.maxiter, i.tol, i.analysis, x_initial, kernel, norm_prox, problem);

    else
        error('Not a Valid Algorithm')
    end


    timerend = toc(timerstart);
    [summary_x, loss] = summary(x_sol, b, gamma, kernel, k, i.maxiter, loss, timerend, i.tol, problem);
end