% Modified from https://www.mathworks.com/matlabcentral/fileexchange/44526-to-check-date-validity

function res=isValidDate(d)
% d = Enter date in 'DD/MM/YYYY' format
if (length(d)~=10)
    res=false;
    return;
end
yearstr=d(7:10);
year=str2double(yearstr);
if (year<1 || isnan(year)==1)
    res=false;
    return;
end
monthstr=d(4:5);
month=str2double(monthstr);
if (isempty(month)==1 || isnan(month)==1)
   res=false;
   return;
elseif (month<1||month>12)
      res=false;
      return;
end  
if (d(3)~='/'||d(6)~='/')
    res=false;
    return;
end
daystr=d(1:2);
day=str2double(daystr);
if (isempty(day)==1 || isnan(day)==1)
    res=false;
    return;
end
if (month==1||month==3||month==5||month==7||month==8||month==10||month==12)
    if (day<1||day>31)
        res=false;
        return;
    end
end
if (month==4||month==6||month==9||month==11)
    if (day<1||day>30)
        res=false;
        return;
    end
end

if (rem(year,400)==0)
    if (month==2)
        if (day<1||day>29)
            res=false;
            return;
        end
    end
else if (rem(year,100)==0)
        if (month==2)
            if (day<1||day>28)
                res=false;
                return;
            end
        end
else if (rem(year,4)==0)
        if (month==2)
            if (day<1||day>29)
                res=false;
                return;
            end
        end
    else
         if (month==2)
            if (day<1||day>28)
                res=false;
                return;
            end
         end
    end
    end
end
res=true;
