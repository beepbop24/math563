function prox_x = boxProx(x)
    % function that computes the prox of indicator function (projection onto S)
    % INPUT: current image x
    % OUTPUT: prox of x
    prox_x = min(max(x, 0), 1);
end