function [deblurred_x, s_loss] = testingscp(problem, x_initial, x_original, kernel, b, i, s_values)
    % function that tests performance of algorithm on various values of s
    % for Chambolle-Pock algorithm
    % INPUTS: type of problem (l1 or l2), initial
    % guess x_initial, original image x_original, kernel, blurred image b,
    % i parameter values and s values to iterate over
    % OUTPUTS: loss array with loss for each value of s and last deblurred
    % image

    n = length(s_values);
    s_loss = zeros(1, n);

    for k=1:n
        i.scp = s_values(k);

        % test for l1 problem
        [deblurred_x, summary] = optsolver(problem, 'chambollepock', x_initial, x_original, kernel, b, i);
        s_loss(k) = summary.loss;
    end
end