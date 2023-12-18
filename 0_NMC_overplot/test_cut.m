% Define the NMC series and corresponding colors
NMC_series = [2, 5, 10, 20, 40, 80, 100, 200, 400, 800];
NMC_colors = lines(numel(NMC_series));

% Preallocate arrays for storing integration matrices
integration_matrices = cell(1, numel(NMC_series));

% Loop over the NMC series
for i = 1:numel(NMC_series)
    % Load data from figure file
    fig = openfig(['test1_NMC', num2str(NMC_series(i)), '.fig']);
    a = get(gca, 'Children');
    xdata = get(a, 'XData');
    ydata = get(a, 'YData');
    zdata = get(a, 'ZData');

    x_values = xdata{2};
    y_values = ydata{2};
    z_values = zdata{2};

    % Define data subsets
    condition = (y_values >= 0.5) & (y_values <= 0.6);

    % Matrices that satisfy the condition
    x_values_subset = condition .* x_values;
    y_values_subset = condition .* y_values;
    z_values_subset = condition .* z_values;

    % 1D-cut integration
    aggregate_intensity = sum(z_values_subset, 1);
    x_range = x_values(1, :);

    integration_matrix(:, 2) = aggregate_intensity;
    integration_matrix(:, 1) = x_range;

    integration_matrices{i} = integration_matrix;
end

% Plot the overplotted cuts
figure;
hold on;
for i = 1:numel(NMC_series)
    plot(integration_matrices{i}(:, 1), integration_matrices{i}(:, 2), 'o', 'Color', NMC_colors(i, :));
end
hold off;

xlabel('Momentum Transfer Å^{-1}');
ylabel('Aggregate Intensity (arb.u.)');
title('Overplotted Cuts for Different NMCs');

% Create the legend with NMC numbers and corresponding colors
legend_labels = cell(1, numel(NMC_series));
for i = 1:numel(NMC_series)
    legend_labels{i} = sprintf('NMC %d', NMC_series(i));
end
legend(legend_labels, 'Location', 'northeast');
