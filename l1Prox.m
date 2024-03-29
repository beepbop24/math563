function prox_x = l1Prox(x, lambda, b)
    % function that computes the prox of the l1-norm of (x-b)
    % INPUT: current image x, blurred image b and lambda (step-size here)
    % OUTPUT: prox of (x-b)
    prox_x = sign(x-b).*max(abs(x-b)-lambda, 0)+b;
end
