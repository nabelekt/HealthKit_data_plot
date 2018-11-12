close all;
clear;

fprintf('\nWelcome.\n');

% input_file_name = 'output.csv';

% Get data file path
if ~exist('input_file_name', 'var')
    fprintf('Please select a file (with a ''.csv'' extension) to process... ');
    [input_file_name, input_file_path] = uigetfile('*.csv');
    if input_file_name(1) == 0 || input_file_path(1) == 0
        fprintf('\nNo file selected.\nExiting.\n\n')
        return;
    end
    input_file_name = [input_file_path, input_file_name];
end

% Check if file exists, if not give error message and exit
if exist(input_file_name, 'file') ~= 2
    err_str = sprintf('ERROR: Specified input file ''%s'' could not be found.\nExiting.', input_file_name);
    msgbox(err_str)
    fprintf('\n%s\n\n', err_str);    
    return;
end

fprintf('Done.\nOpening file and determining record types... ');

% Read in data
data = readtable(input_file_name, 'Delimiter', ',', 'ReadVariableNames', true, 'HeaderLines', 0);
headers = data.Properties.VariableNames;
record_type_header = char(data.Properties.VariableNames(1));
date_header = char(data.Properties.VariableNames(2));
value_header = char(data.Properties.VariableNames(3));
unit_header = char(data.Properties.VariableNames(4));

% Create record and unit table
[record_types, ia, ~] = unique(data.(record_type_header)); % Find unique record types
record_types(:, 2) = data.(unit_header)(ia); % Find units associated with record types
record_types = cell2table(record_types, 'VariableNames', {record_type_header, unit_header});

% Have user select which record types to keep
fprintf('Done.\nPlease select record types to plot and plot type...  ');
get_user_input(record_types); % Retuns check box booleans as 'user_input'
uiwait(user_input_figure);  % Wait until user input window has been closed

% Exit if no record types were selected
if ~exist('user_input', 'var') || sum(user_input) == 0
    fprintf('\nNo record types selected.\nExiting.\n\n')
    return;
end

fprintf('Done.\nProcessing data... ');

% Keep only selected records
record_types = record_types(user_input, :);
data = data(ismember(data.(record_type_header), record_types.(record_type_header)), :);

% Get dates as strings, remove UTC offsets, convert to numeric values
dates = data.(date_header);
regex = ' [-+±]\d\d\d\d';
dates = regexprep(dates, regex, ''); % Remove UTC offsets and convert to char
dates = datenum(dates);
data.(date_header) = dates;
clear dates;

% Store tables for each record type in individual cells in cell array
num_record_types = size(record_types, 1);
data_to_plot = cell(num_record_types, 1);
for record_type_ind = 1:num_record_types
    data_indices_bool = ismember(data.(record_type_header), record_types.(record_type_header)(record_type_ind));
    data_to_plot{record_type_ind} = data(data_indices_bool, :);
end

% Get min and max dates based on user selected record types
min_date = min(data_to_plot{:}.(date_header));
max_date = max(data_to_plot{:}.(date_header));

fprintf('Done.\nPlotting data... ');

if strcmp(extractBefore(plot_type, ' '), 'Line')
    func_name = 'plot';
else
    func_name = 'scatter';
end

% Setup plot
data_plot = figure;
data_ax = axes;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [.05 .1 .9 .8])
% set(gcf, 'units', 'normalized', 'OuterPosition', [.05 .1 .1 .1])
set(gca, 'Position', [0.07 0.12 0.88 0.815])
grid on
hold on
set(gca, 'FontSize', 14, 'XLim', [min_date, max_date]);
xlabel(date_header);

% Plot each value type as separate series
for record_type_ind = 1:1%num_record_types
    feval(func_name, data_to_plot{record_type_ind}.(date_header), data_to_plot{record_type_ind}.(value_header));
    unit_name = char(data.(unit_header)(1));  % Get unit as first element in unit column
    record_type = char(data.(record_type_header)(1));  % Get record type as first element in record type column
    ylabel(sprintf('%s (%s)', record_type, unit_name));
end

% Create x-axis tick labels
ax_px_pos = getpixelposition(gca);
ax_len = ax_px_pos(3);
max_num_labels = ax_len/30; % 30 px is about the space needed for one axis label
[x_tick_vec, x_tick_label_format] = x_ticks(min_date, max_date, max_num_labels, x_tick_interval);
set(gca, 'XTickLabelRotation', 30, 'XTick', x_tick_vec)
datetick('x', x_tick_label_format, 'keepticks')

% Save figure and close
fprintf('Done.\nSaving plot as ''health_data_plot.png''... ');
saveas(gcf, 'health_data_plot.png')
fprintf('Done.\n\n');
% close(gcf)