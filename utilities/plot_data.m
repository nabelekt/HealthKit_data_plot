fprintf('Plotting data... ');

% Setup plot
if exist('data_plot', 'var') && ishandle(data_plot)
    close(data_plot)
end
data_plot = figure;
data_ax = axes;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [.05 .1 .9 .8])
% set(gcf, 'units', 'normalized', 'OuterPosition', [.05 .1 .1 .1])
set(gca, 'Position', [0.07 0.12 0.88 0.815])
grid on
hold on
set(gca, 'FontSize', font_size, 'XLim', [min_date, max_date]);
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
[x_tick_vec, x_tick_label_format_init] = x_ticks(min_date, max_date, max_num_labels, x_label_interval);
set(gca, 'XTickLabelRotation', 30, 'XTick', x_tick_vec)

try % If label format was set and valid, use it
    datetick('x', x_tick_label_format, 'keepticks')
catch % If label format was not set or not valid, use auto label format
    datetick('x', x_tick_label_format_init, 'keepticks')
    if exist('x_tick_label_format', 'var') % If not the first time through
        err_box = my_msgbox(sprintf('ERROR: X-tick label format is not recognized.\nPlease see exampels.'), font_size);
    end
end
uistack(data_plot, 'bottom') % Keep plot options window on top

fprintf('Done.\n');

% Open plot options figure and reopen if it was closed
if ~exist('plot_options_fig', 'var') || ~ishandle(plot_options_fig)
    plot_options(min_date, max_date);
end