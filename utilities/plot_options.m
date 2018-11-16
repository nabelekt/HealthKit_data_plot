function plot_options(min_date, max_date)

if ispc  % Use smaller font on Windows
    font_size = 9;
else
    font_size = 13;
end

inset = 15;
column_1_width = 190;
column_2_width = 225;

% Create figure -----------------------------------------------------------
options_fig = figure('units', 'normalized', 'position', [0.6, 0.6, .4, .4], 'menu', 'none',...
    'NumberTitle', 'off', 'Name', 'Set Plot Options');
%         % Keep plot options window on top
%         uistack(options_fig, 'top')
assignin('base', 'plot_options_fig', options_fig)
set(options_fig, 'units', 'pixels')
window_px_sizes = get(options_fig, 'position');
window_width = column_1_width + column_2_width + inset*4;
window_height = 230;
set(options_fig, 'position', [window_px_sizes(1), window_px_sizes(2), window_width, window_height]);

y_pos = window_height;

% Plot Type ----------------------------------------------------------------------------------------
text_height = 18;
y_pos = y_pos - text_height - inset;
uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [inset, y_pos, column_1_width, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Plot type:');
    
y_pos = y_pos - text_height - 10;
selector_height = 26;
plot_type_selector = uicontrol('Style', 'PopupMenu', 'Position', [inset, y_pos, 120, selector_height],...
    'FontSize', font_size, 'HorizontalAlignment', 'Left', 'String', {'Scatter Plot', 'Line Plot'});

% Tick Labels --------------------------------------------------------------------------------------
y_pos = y_pos - selector_height - 5;
    
uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [inset, y_pos, column_1_width, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Mark date and time axis by:');
% uicontrol('Style', 'Text', 'Units', 'Pixels',...
%         'Position', [(inset*3)+column_width, y_pos, window_width/2-30, text_height], 'FontSize', font_size,...
%         'HorizontalAlignment', 'Left', 'fontweight', 'bold', 'String', 'X-tick label format:');

% Create field label with hyperlink
labelStr = ['<html><b>X-tick label format (<a href="">examples</a>):</b></html>'];
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[hjLabel,~] = javacomponent(jLabel, [(inset*3)+column_1_width, y_pos, column_2_width, text_height], gcf);
hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
set(hjLabel, 'MouseClickedCallback', @label_format_examples)
        
y_pos = y_pos - text_height - 10;
x_label_interval_selector = uicontrol('Style', 'PopupMenu', 'Position', [inset y_pos, 120, selector_height],...
    'FontSize', font_size, 'HorizontalAlignment', 'Left',...
    'String', {'Auto', 'Year', 'Quarter', 'Month', 'Week', 'Day', 'Hour', 'Minute'});
x_label_interval_field = uicontrol('Style', 'edit', 'FontSize', font_size+1,...
         'Position', [inset*3+column_1_width, y_pos, 130, selector_height],...
         'HorizontalAlignment', 'Right', 'String', evalin('base', 'x_tick_label_format_init'));

% Max and Min Dates---------------------------------------------------------------------------------
y_pos = y_pos - selector_height - 5;

uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [inset, y_pos, column_1_width, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Starting date and time:');
    
uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [(inset*3)+column_1_width, y_pos, column_2_width, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Ending date and time:');
    
y_pos = y_pos - text_height - 10;

date_str_format = 'yyyy/mm/dd HH:MM';
min_date_field = uicontrol('Style', 'edit', 'FontSize', font_size+1,...
         'Position', [inset, y_pos, 130, selector_height],...
         'HorizontalAlignment', 'Right', 'String', datestr(min_date, date_str_format));

date_str_format = 'yyyy/mm/dd HH:MM';
max_date_field = uicontrol('Style', 'edit', 'FontSize', font_size+1,...
         'Position', [inset*3+column_1_width, y_pos, 130, selector_height],...
         'HorizontalAlignment', 'Right', 'String', datestr(max_date, date_str_format));
     
y_pos = y_pos - selector_height - 15;

button_height = 26;
uicontrol('Style', 'PushButton', 'Units', 'Pixels', 'Position', [(window_width-100)/2, y_pos, 100, button_height],...
        'FontSize', font_size, 'String', 'Replot', 'Callback', @handle_proceed_button);

    
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
        
        
        assignin('base', 'x_tick_label_format', x_label_interval_field.String)
        
        % Check and set dates
        err_msg = ['ERROR: %s date and/or time is invalid.\n',...
                'Please be sure that it is in the following format:\n',...
                '    yyyy/mm/dd HH:MM\n',...
                'and that it is a valid date and time.'];
        if check_date_and_time(min_date_field.String) ~= 1
            my_msgbox(sprintf(err_msg, 'Starting'), font_size+1);
            return
        elseif check_date_and_time(max_date_field.String) ~= 1
            my_msgbox(sprintf(err_msg, 'Ending'), font_size+1);
            return
        end
        if (datenum(min_date_field.String) > datenum(max_date_field.String))
            my_msgbox('ERROR: Ending date and time must be after starting date and time.', font_size+1);
            return
        end
        assignin('base', 'min_date', datenum(min_date_field.String));
        assignin('base', 'max_date', datenum(max_date_field.String));
        
        % Replot data in new figure
        evalin('base', 'plot_data')
    end

    function return_val = check_date_and_time(date_time_str)
        return_val = -1;
        try
            y = date_time_str(1:4);
            m = date_time_str(6:7);
            d = date_time_str(9:10);
            h = str2double(date_time_str(12:13));
            min = str2double(date_time_str(15:16));
        catch
            return
        end
        if ~isValidDate([d '/' m '/' y])
            return
        end
        return_val = is_valid_time(h, min);        
    end

    function return_val = is_valid_time(hr, min)
        if (hr < 0) || (hr > 23)
            return_val = -1;
            return
        elseif (min < 0) || (min > 59)
            return_val = -1;
            return
        end
        return_val = 1;
    end

end