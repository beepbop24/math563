function [deblurred_x, gamma_loss] = testinggamma(problem, algorithm, x_initial, x_original, kernel, b, i, gamma_values)
    n = length(gamma_values);
    gamma_loss = zeros(1, n);

    for k=1:n
        i.gammal1 = gamma_values(k);
        [deblurred_x, summary] = optsolver(problem, algorithm, x_initial, x_original, kernel, b, i);

        gamma_loss(k) = summary.loss;
    end
end