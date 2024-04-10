function [deblurred_x, gamma_loss] = testinggamma(problem, algorithm, x_initial, x_original, kernel, b, i, gamma_values)
    % function that tests performance of algorithm on various values of gamma
    % INPUTS: type of problem (l1 or l2), type of algorithm ("douglasrachfordprimal",
    % "douglasrachfordprimaldual", "admm", and "chambollepock"), initial
    % guess x_initial, original image x_original, kernel, blurred image b,
    % i parameter values and gamma values to iterate over
    % OUTPUTS: loss array with loss for each value of gamma and last deblurred
    % image

    n = length(gamma_values);
    gamma_loss = zeros(1, n);

    for k=1:n
        i.gammal1 = gamma_values(k);
        i.gammal2 = gamma_values(k);
        [deblurred_x, summary] = optsolver(problem, algorithm, x_initial, x_original, kernel, b, i);

        gamma_loss(k) = summary.loss;
    end
end