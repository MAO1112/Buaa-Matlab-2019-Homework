% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms x y z;
E = [
    (7*x + 9*y - 9*z == 22);
    (3*x + 2*y - 4*z == 12);
    (  x + 5*y -   z == -2);
];
[x, y, z, p, c] = solve(E, 'ReturnConditions', true);
disp("x =");
disp(x)
disp("y =");
disp(y);
disp("z =");
disp(z);