function [deblurred_x, s_loss] = testingscp(problem, x_initial, x_original, kernel, b, i, s_values)
    n = length(s_values);
    s_loss = zeros(1, n);

    for k=1:n
        i.scp = s_values(k);

        % test for l1 problem
        [deblurred_x, summary] = optsolver(problem, 'chambollepock', x_initial, x_original, kernel, b, i);
        s_loss(k) = summary.loss;
    end
end