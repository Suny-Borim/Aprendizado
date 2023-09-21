create or replace function datediff( p_what in varchar2,
                                        p_d1   in date,
                                         p_d2   in date ) return number
    as
        l_result    number;
    begin
        select (p_d2-p_d1) *
               decode( upper(p_what),
                       'SS', 24*60*60, 'MI', 24*60, 'HH', 24, 'DD', 1 )
        into l_result from dual;
       return l_result;
   end;