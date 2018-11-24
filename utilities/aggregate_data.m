% Aggregate data by summing data points over specified time period

function [dates_and_times_out, values_out] = aggregate_data(aggregate_data_by, dates_and_times_in, values_in,...
    min_date, max_date)

aggregate_data_by = lower(aggregate_data_by); % Swap uppercase letters for lowercase

if strcmp('none', aggregate_data_by)
    dates_and_times_out = dates_and_times_in;
    values_out = values_in;
else
    bounds = get_date_time_bounds(char(aggregate_data_by), min_date, max_date);
    values_out = zeros(length(bounds)-1, 1);
    for bound_ind = 1:length(bounds)-1
        values_in_range = values_in((dates_and_times_in >= bounds(bound_ind)) & (dates_and_times_in < bounds(bound_ind+1)));
        values_out(bound_ind) = sum(values_in_range);
    end
    dates_and_times_out = bounds(1:end-1);
end