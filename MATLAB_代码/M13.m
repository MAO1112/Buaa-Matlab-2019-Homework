% �༶��16171046��������л˼��
syms t;
v = diff(6*t - 4.9*t^2);
v_0 = subs(v, 0);
disp("v(0) =");
disp(eval(v_0));