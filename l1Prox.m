%% function that computes the prox of the l1-norm
function prox_x = l1Prox(x, lambda, b)
    prox_x = sign(x-b).*max(abs(x-b)-lambda, 0);
end
