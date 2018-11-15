function plot_options(min_date, max_date)

if ispc  % Use smaller font on Windows
    font_size = 9;
else
    font_size = 13;
end

inset = 15;
column_width = 190;

% Create figure -----------------------------------------------------------
options_fig = figure('units', 'normalized', 'position', [0.7, 0.6, .4, .4], 'menu', 'none',...
    'NumberTitle', 'off', 'Name', 'Set Plot Options');
set(options_fig, 'units', 'pixels')
window_px_sizes = get(options_fig, 'position');
window_width = column_width*2 + inset*4;
window_height = 200;
set(options_fig, 'position', [window_px_sizes(1), window_px_sizes(2), window_width, window_height]);

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

date_str_format = 'yyyy/mm/dd HH:MM';
min_date_field = uicontrol('Style', 'edit', 'FontSize', font_size+1,...
         'Position', [inset, y_pos, 130, selector_height],...
         'HorizontalAlignment', 'Right', 'String', datestr(min_date, date_str_format));

date_str_format = 'yyyy/mm/dd HH:MM';
min_date_field = uicontrol('Style', 'edit', 'FontSize', font_size+1,...
         'Position', [inset*3+column_width, y_pos, 130, selector_height],...
         'HorizontalAlignment', 'Right', 'String', datestr(max_date, date_str_format));
     
y_pos = y_pos - selector_height - 15;

button_height = 26;
uicontrol('Style', 'PushButton', 'Units', 'Pixels', 'Position', [(window_width-100)/2, y_pos, 100, button_height],...
        'FontSize', font_size, 'String', 'Re-Plot', 'Callback', @handle_proceed_button);

    
    function handle_proceed_button(~, ~)
        
        % Set plot type
        plot_type_str = plot_type_selector.String(plot_type_selector.Value);
        if strcmp(extractBefore(plot_type_str, ' '), 'Line')
            assignin('base', 'func_name', 'plot');
        else
            assignin('base', 'func_name', 'scatter');
        end
        
        % Set tick label interval
        assignin('base', 'x_label_interval', x_label_interval_selector.String(x_label_interval_selector.Value));
        
        % Replot data in new figure
        evalin('base', 'plot_data')
        
        % Keep plot options window on top
        uistack(options_fig, 'top')
    end

    
end