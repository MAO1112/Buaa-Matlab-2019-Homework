% �༶��16171046��������л˼��
syms x;
N = 14*x^3 - 6*x^2 + 3*x + 9;
D = 5*x^2 + 7*x - 4;
[R, Q] = polynomialReduce(N, D);
disp("Q = ");
disp(Q);
disp("R = ");
disp(R);