function plot_options(min_date, max_date)

if ispc  % Use smaller font on Windows
    font_size = 9;
else
    font_size = 13;
end

inset = 15;
column_width = 160;

% Create figure -----------------------------------------------------------
fig = figure('units', 'normalized', 'position', [0.7, 0.6, .4, .4], 'menu', 'none',...
    'NumberTitle', 'off', 'Name', 'Set Plot Options');
set(fig, 'units', 'pixels')
window_px_sizes = get(fig, 'position');
window_width = column_width*2 + inset*4;
window_height = 200;
set(fig, 'position', [window_px_sizes(1), window_px_sizes(2), window_width, window_height]);

y_pos = window_height;

% Plot type and tick labels ----------------------------------------------
text_height = 18;
y_pos = y_pos - text_height - inset;
uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [inset, y_pos, window_width/2-30, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Plot type:');
    
uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [(inset*3)+column_width, y_pos, window_width/2-30, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Mark date and time axis by:');
    
y_pos = y_pos - text_height - 10;
    
selector_height = 26;
plot_type_selector = uicontrol('Style', 'PopupMenu', 'Position', [inset, y_pos, 120, selector_height],...
    'FontSize', font_size, 'HorizontalAlignment', 'Left', 'String', {'Scatter Plot', 'Line Plot'});
    
x_label_interval_selector = uicontrol('Style', 'PopupMenu', 'Position', [(inset*3)+column_width, y_pos, 120, selector_height],...
    'FontSize', font_size, 'HorizontalAlignment', 'Left',...
    'String', {'Auto', 'Year', 'Month', 'Week', 'Day', 'Hour', 'Minute'});

y_pos = y_pos - selector_height - 15;

uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [inset, y_pos, window_width/2-30, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Starting date and time:');
    
uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [(inset*3)+column_width, y_pos, window_width/2-30, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Ending date and time:');
    
y_pos = y_pos - text_height - 10;

field_spacer = 5;

date_min_vec = datevec(min_date);
date_min_vec = num2str(date_min_vec(:));
field_widths = [0 50 25 25 25 25];
for field_ind = 1:5
    x_pos = inset+field_spacer*(field_ind-1)+sum(field_widths(1:field_ind));
    min_date_field(field_ind) = uicontrol('Style', 'edit', 'FontSize', font_size,...
         'Position', [x_pos, y_pos, field_widths(field_ind+1), selector_height],...
         'HorizontalAlignment', 'Right', 'String', date_min_vec(field_ind, :)); %#ok<AGROW>
%     set(min_date_field(field_ind), 'Units', 'characters')
%     pos = get(min_date_field(field_ind), 'Position');
%     field_width = size(date_min_vec(field_ind, :), 2);
%     set(min_date_field(field_ind), 'Position', [pos(1)+last_field_width pos(2) field_width pos(4)])
%     last_field_width = field_width;
end
    
max_date_field = uicontrol('Style', 'edit', 'Position', [(inset*3)+column_width, y_pos, 120, selector_height],...
    'FontSize', font_size, 'HorizontalAlignment', 'Left',...
    'String', {'Auto', 'Year', 'Month', 'Week', 'Day', 'Hour', 'Minute'});

y_pos = y_pos - selector_height - 15;

button_height = 26;
uicontrol('Style', 'PushButton', 'Units', 'Pixels', 'Position', [(window_width-100)/2, y_pos, 100, button_height],...
        'FontSize', font_size, 'String', 'Proceed', 'Callback', @handle_proceed_button);

    
    function handle_proceed_button(~, ~)
        
    end
end