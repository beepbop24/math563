function info = summary(x, b, gamma, kernel, k, maxiter, loss, timerend, tol)
    % function that produces a summary of each algorithm
    % INPUTS: (partially) deblurred image x, blurred image b, blurring kernel, number of
    % iterations the algorithm ran for k, the number of max iterations, the
    % value of the loss function when the algorithm stopped, loss and the
    % CPU time timerend
    % OUTPUT: info which contains the result (convergence + number of
    % iterations), f (value of objective function), loss (value of loss
    % function at the end) and CPU time

    % computes whether convergence was reached or algorithm stopped after
    % too many iterations
    if k < maxiter
        info.result = "Convergence achieved after " + int2str(k) + ...
            " iterations, for tolerance = " + int2str(tol);
    else
        info.result = "Convergence not achieved. Algorithm stopped after " ...
            + int2str(k) + " iterations, for tolerance = " + int2str(tol);
    end

    % computes value of objective function at the end of the algorithm
    info.f = objectivefunction(x, b, gamma, kernel);
    
    % adds loss value to objective function
    info.loss = loss(k);
    info.CPUtime = timerend;

    disp(info);

end