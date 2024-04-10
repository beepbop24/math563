function f = objectivefunction(x, b, gamma, kernel, problem)
    % function that computes the value of the objective function for x
    % INPUTS: partially deblurred x, blurred image b, blurring kernel and
    % gamma used for isoprox
    % OUTPUTS: value of the objective function

    % importing multiplyingMatrix methods to compute matrix multiplication
    % here u=1 is unused
    [applyK, applyD1, applyD2] = multiplyingMatrix(b, kernel, 1);

    if all(x(:) <= 1) && all(x(:) >= 0)
        % first term is l1 or l2 norm of Kx-b, second term is gamma * iso norm of Dx 
        % (in this case the indicator function is 0)
        if strcmp(problem, 'l1') == 1
            norm_term = norm(applyK(x)-b, 1);

        elseif strcmp(problem, 'l2') == 1
            norm_term = norm(applyK(x)-b, 2)^2;
        end
        

        f = norm_term + gamma*sum(sqrt(applyD1(x).^2+applyD2(x).^2), "all");

    else
        % pixel values are not between 0 and 1 so indicator function is +
        % infinity
        f = Inf;
    end
end