% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms x y c;
M = [
    (4*c*x + 5*y == 43),
    (3*x - 4*y == -22),
];
[A b] = equationsToMatrix(M, [x y]);
S = [inv(A)*b A\b].';
disp("x, y =");
disp(S);