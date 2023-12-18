clear all;
close all;

% Define the NMC series and corresponding colors
NMC_series = [2, 5, 10, 20, 40, 80, 100, 200, 400, 800];
NMC_colors = lines(numel(NMC_series));

% Preallocate arrays for storing integration matrices
integration_matrices = cell(1, numel(NMC_series));

% Define the binning parameters
bin_width = 0.1;
bin_edges = 0:bin_width:1.4;

% Loop over the NMC series
for i = 1:numel(NMC_series)
    % Load data from figure file
    
    % invisible
    fig = openfig(['test1_NMC', num2str(NMC_series(i)), '.fig'],'invisible');
    %fig = openfig(['test1_NMC', num2str(NMC_series(i)), '.fig']);
     
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

    % Binning
    [~, bin_indices] = histc(x_values_subset, bin_edges);

    % Calculate the aggregate intensity for each bin
    aggregate_intensity = accumarray(bin_indices(bin_indices > 0), z_values_subset(bin_indices > 0), [numel(bin_edges)-1, 1], @sum);

    % Create x-axis values for the bins
    x_range = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;

    integration_matrix(:, 2) = aggregate_intensity;
    integration_matrix(:, 1) = x_range;

    integration_matrices{i} = integration_matrix;
end

% Plot the overplotted cuts
figure;
hold on;
for i = 1:numel(NMC_series)
    plot(integration_matrices{i}(:, 1), integration_matrices{i}(:, 2), 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', NMC_colors(i, :));
end
hold off;

xlabel('Momentum Transfer Å^{-1}');
ylabel('Aggregate Intensity (arb.u.)');
title('Overplotted 1D Momentum Cuts for NMCs');

% Create the legend with NMC numbers and corresponding colors
legend_labels = cell(1, numel(NMC_series));
for i = 1:numel(NMC_series)
    legend_labels{i} = sprintf('NMC %d', NMC_series(i));
end
legend(legend_labels, 'Location', 'northeast');

while true
    % Prompt the user to select a graph to view
    [graphIndex, ~] = listdlg('PromptString', 'Select a graph to view:', 'ListString', legend_labels);

    % Show the selected graph
    figure;
    plot(integration_matrices{graphIndex}(:, 1), integration_matrices{graphIndex}(:, 2), 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', NMC_colors(graphIndex, :));
    xlabel('Momentum Transfer Å^{-1}');
    ylabel('Aggregate Intensity (arb.u.)');
    ylim([0, 250])
    title(sprintf('1D-Cut for NMC %d', NMC_series(graphIndex)));
    axis([0 1.4 0 250])
    
    % Wait for the user to close the figure
    waitfor(gcf);
end
