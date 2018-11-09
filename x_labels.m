function x_tick_labels = x_labels(min_date, max_date, max_num_labels, x_label_interval)
start = datevec(min_date);
stop = datevec(max_date);


if strcmp(char(x_label_interval), 'year')
    % Set labels to 01/01/YYYY 00:00:00
    years = start(1):stop(1)+1;
    date_vecs(:,   1) = years';
    date_vecs(:, 2:3) = 1;
    date_vecs(:, 4:6) = 0;
    x_tick_labels = datenum(date_vecs);
elseif strcmp(char(x_label_interval), 'month')
    % Set labels to MM/01/YYYY 00:00:00
    years = start(1):stop(1);
%     months = start(
    date_vecs(:,   1) = years';
    date_vecs(:, 2:3) = 1;
    date_vecs(:, 4:6) = 0;
    x_tick_labels = datenum(date_vecs);
end

if length(x_tick_labels) > max_num_labels
    end_ind = length(x_tick_labels);
    if mod(end_ind, 2) == 0
        end_ind = end_ind + 1;
    end
    x_tick_labels = x_tick_labels(1:2:end_ind);
end