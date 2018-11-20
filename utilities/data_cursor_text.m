function data_cursor_str = data_cursor_text(~, event)
    
unit = evalin('base', 'unit');
record_type = evalin('base', 'record_type');
coord = get(event, 'Position');
data_cursor_str = {['Date and Time:  ' datestr(coord(1), 'yyyy/mm/dd  HH:MM:SS')],...
                   [record_type ': ' num2str(coord(2)) ' (' unit ')']};

end