function select_record_types(record_types)

if ispc  % Use smaller font on Windows
    font_size = 9;
else
    font_size = 13;
end

record_type_names = table2cell(record_types(:, 1));
record_type_names = strrep(record_type_names, 'HKQuantityTypeIdentifier', '');
record_units = table2cell(record_types(:, 2));

% half_record_count = ceil(size(record_types, 1)/2);
inset = 15;
checkbox_width = 250;

% Create figure
fig = figure('units', 'normalized', 'position', [.3, .4, .4, .4], 'menu', 'none',...
    'NumberTitle', 'off', 'Name', 'Select Record Types');
assignin('base', 'user_input_figure', fig); % Used by uiwait() in main script
set(fig, 'units', 'pixels')
window_px_sizes = get(fig, 'position');
window_width = checkbox_width*2 + inset*4;
window_height = 175;
set(fig, 'position', [window_px_sizes(1), window_px_sizes(2), window_width, window_height]);

y_pos = window_height;

% Create record selection note
text_height = 18;
y_pos = y_pos - text_height*2;
url = 'https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier';
msg_str = sprintf(['<html>For an explination of record types, see <a href="' url '">Apple''s documentation</a>.']);
jLabel = javaObjectEDT('javax.swing.JLabel', msg_str);
[hjLabel,~] = javacomponent(jLabel, [inset, y_pos, window_width-30, text_height], gcf);
hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
set(hjLabel, 'MouseClickedCallback', @(h,e)web(url, '-browser'))

% uicontrol('Style', 'Text', 'Units', 'Pixels',...
%         'Position', [inset, y_pos, window_width-30, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
%         'String', message_str);

y_pos = y_pos - text_height;

uicontrol('Style', 'Text', 'Units', 'Pixels',...
        'Position', [inset, y_pos, window_width-30, text_height], 'FontSize', font_size, 'HorizontalAlignment', 'Left',...
        'fontweight', 'bold', 'String', 'Record type to be plotted:');

y_pos = y_pos - text_height - 5;
    
% Create record checkboxes
% for ind = 1:half_record_count
%     record_type_check_boxes(ind) = uicontrol('Style', 'Checkbox', 'Units', 'Pixels',...
%         'Position', [inset, y_pos - 25*(ind-1), checkbox_width, 18],...
%         'FontSize', font_size, 'String', [char(record_type_names(ind)) ' (' char(record_units(ind)) ')']);
% end
% for ind = half_record_count+1:size(record_types, 1)
%     record_type_check_boxes(ind) = uicontrol('Style', 'Checkbox', 'Units', 'Pixels',...
%         'Position', [(inset*3)+checkbox_width, y_pos - 25*(ind-half_record_count-1), checkbox_width, 18],...
%         'FontSize', font_size, 'String', [char(record_type_names(ind)) ' (' char(record_units(ind)) ')']);
% end

record_strs = cellfun(@concat_record_type_strs, record_type_names, record_units, 'UniformOutput', false);

record_type_selector = uicontrol('Style', 'PopupMenu', 'Units', 'Pixels',...
        'Position', [inset, y_pos, checkbox_width, 18],...
        'FontSize', font_size, 'String', record_strs);

y_pos = y_pos - 55;

button_height = 26;
uicontrol('Style', 'PushButton', 'Units', 'Pixels', 'Position', [(window_width-100)/2, y_pos, 100, button_height],...
        'FontSize', font_size, 'String', 'Proceed', 'Callback', @handle_proceed_button);
    
    function str = concat_record_type_strs(type, unit)
        str = [char(type) ' (' char(unit) ')'];
    end

    
    function handle_proceed_button(~, ~)
        
        % Pass user input to main script
%         selected_record_types = false(size(record_types, 1), 1);
%         for record_type_ind = 1:size(record_types, 1)
%           if record_type_check_boxes(record_type_ind).Value
%             selected_record_types(record_type_ind) = true;
%           end
%         end
%         assignin('base', 'selected_record_types', selected_record_types);
        assignin('base', 'selected_record_types', record_type_selector.Value);

        % Close user input window and resume main script
        close gcf;
    end

end