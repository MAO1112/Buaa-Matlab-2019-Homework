% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms t;
global X H;
g = 9.81;
X = @(v, A) v*t*cosd(A);
H = @(v, A) v*t*sind(A) - 1/2*g*t^2;
% a)
h = H(10, 35);
x = X(10, 35);
t_int = solve(h==0);
t_min = t_int(1);
t_max = t_int(2);
x_max = subs(x, t_max);
h_max = max(subs(h, linspace(t_min, t_max, 100)));
disp("h_max =");
disp(eval(h_max));
disp("x_max =");
disp(eval(x_max));
disp("t_max =");
disp(eval(t_max));

% b)
figure(1);
[x_d, h_d] = parabola(10, 35);
plot(x_d, h_d);
title("M8-1");
legend("v=10m/s A=35¡ã", "Location", "South");
grid on;

% c)
A_list = [20, 30, 45, 60, 70];
figure(2);
hold on;
for A = A_list
    [x_d, h_d] = parabola(10, A);
    plot(x_d, h_d);
end
title("M8-2");
legend("v=10m/s A=20¡ã","v=10m/s A=30¡ã","v=10m/s A=45¡ã","v=10m/s A=60¡ã","v=10m/s A=70¡ã");
grid on;

% d)
v_list = [10, 12, 14, 16, 18];
figure(3);
hold on;
for v = v_list
    [x_d, h_d] = parabola(v, 45);
    plot(x_d, h_d);
end
title("M8-3");
legend("v=10m/s A=45¡ã","v=12m/s A=45¡ã","v=14m/s A=45¡ã","v=16m/s A=45¡ã","v=18m/s A=45¡ã");
grid on;

function [x_d, h_d] = parabola(v, A)
    global X H;
    x = X(v, A);
    h = H(v, A);
    t_int = solve(h==0);
    d = linspace(t_int(1), t_int(2), 100);
    x_d = eval(subs(x, d));
    h_d = eval(subs(h, d));
end