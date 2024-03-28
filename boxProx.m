%% function that computes the prox of indicator function (projection onto S)
function prox_x = boxProx(x, lambda)
    prox_x = 1/(2*lambda)*min(max(x, 0), 1);
end