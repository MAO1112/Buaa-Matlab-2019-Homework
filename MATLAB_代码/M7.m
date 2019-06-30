% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
syms t;
f = @(x) 4*x.^5 + 3*x.^4 - 95*x.^3 + 5*x.^2 - 10*x + 80;
R = eval(vpasolve(f(t), [-10 10]));
x = -10:0.001:10;
plot(x, f(x), x, 0*x, R, 0*R, "ob");
title("M7-1");
legend("y=4x^5+3x^4-95x^3+5x^2-10x+80", "y=0", "zero-point",'Location','North');
set(gca, "XTick", [-10 R' 10]);
set(gca, "XTickLabel", [-10 R' 10]);
grid on;