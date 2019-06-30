% °à¼¶£º16171046£¬ÐÕÃû£ºÐ»Ë¼º­
x = [-3, 0, 0, 2, 5, 8];
y = [-5, -2, 0, 3, 4, 10];
z_a = (y < ~x);
z_b = (x & y);
z_c = (x | y);
z_d = xor(x, y);
disp("a) z = ");
disp(z_a);
disp("b) z = ");
disp(z_b);
disp("c) z = ");
disp(z_c);
disp("d) z = ");
disp(z_d);