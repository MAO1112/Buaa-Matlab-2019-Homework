% �༶��16171046��������л˼��
syms k;
A = [-6, 2; 3*k, -7];
f = poly2sym(charpoly(A));
x = eig(A);
disp("f(x) =");
disp(f);
disp("x =");
disp(x);