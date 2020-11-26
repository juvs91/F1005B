%punto inicial (10,290)
%punto2 (22, 270)
%punto3 (38, -5)
%punto final (50,20)
 
Px1 = 10;
Px2 = 22;
Px3 = 38;
Px4 = 50;
 
Py1 = 290;
Py2 = 270;
Py3 = -5;
Py4 = 20; 
VectorX = [Px1:Px4];
X = [Px1^3 Px1^2 Px1 1; Px2^3 Px2^2 Px2 1; Px3^3 Px3^2 Px3 1;...
    Px4^3 Px4^2 Px4 1];
Y = [Py1;Py2;Py3;Py4];
 
%Coeficientes
coeficientes = X\Y;
disp(coeficientes);
 
%Funcion de y o polinomio              
 
polinomio = @(x) x.^3*coeficientes(1) + x.^2*coeficientes(2)...
            + x*coeficientes(3)+coeficientes(4);
 
figure()
plot(VectorX,polinomio(VectorX));
hold on
plot([Px1 Px4],[Py1 Py4],'r*');





 
%Derivadas
Prim_derivada = @(x) 3*x.^2*coeficientes(1) + 2*x*coeficientes(2) + coeficientes(3);
Segun_derivada = @(x) 6*x*coeficientes(1) + 2*coeficientes(2);
longitud_curva = get_curve_area(Prim_derivada,Px1,Px4,VectorX);
disp(longitud_curva);
% max return the max value of an array or vecctor or list
y_venctor = polinomio(VectorX);
[ymax, indmax] = max(y_venctor);
x_point_y_max_value = VectorX(indmax);
[ymin, indmin] = min(y_venctor);
x_point_y_min_value = VectorX(indmin);
radio_min = get_Radio(Prim_derivada, Segun_derivada, x_point_y_min_value);
disp(radio_min);
radio_max = get_Radio(Prim_derivada, Segun_derivada, x_point_y_max_value);
disp(radio_max);
circle(x_point_y_max_value, ymax-radio_max, radio_max);
circle(x_point_y_min_value, ymin+radio_min, radio_min);
if x_point_y_min_value >= x_point_y_max_value
    valor_max = x_point_y_min_value
    valor_min = x_point_y_max_value
else
    valor_max = x_point_y_max_value
    valor_min = x_point_y_min_value
end


points = [Px1 : 0.01 : 30]
[zona_riesgo_primera]= obtain_critic_points(Prim_derivada, Segun_derivada, points);
min_first = min(zona_riesgo_primera);
max_first = max(zona_riesgo_primera);
points = [30 : 0.01 : Px4]
[zona_riesgo_segunda] = obtain_critic_points(Prim_derivada,Segun_derivada, points);
min_second = min(zona_riesgo_segunda);
max_second = max(zona_riesgo_segunda);
figure()
plot(VectorX,polinomio(VectorX));
hold on
plot(zona_riesgo_primera,polinomio(zona_riesgo_primera),'-ko');
plot(zona_riesgo_segunda,polinomio(zona_riesgo_segunda),'-ko');
plot([min_first min_second],[polinomio(min_first) polinomio(min_second)],'r*');
plot([max_first max_second],[polinomio(max_first) polinomio(max_second)],'r*');

for i=min_first:0.01:valor_min
    get_tan(i,polinomio,Prim_derivada,zona_riesgo_primera);
end

for i=min_second:0.01:valor_max
    get_tan(i,polinomio,Prim_derivada,zona_riesgo_segunda);
end

get_perp(zona_riesgo_primera(1),polinomio,Prim_derivada,zona_riesgo_primera);
 
function [tangente] = get_tan(punto_x,polinomio,Prim_derivada,zona_riesgo_primera)
    Tang = @(x) Prim_derivada(punto_x) * (x - punto_x) + polinomio(punto_x);
    y = Tang(zona_riesgo_primera);
    hold on
    plot(zona_riesgo_primera,y);
end
 
function [perpendicular] = get_perp(punto_x,polinomio,Prim_derivada,zona_riesgo_primera)
    Perp = @(x) polinomio(punto_x)+(-1./Prim_derivada(punto_x))*(x-punto_x);
    a = Perp(zona_riesgo_primera);
    hold on
    plot(zona_riesgo_primera,a);
end
 
%Funcion Longitud de la curva
function curve_longitude = get_curve_area(Prim_derivada, Px1,Px4,VectorX)
    curve_fun = @(x) sqrt (1+(Prim_derivada(x).^2));
    curve_longitude = integral(curve_fun,Px1,Px4);
end
  
function radio = get_Radio(Prim_derivada,Segun_derivada,i)
    funcion_radio = @(x) ((1+ (Prim_derivada(x))^2)^(3/2) )./ abs( Segun_derivada(x) );
    radio = funcion_radio(i);
end
 
function circle(x,y,r)
    ang=0:0.01:2*pi; 
    xpos=r*cos(ang);
    ypos=r*sin(ang);
    plot(x+xpos,y+ypos);
end
 
function [zona_riesgo] = obtain_critic_points(Prim_derivada, Segun_derivada, points)
    c_points = [];
    index = 1
    for i = 1 : length(points)
        if get_Radio(Prim_derivada, Segun_derivada, points(i)) < 50
            c_points(index) = points(i);
            index = index + 1;
        end
    end
    zona_riesgo = c_points;
    disp(zona_riesgo);
    
end
 