% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
p_1 = [6 2 7 -3];
p_2 = [10 -8 5];
p = conv(p_1, p_2);
disp("p(x) = ");
disp(poly2sym(p));
disp("p(x=2) = ");
disp(polyval(p, 2));