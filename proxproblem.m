function norm_prox = proxproblem(problem)
    % function that specifies what norm to use for the prox of g(y1)
    % INPUT: problem type (l1 or l2)
    % OUTPUT: method that applies correct prox operator 

    if strcmp(problem, 'l1') == 1
        norm_prox = @(x, lambda, b) l1Prox(x, lambda, b);

    elseif strcmp(problem, 'l2') == 1
        norm_prox = @(x, lambda, b) l2Prox(x, lambda,b);

    else
       error('Not a Valid Algorithm')
    end
end
