


%  %2x^2 + y + 3z = 16
%  %x + y^2 + 4z = 20
%  %x + y = 10
%  syms x
 x_equation = [2^2, 1, 3];
 y_equation = [1, 1^2, 4];
 z_equation = [1, 1, 0];
 
 results = [16;20;10];
 
 coef = mldivide([x_equation;y_equation;z_equation], results);
 disp(coef)
 disp([x_equation;y_equation;z_equation] \ results)
 

ecuation  = @(x) x^2;

[area] = get_area_below_curve(ecuation, @get_trap_with_rect_and_triangle,...
                              4, 0, 50);
 disp(area)

function [area] = get_trap_area_with_formula(ecuation, left_point, right_point, height)
    left_base = ecuation(left_point);
    right_base = ecuation(right_point);
    area = ((left_base + right_base) * height) / 2;
end

function [area] = get_area_below_curve(ecuation,... 
                                       strategy_small_area_fun,... 
                                       steps, start_point, end_point)
    area_acum = 0;
    points_in_x = [start_point : steps : end_point];
    if points_in_x(end) ~= end_point
        points_in_x(length(points_in_x) + 1) = end_point
    end
    for i = 2 : length(points_in_x)
       area_acum = area_acum + ...
                   strategy_small_area_fun(ecuation, points_in_x(i - 1),...
                                           points_in_x(i), points_in_x(i) - points_in_x(i - 1) );
    end
    area = area_acum;
end

function [area] = get_trap_with_rect_base_left(ecuation,...
    left_point,...
    right_point, height)
area = height * ecuation(left_point)
end

function [area] = get_trap_with_rect_base_right(ecuation,...
     left_point,...
     right_point, height)
area = height * ecuation(right_point)
end

function [area] = get_trap_with_rect_and_triangle(ecuation,...
     left_point,...
     right_point, height)
    small_point = 0
    trinagle_small_height = 0

    if left_point < right_point
        small_point = left_point
        trinagle_small_height = right_point - left_point
    else 
        small_point = right_point
        trinagle_small_height = left_point - right_point
    end

    rect_area = height * ecuation(small_point)
    triangle_area = (height * trinagle_small_height ) / 2
    area = rect_area + triangle_area
end









