function x_ticks = x_ticks(min_date, max_date, max_num_labels, x_label_interval)

start = datevec(min_date);
stop = datevec(max_date);

if strcmp(char(x_label_interval), 'year')
    % Set label values to 01/01/YYYY 00:00:00
    years = start(1):stop(1)+1;
    date_vecs(:,   1) = years';
    date_vecs(:, 2:3) = 1;
    date_vecs(:, 4:6) = 0;
    x_ticks = datenum(date_vecs);
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
elseif strcmp(char(x_label_interval), 'week')
    % Set label values to MM/DD/YYYY 00:00:00
    min_date_t = floor(min_date);
    max_date_t = ceil(max_date);
    min_date_t = min_date_t - weekday(min_date_t) + 1;
    max_date_t = max_date_t + 7 - weekday(max_date_t) + 1;
    x_ticks = datenum(min_date_t:7:max_date_t);
end

% Reduce number of labels by ~half if there are too many
while length(x_ticks) > max_num_labels
    x_ticks_t = x_ticks(1:2:length(x_ticks));
    if mod(length(x_ticks), 2) == 0
        x_ticks_t = [x_ticks_t(1:end-1), x_ticks(end)];
    end
    x_ticks = x_ticks_t;
end