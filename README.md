# Image Deblurring -- MATH563 Final Project -- Winter 2024

optsolver is a package used to deblur black and white images with Matlab

## Usage

```matlab
    %INPUTS: problem ('l1' or 'l2' indicating the norm to use), 
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

    % will run if i = struct(), with default parameters

    %OUTPUTS: x_sol (deblurred image), summary_x (containing objective
    % function value, # of iterations, CPU time, final loss) and loss array

[x_sol, summary_x, loss] = optsolver(‘problem’, ‘algorithm’,xinitial, kernel, b, i);
```
