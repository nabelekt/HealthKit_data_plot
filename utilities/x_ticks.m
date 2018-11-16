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

start = datevec(min_date);
stop = datevec(max_date);

if strcmp(char(x_label_interval), 'year')
    % Set label values to 01/01/YYYY 00:00:00
    years = start(1):stop(1)+1;
    date_vecs(:,   1) = years';
    date_vecs(:, 2:3) = 1;
    date_vecs(:, 4:6) = 0;
    x_ticks = datenum(date_vecs);
    x_tick_label_format = 'mm/dd/yy';
elseif strcmp(char(x_label_interval), 'quarter')
    % Set label values to MM/01/YYYY 00:00:00
    num_years = stop(1) - start(1) + 1;
    % Map to start of quarter
    switch true
        case ismember(start(2), [1, 2, 3])
            month_start = 1;
        case ismember(start(2), [4, 5, 6])
            month_start = 4;
        case ismember(start(2), [7, 8, 9])
            month_start = 7;
        case ismember(start(2), [10, 11, 12])
            month_start = 10;
    end
    % Map to end of quarter
    switch true
        case ismember(stop(2), [1, 2, 3])
            month_end = 4;
        case ismember(stop(2), [4, 5, 6])
            month_end = 7;
        case ismember(stop(2), [7, 8, 9])
            month_end = 10;
        case ismember(stop(2), [10, 11, 12])
            month_end = 1;
    end
    months = month_start:3:12;
    if num_years > 2
        months = [months, repmat(1:3:12, 1, num_years-2)];
    end
    if num_years > 1
        month_end_t = month_end;
        if month_end == 1
            month_end_t = 10;
        end
        months = [months, 1:3:month_end_t];
        if month_end == 1
            months = [months, 1];
        end        
    end
    date_vecs(:, 2) = months';
    
    year = start(1);
    for date_ind = 1:size(date_vecs, 1)
        date_vecs(date_ind, 1) = year;
        if date_vecs(date_ind, 2) >= 10
            year = year + 1;
        end
    end
    
    date_vecs(:,   3) = 1;
    date_vecs(:, 4:6) = 0;
    x_ticks = datenum(date_vecs);
    x_tick_label_format = 'mm/dd/yy';
elseif strcmp(char(x_label_interval), 'month')
    % Set label values to MM/01/YYYY 00:00:00
    num_years = stop(1) - start(1) + 1;
    months = start(2):12;
    if num_years > 2
        months = [months, repmat(1:12, 1, num_years-2)];
    end
    if num_years > 1
        months = [months, 1:stop(2)];
    end
    date_vecs(:, 2) = months';
    
    year = start(1);
    for date_ind = 1:size(date_vecs, 1)
        date_vecs(date_ind, 1) = year;
        if date_vecs(date_ind, 2) == 12
            year = year + 1;
        end
    end
    
    date_vecs(:,   3) = 1;
    date_vecs(:, 4:6) = 0;
    x_ticks = datenum(date_vecs);
    x_tick_label_format = 'mm/dd/yy';
elseif strcmp(char(x_label_interval), 'week')
    % Set label values to MM/DD/YYYY 00:00:00
    min_date_t = floor(min_date);
    max_date_t = ceil(max_date);
    min_date_t = min_date_t - weekday(min_date_t) + 1;
    if weekday(max_date_t) ~= 1 % Bump max date to next sunday
        max_date_t = max_date_t + (7 - weekday(max_date_t)) + 1;
    end
   
    x_ticks = datenum(min_date_t:7:max_date_t);
    x_tick_label_format = 'mm/dd/yy';
elseif strcmp(char(x_label_interval), 'day')
    % Set label values to MM/DD/YYYY 00:00:00
    min_date_t = floor(min_date);
    max_date_t = ceil(max_date);
    x_ticks = datenum(min_date_t:max_date_t);
    x_tick_label_format = 'mm/dd/yy';
elseif strcmp(char(x_label_interval), 'hour')
    % Set label values to MM/DD/YYYY hh:00:00
    min_hour = dateshift(datetime(min_date,'ConvertFrom','datenum'), 'start', 'hour');
    max_hour = dateshift(datetime(max_date,'ConvertFrom','datenum'), 'end', 'hour');
    hour_interval = 1/24;
    x_ticks = datenum(min_hour:hour_interval:max_hour);
    x_tick_label_format = 'mm/dd/yy HH:MM';
elseif strcmp(char(x_label_interval), 'minute')
    % Set label values to MM/DD/YYYY hh:00:00
    min_hour = dateshift(datetime(min_date,'ConvertFrom','datenum'), 'start', 'minute');
    max_hour = dateshift(datetime(max_date,'ConvertFrom','datenum'), 'end', 'minute');
    hour_interval = 1/(24*60);
    x_ticks = datenum(min_hour:hour_interval:max_hour);
    x_tick_label_format = 'mm/dd/yy HH:MM';
end

% Reduce number of labels by ~half if there are too many
while length(x_ticks) > max_num_labels
    x_ticks_t = x_ticks(1:2:length(x_ticks));
    if mod(length(x_ticks), 2) == 0
        x_ticks_t = [x_ticks_t(1:end-1), x_ticks(end)];
    end
    x_ticks = x_ticks_t;
end