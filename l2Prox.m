%% function that computes the prox of the l2-norm of (x-b)
function prox_x = l2Prox(x,lambda, b)
    prox_x = (x+2*lambda*b)./(1+2*lambda);
end