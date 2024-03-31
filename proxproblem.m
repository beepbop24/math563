function [norm_prox, gamma] = proxproblem(problem, i)
    % function that specifies what norm to use for the prox of g(y1)
    % INPUTS: problem type (l1 or l2), input parameter values i
    % OUTPUTS: method that applies correct prox operator and correct gamma
    % to use

    if strcmp(problem, 'l1') == 1
        norm_prox = @(x, lambda, b) l1Prox(x, lambda, b);
        gamma = i.gammal1;

    elseif strcmp(problem, 'l2') == 1
        norm_prox = @(x, lambda, b) l2Prox(x, lambda,b);
        gamma = i.gammal2;

    else
       error('Not a Valid Algorithm')
    end
end
