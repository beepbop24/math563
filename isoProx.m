%% function that computes the prox of the iso norm (formula from hint)
function [u, v] = isoProx(x, y, lambda, gamma)
    lambda=lambda*gamma;   % prox_{gamma lambda f}(x) = prox_{lambda * (gamma f)}(x)

    alpha = 1-min(lambda./sqrt(x.^2+y.^2), 1);
    u = alpha.*x;
    v=alpha.*y;

end