%method_function = @get_area_with_simposn_1_3;
%get the equation from the string and convert it to an anonymus function
%using str2sym to string to sym function and matlabFunction from
%symfunction to anonymus function
% equation_string = input("pls enter the equation: ", "s");
% equation = matlabFunction(str2sym(equation_string));
% method_to_use = input("pls enter the integration method available [get_area_with_simposn_1_3, get_area_with_simposn_3_8, get_trap_area_with_formula] : ", "s")
% %create a map to put all the functions and get the one to use with the
% %method_to_uses string, map is {string => function}
%  map = containers.Map();
%  map("get_area_with_simposn_1_3") = @get_area_with_simposn_1_3;
%  map("get_area_with_simposn_3_8") = @get_area_with_simposn_3_8;
%  map("get_trap_area_with_formula") = @get_trap_area_with_formula;
%  method_function = map(method_to_use);
 equation  = @(x) x^2;
 method_function = @get_trap_area_with_formula
 [area, x_points, y_points] = get_area_with_romberg(equation, method_function,...
                                                    4, 0, 10);
 disp(area)
 plot(x_points, y_points)


function [area, all_x_points, all_y_points] = get_area_below_curve(equation,... 
                                                                   strategy_small_area_fun,... 
                                                                   steps, start_point, end_point)
    area_acum = 0;
    points_x = [];
    points_y = [];
    points_in_x = [start_point : steps : end_point];
    if points_in_x(end) ~= end_point
        points_in_x(length(points_in_x) + 1) = end_point;
    end
    for i = 2 : length(points_in_x)
       [area, small_area_x_points, small_area_y_points] = strategy_small_area_fun(equation,... 
                                                                                  points_in_x(i - 1),...
                                                                                  points_in_x(i),...
                                                                                  points_in_x(i) - points_in_x(i - 1));
       area_acum = area_acum + area;
       points_x = [points_x, small_area_x_points];
       points_y = [points_y, small_area_y_points];
    end
    area = area_acum;
    all_x_points = points_x;
    all_y_points = points_y;
end

function [area, x_points, y_points] = get_area_with_romberg(equation,... 
                                                            strategy_small_area_fun,... 
                                                            steps, start_point, end_point...
                                                            )
    areas = zeros(steps, steps);
    division_of_steps = 1;
    for i = 1: steps
        romberg_steps = (end_point - start_point) / division_of_steps;
        % x_points_ and y_points_ are unused, therefor the have _ as
        % preffix
        [area, x_points_, y_points_] = get_area_below_curve(equation,... 
                                                            strategy_small_area_fun,...
                                                            romberg_steps, start_point, end_point)
        areas(1, i) = area;
        division_of_steps = division_of_steps * 2;
    end
    [row, col] = size(areas)
    for k = 2 : row
        for j = 1 : col - 1
            areas(k, j) = ((4^(k-1) * areas(k-1, j+1)) - areas(k-1,j)) / (4^(k-1) -1);
        end
        col = col - 1
    end
    [row, col] = size(areas)
    % in the last row in the first pos it's the last romberg aprox
    area = areas(row, 1)
    disp(area)
    % maybe gather the last of the steps iteration
    x_points = [];
    y_points = [];
    
end


function [area, x_points, y_points] = get_area_with_simposn_1_3(equation,left_point,...
                                                                right_point, height)
   simpson_1_3_height = (right_point - left_point) /2;
   x_points = [left_point, ... % punto a
               left_point + simpson_1_3_height,... % middle point
               right_point];  % left_point + 2 * simpson_1_3_height
   y_points = [equation(left_point), equation(left_point + simpson_1_3_height), equation(right_point)];
   area = (simpson_1_3_height / 3 ) * (y_points(1) + 4 * y_points(2) + y_points(3));
     
   equations = [x_points(1)^2, x_points(1), 1;...
                x_points(2)^2, x_points(2), 1;...
                x_points(3)^2, x_points(3), 1];
            
    results  = [y_points(1);...
                y_points(2);...
                y_points(3)];
            
    coef = equations \ results;
    % ax^2 + bx + c
    parabola_function = @(x) coef(1)*x^2 + coef(2)*x + coef(3);
    y_parabola_points = [parabola_function(left_point),... 
                         parabola_function(left_point + simpson_1_3_height),...
                         parabola_function(right_point)];
    y_points = y_parabola_points;

end

function [area, x_points, y_points] = get_area_with_simposn_3_8(equation,left_point,...
                                                                right_point, height)
   
                                        
   simpson_1_8_height = (right_point - left_point)/3;
   
   x_points = [left_point,... 
              left_point + simpson_1_8_height,...
              right_point - simpson_1_8_height,... 
              right_point];
   y_points = [equation(left_point), equation(left_point + simpson_1_8_height),...
               equation(right_point - simpson_1_8_height), equation(right_point)];
           
   area = (3 * simpson_1_8_height / 8) * (y_points(1) + ...
                                          3 * y_points(2) +...
                                          3 * y_points(3) +...
                                          y_points(4));
                                
   equations = [x_points(1)^3, x_points(1)^2, x_points(1), 1;...
                x_points(2)^3, x_points(2)^2, x_points(2), 1;...
                x_points(3)^3, x_points(3)^2, x_points(3), 1;...
                x_points(4)^3, x_points(4)^2, x_points(4), 1];
            
   results = [y_points(1);...
              y_points(2);...
              y_points(3);...
              y_points(4)];
           
    coef = equations \ results;
    parabola_function = @(x) coef(1)*x^3  + coef(2)*x^2 + coef(3)*x + coef(4);
    y_parabola_points = [parabola_function(left_point),...
                         parabola_function(left_point + simpson_1_8_height),...
                         parabola_function(right_point - simpson_1_8_height),...
                         parabola_function(right_point)];
    
    y_points = y_parabola_points;                      
end

function [area, x_points, y_points] = get_trap_area_with_formula(equation, left_point,...
                                                                 right_point, height)
    left_base = equation(left_point);
    right_base = equation(right_point);
    area = ((left_base + right_base) * height) / 2;
    x_points = [left_point, right_point]
    y_points = [left_base, right_base]
end

function [area, x_points, y_points] = get_trap_with_rect_and_triangle(equation,left_point,...
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

    rect_area = height * equation(small_point)
    triangle_area = (height * trinagle_small_height ) / 2
    area = rect_area + triangle_area
    x_points = []
    y_points = []
end

function [area, x_points, y_points] = get_trap_with_rect_base_left(equation,left_point,...
                                                                   right_point, height)
    area = height * equation(left_point)
    x_points = []
    y_points = []
end

function [area, x_points, y_points] = get_trap_with_rect_base_right(equation, left_point,...
                                                                    right_point, height)
    area = height * equation(right_point)
    x_points = []
    y_points = []
end





