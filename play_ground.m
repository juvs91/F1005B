
% en funciones anonimas el return value es implicito
my_sub = @(a,b) a-b;

% function [sub] = my_sub(a,b)
%     sub = a - b
% end

% my_div = @(a,b) a/b;
% my_div(1,2)
% 
% 
% 
[r, r2] = executor(@my_sum_fun, 10, 5);

disp(r)

disp(r2)

exp = @(x) x^2

y = @(z) z^2 + z*2

function [result, r2] = executor(operator_fun, operand_one, operand_two)
%     disp(operator_fun);
    result = operator_fun(operand_one, operand_two);
    r2 = 10;
end

% key word function seguido es un lista de valores de salida seguido del nombre
function [my_sum] = my_sum_fun(a,b)
%     disp("hola")
    my_sum = a + b;
end
function [mult] = my_mult(a,b)
    mult = a - b;
end






