% cut_momentum: pick up y-range and integrate them to show 1D cut with x-axis of momentum.
% cut_energy: pick up x-range and integrate them to show 1D cut with x-axis of energy.
% In this code, we make cut_momentum.


%% #1 Load data from figure file
fig = openfig('test1_NMC20.fig');
a = get(gca, 'Children');
xdata = get(a, "XData");
ydata = get(a, "YData");
zdata = get(a, "ZData");

x_values = xdata{2};
y_values = ydata{2};
z_values = zdata{2};

%% #2 Define data subsets
condition = (y_values >= 0.5) & (y_values <= 0.6);

% matrices that suffice given condition
% multiplication of subset matrices and condition (boolean values) matrix, element by element
x_values_subset=condition.*x_values;
y_values_subset=condition.*y_values;
z_values_subset=condition.*z_values;

%% #3 crosscheck - reproducing original figure
figure;
pcolor(x_values,y_values,z_values)
caxis([0 2]); %
colormap(flipud(hot)); %type of colormap name
shading flat
colorbar();
h = colorbar;
set(get(h,'label'),'string','Intensity (arb.u.)');
xlabel('Momentum Transfer Å^-1');
ylabel('Energy transfer (meV)');
title(sprintf('Convoluted powder spectra'));


%% #4 crosscheck - cut momentum plot
figure;
pcolor(x_values,y_values,z_values_subset)
caxis([0 2]); %
colormap(flipud(hot)); %type of colormap name
shading flat
colorbar();
h = colorbar;
set(get(h,'label'),'string','Intensity (arb.u.)');
xlabel('Momentum Transfer Å^-1');
ylabel('Energy transfer (meV)');
title(sprintf('Convoluted powder spectra - momentum cut'));


%% #5 1d-cut integration
aggregate_intensity = sum(z_values_subset,1); 
x_range = x_values(1,:);

integration_matrix(:,2) = aggregate_intensity;
integration_matrix(:,1) = x_range;

figure;
plot(integration_matrix(:,1), integration_matrix(:,2), 'ro');
xlabel('Momentum Transfer Å^-1');
ylabel('Aggregate Intensity (arb.u.)');
title(sprintf('Momentum vs intensity - 1D momentum cut'));
ylim([0, 250]); % Set the y-axis limits to [0, 250]


%% #6 binning data
num_bars = 10;

% If bar_intensity is used elsewhere in the code,
% initialize an array to store the accumulated intensities for each bar
bar_intensity = zeros(num_bars, 1);

% Compute the bar edges based on x_range values
bar_edges = linspace(min(x_range), max(x_range), num_bars + 1);

% Bin the data to bars
for i = 1:num_bars
    bar_indices = x_range >= bar_edges(i) & x_range <= bar_edges(i+1);
    bar_intensity(i) = sum(sum(z_values_subset(:, bar_indices), 1));
end

% Compute the bar centers
bar_centers = (bar_edges(1:end-1) + bar_edges(2:end)) / 2;

figure;
bar(bar_centers, bar_intensity, 'BarWidth', 1);
xlabel('Momentum Transfer Å^{-1}');
ylabel('Aggregate Intensity (arb.u.)');
title(sprintf('Binned Data: Momentum vs Intensity - 1D momentum cut'));
ylim([0, 400]); % Set the y-axis limits to [0, 400]

% Calculate the total intensity by summing all the binned intensities
total_intensity = sum(bar_intensity);
disp(['Total Intensity: ', num2str(total_intensity)]);



