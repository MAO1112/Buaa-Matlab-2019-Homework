% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms x y b;
M = [
    (x^2 + y^2/b^2 == 1),
    (x^2/100 + 4*y^2 == 1),
];
[x y] = solve(M, [x y]);
disp("x,y(b) =");
disp([x y]);
disp("x,y(2) =");
disp(eval(subs([x y], b, 2)));