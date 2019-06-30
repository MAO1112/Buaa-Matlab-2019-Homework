% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms t;
v = diff(6*t - 4.9*t^2);
v_0 = subs(v, 0);
disp("v(0) =");
disp(eval(v_0));