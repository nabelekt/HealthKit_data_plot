function x_tick_labels = auto_x_labels(min_date, max_date, max_num_labels)
start = datevec(min_date);
stop = datevec(max_date);

if max_date-min_date >= 4*365.25
    x_tick_labels = start(1) :  : stop(1)+1
elseif max_date-min_date >= 365
    
else
    

end