% NOTE: Some values used here are assigned by handle_proceed_button() in plot_options.m

fprintf('Plotting data... ');

% Determin date range ------------------------------------------------------------------------------
min_date = min_date_init;
max_date = max_date_init;
if exist('min_date_t', 'var')
    min_date = min_date_t;
end
if exist('max_date_t', 'var')
    max_date = max_date_t;
end

% Setup plot ---------------------------------------------------------------------------------------
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
xlabel(date_header);

% Plot data ----------------------------------------------------------------------------------------
% % Plot each value type as separate series
% for record_type_ind = 1:1%num_record_types
[dates_and_times, values] = aggregate_data(...
    aggregate_data_by, data_to_plot{record_type_ind}.(date_header), data_to_plot{record_type_ind}.(value_header),...
    min_date, max_date);
feval(func_name, dates_and_times, values);
unit = char(data.(unit_header)(1));  % Get unit as first element in unit column
% end

% Setup date-and-time-axis -------------------------------------------------------------------------
set(gca, 'FontSize', font_size, 'XLim', [min_date, max_date]);
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

% Setup y-axis -------------------------------------------------------------------------------------
if exist('y_min_t', 'var') && exist('y_max_t', 'var')
	set(data_ax, 'YLim', [y_min_t y_max_t]);
elseif exist('y_min_t', 'var')
	set(data_ax, 'YLim', [y_min_t data_ax.YLim(2)]);
elseif exist('y_min_t', 'var')
	set(data_ax, 'YLim', [data_ax.YLim(1) y_max_t]);
end

ylabel(sprintf('%s (%s)', record_type, unit));  % record_type is set by select_record_types


% --------------------------------------------------------------------------------------------------
% Set data cursor to show date and time as date string
data_cursor_h = datacursormode(gcf);
set(data_cursor_h, 'UpdateFcn', @data_cursor_text)

fprintf('Done.\n');

% Open plot options figure and reopen if it was closed
if ~exist('plot_options_fig', 'var') || ~ishandle(plot_options_fig)
    plot_options(min_date, max_date, unit, data_ax.YLim(1), data_ax.YLim(2));
end