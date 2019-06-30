% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms x y z;
M = [
    ( 6*x - 3*y + 4*z ==  41),
    (12*x + 5*y - 7*z == -26),
    (-5*x + 2*y + 6*z ==  14),
];
[A b] = equationsToMatrix(M);
A = rref([A b]);
disp("x = ");
disp(A(1,4));
disp("y = ");
disp(A(2,4));
disp("z = ");
disp(A(3,4));