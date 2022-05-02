elem = [70 122 300 3945 6131 12230 360704];
elem = log10(elem);
sigmax = [69731087.336 84235026.534 163584337.2 266120276.163 277738492.945 303716728.481 446050711.557];
sigmay = [3130921.426 13834177.293 19646424.92 39601685.787 42117582.592 44488309.722 72214303.889];
sigmaxy = [17388244.476 36221291.960 37856655.767 66516274.168 72105299.421 81056114.838 119842532.043];
vonMise = sqrt(sigmax.^2+sigmay.^2 - (sigmax.*sigmay)+3*(sigmaxy.^2));

figure
plot(elem,sigmax,'b');
hold
plot(elem,sigmay,'r');
plot(elem,sigmaxy,'g');
plot(elem,vonMise,'k');
legend('sigmax','sigmay','sigmaxy','Von Mises');
title("Divergence of the stresses in a sharp edge");
xlabel("Number of elements in logarithmic scale");
ylabel("Stresses (Pa)");