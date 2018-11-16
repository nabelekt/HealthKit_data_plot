% Modified from https://www.mathworks.com/matlabcentral/answers/395348-how-can-i-change-the-font-size-of-msgbox

function my_msgbox(str, font_size)

    mb = msgbox(str);
    text = findall(mb, 'Type', 'Text');
    text.FontSize = font_size;
    
    deltaWidth = sum(text.Extent([1,3]))-mb.Position(3) + text.Extent(1);
    deltaHeight = sum(text.Extent([2,4]))-mb.Position(4) + 10;
    mb.Position([3,4]) = mb.Position([3,4]) + [deltaWidth, deltaHeight];
    
    mb.Resize = 'on';