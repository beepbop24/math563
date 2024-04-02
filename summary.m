function info = summary(x, b, gamma, kernel, k, maxiter)

    % computes whether convergence was reached or algorithm stopped after
    % too many iterations
    if k < maxiter
        info.result = "Convergence achieved after " + int2str(k) + " iterations";
    else
        info.result = "Convergence not achieved. Algorithm stopped after " + int2str(k) + " iterations. ";
    end

    % computes value of objective function at the end of the algorithm
    info.f = objectivefunction(x, b, gamma, kernel);


end