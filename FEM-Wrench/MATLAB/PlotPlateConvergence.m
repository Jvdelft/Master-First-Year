figure
semilogx([80 210 417 27456 104483 147000],[93.831 270 268.689 265.1259 257.9229 261.9423], 'b');
hold
semilogx([80 210 417 27456 104483 147000], [264 264 264 264 264 264], 'm');
legend("Experimental values", "Theoretical values");
title("Convergence study for the quarter plate value at theta = 90° on the hole")
xlabel("Number of finite elements")
ylabel("Value of sigma x")
%set(gca, 'color', 'y');