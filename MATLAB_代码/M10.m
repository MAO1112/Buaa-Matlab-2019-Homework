% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms x y z c;
E = [
    (  x - 5*y - 2*z == 11*c);
    (6*x + 3*y +   z == 13*c);
    (7*x + 3*y - 5*z == 10*c);
];
[x y z] = solve(E, [x y z]);
disp("x =");
disp(x);
disp("y =");
disp(y);
disp("z =");
disp(z);
c = -10:0.1:10;
hold on;
grid on;
plot(c, subs(x, c));
plot(c, subs(y, c));
plot(c, subs(z, c));
title("M10-1");
xstr = strcat("x=",string(x));
ystr = strcat("y=",string(y));
zstr = strcat("z=",string(z));
legend(xstr,ystr,zstr,"Location","North");