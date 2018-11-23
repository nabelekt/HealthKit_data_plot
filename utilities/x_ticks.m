function [x_ticks, x_tick_label_format] = x_ticks(min_date, max_date, max_num_labels, x_label_interval)

x_label_interval = lower(x_label_interval); % Swap uppercase letters for lowercase

if strcmp(char(x_label_interval), 'auto')
    dt = max_date - min_date;  % Find number of days being plotted
    min_interval = dt/max_num_labels;  % Find smallest number of days/tick given max_num_labels
    if min_interval > 92
        x_label_interval = 'year';
    elseif min_interval > 31
        x_label_interval = 'quarter';
    elseif min_interval > 7
        x_label_interval = 'month';
	elseif min_interval > 1
        x_label_interval = 'week';
	elseif min_interval > 1/24
        x_label_interval = 'day';
	elseif min_interval > 1/(24*60)
        x_label_interval = 'hour';
    else
        x_label_interval = 'minute';
    end
end

x_label_interval = char(x_label_interval);

start = datevec(min_date);
stop = datevec(max_date);

% Set 'year', 'quarter', 'month', 'week', and 'day' label values to 01/01/YYYY 00:00:00
% Set 'hour' label values to 01/01/YYYY hh:00:00
% Set 'hour' label values to 01/01/YYYY hh:mm:00
x_ticks = get_date_time_bounds(x_label_interval, min_date, max_date);

switch x_label_interval
    case 'year'
        x_tick_label_format = 'mm/dd/yy';
    case 'quarter'
        x_tick_label_format = 'mm/dd/yy';
    case 'month'
        x_tick_label_format = 'mm/dd/yy';
    case 'week'
        x_tick_label_format = 'mm/dd/yy';
    case 'day'
        x_tick_label_format = 'mm/dd/yy';
    case 'hour'
        x_tick_label_format = 'mm/dd/yy HH:MM';
    case 'minute'
        x_tick_label_format = 'mm/dd/yy HH:MM';
end

% Recursively reduce number of labels by ~half if there are too many
while length(x_ticks) > max_num_labels
    x_ticks_t = x_ticks(1:2:length(x_ticks));
    if mod(length(x_ticks), 2) == 0
        x_ticks_t = [x_ticks_t(1:end-1), x_ticks(end)];
    end
    x_ticks = x_ticks_t;
end