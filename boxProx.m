%% function that computes the prox of indicator function (projection onto S)
function prox_x = boxProx(x)
    prox_x = min(max(x, 0), 1);
end