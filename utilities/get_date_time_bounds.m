% Get datenum bounds based on min date-time, max date-time, and interval of date-time

function bounds = get_date_time_bounds(interval, min_date, max_date)

interval = lower(interval); % Swap uppercase letters for lowercase

start = datevec(min_date);
stop = datevec(max_date);

switch interval
    case 'year'
        years = start(1):stop(1)+1;
        date_vecs(:,   1) = years';
        date_vecs(:, 2:3) = 1;
        date_vecs(:, 4:6) = 0;
        bounds = datenum(date_vecs);
    case 'quarter'
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
        bounds = datenum(date_vecs);
    case 'month'
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
        bounds = datenum(date_vecs);
    case 'week'
        min_date_t = floor(min_date);
        max_date_t = ceil(max_date);
        min_date_t = min_date_t - weekday(min_date_t) + 1;
        if weekday(max_date_t) ~= 1 % Bump max date to next sunday
            max_date_t = max_date_t + (7 - weekday(max_date_t)) + 1;
        end
        bounds = datenum(min_date_t:7:max_date_t);
    case 'day'
        min_date_t = floor(min_date);
        max_date_t = ceil(max_date);
        bounds = datenum(min_date_t:max_date_t);
    case 'hour'
        min_hour = dateshift(datetime(min_date,'ConvertFrom','datenum'), 'start', 'hour');
        max_hour = dateshift(datetime(max_date,'ConvertFrom','datenum'), 'end', 'hour');
        hour_interval = 1/24;
        bounds = datenum(min_hour:hour_interval:max_hour);
    case 'minute'
        min_hour = dateshift(datetime(min_date,'ConvertFrom','datenum'), 'start', 'minute');
        max_hour = dateshift(datetime(max_date,'ConvertFrom','datenum'), 'end', 'minute');
        hour_interval = 1/(24*60);
        bounds = datenum(min_hour:hour_interval:max_hour);
end