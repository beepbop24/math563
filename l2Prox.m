%% function that computes the prox of the l2-norm
function prox_x = l2Prox(x,lambda, b)
    prox_x = norm(x-b, 2)/(1+2*lambda);
end