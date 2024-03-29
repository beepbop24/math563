function prox_x = l2Prox(x,lambda, b)
    % function that computes the prox of the l2-norm of (x-b)
    % INPUT: current image x, blurred image b and lambda (step-size here)
    % OUTPUT: prox of (x-b)
    prox_x = (x+2*lambda*b)./(1+2*lambda);
end