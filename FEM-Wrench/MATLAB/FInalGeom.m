close all;

elem = [714, 1585, 3859, 14968, 90775];
elem = log10(elem);

SigmaxElem1 = [-207056967.209, -230578840.619, -249081596, -278148739, -58849996];
SigmaxElem2 = [13443962.410, 154325351.481, 177789544, 215830040, 136483951];
SigmaxElem3 = [195239119.032, 221425021.116, 238130473, 240883360, 237829839];
SigmaxElem4 = [-197227663.465, -221175388.435, -239396438, -241576804, -234046303];

SigmayElem1 = [5702853.392, 21941710.610, 27267678, 75136994, 409279038];
SigmayElem2 = [-2074195.198, -8612027.977, -12176275, -31406074, -361023606];
SigmayElem3 = [12520183.028, 11712835.338, 8775932, 5658499, 2178210];
SigmayElem4 = [-16276068.662, -13701010.872, -8699171, -6720999, -1848750];

SigmaxyElem1 = [1843025.458, -1041891.787, -4353632, -16755059, -208961247];
SigmaxyElem2 = [35380557.334, 43341734.433, 53487975, 84442228, 17739934];
SigmaxyElem3 = [21976796.193, 21639796.739, 22452353, 18617225, 9476888];
SigmaxyElem4 = [16477529.686, 16246294.596, 21634637, 24591919, 5110254];

EpsxElem1 = [-0.001098, -0.001247, -0.001353, -0.001579, -0.000934];
EpsxElem2 = [0.000711, 0.000825, 0.000954, 0.001184, 0.001269];
EpsxElem3 = [0.001008, 0.001148, 0.001240, 0.001259, 0.001248];
EpsxElem4 = [-0.001013, -0.001143, -0.001247, -0.001261, -0.001229];

EpsyElem1 = [0.000346, 0.000467, 0.000524, 0.000820, 0.002244];
EpsyElem2 = [-0.000216, -0.000281, -0.000335, -0.000495, -0.002108];
EpsyElem3 = [-0.000232, -0.000276, -0.000317, -0.000338, -0.000352];
EpsyElem4 = [0.000215, 0.000265, 0.000320, 0.000333, 0.000347];

EpszElem1 = [0.000307, 0.000318, 0.000339, 0.000310, -0.000535];
EpszElem2 = [-0.000202, -0.000222, -0.000253, -0.000281, 0.000343];
EpszElem3 = [-0.000317, -0.000356, -0.000377, -0.000376, -0.000366];
EpszElem4 = [0.000326, 0.000358, 0.000379, 0.000379, 0.00036];

EpsxyElem1 = [0.000013, -0.0000007, -0.000030, -0.000114, -0.001419];
EpsxyElem2 = [0.000240, 0.000294, 0.000363, 0.000573, 0.000120];
EpsxyElem3 = [0.000149, 0.000147, 0.000152, 0.000126, 0.000064];
EpsxyElem4 = [0.000112, 0.000110, 0.000147, 0.000167, 0.000035];

vonMise1 = sqrt(SigmaxElem1.^2+SigmayElem1.^2 - (SigmaxElem1.*SigmayElem1)+3*(SigmaxyElem1.^2));
vonMise2 = sqrt(SigmaxElem2.^2+SigmayElem2.^2 - (SigmaxElem2.*SigmayElem2)+3*(SigmaxyElem2.^2));
vonMise3 = sqrt(SigmaxElem3.^2+SigmayElem3.^2 - (SigmaxElem3.*SigmayElem3)+3*(SigmaxyElem3.^2));
vonMise4 = sqrt(SigmaxElem4.^2+SigmayElem4.^2 - (SigmaxElem4.*SigmayElem4)+3*(SigmaxyElem4.^2));


figure
subplot(2,3,1);
plot(elem,SigmaxElem1,'b');
hold
plot(elem,SigmayElem1,'r');
plot(elem,SigmaxyElem1,'g');
ylabel("Stresses (Pa)");
yyaxis right;
plot(elem,EpsxElem1, 'm');
plot(elem,EpsyElem1, 'g');
plot(elem,EpszElem1, 'b');
plot(elem,EpsxyElem1, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("First element");
ylabel("Strains");
xlabel("Number of elements in logarithmic scale");

subplot(2,3,2);
plot(elem,SigmaxElem2,'b');
hold
plot(elem,SigmayElem2,'r');
plot(elem,SigmaxyElem2,'g');
ylabel("Stresses (Pa)");
yyaxis right;
plot(elem,EpsxElem2, 'm');
plot(elem,EpsyElem2, 'g');
plot(elem,EpszElem2, 'b');
plot(elem,EpsxyElem2, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("Second element");
ylabel("Strains");
xlabel("Number of elements in logarithmic scale");

subplot(2,3,3);
plot(elem,SigmaxElem3,'b');
hold
plot(elem,SigmayElem3,'r');
plot(elem,SigmaxyElem3,'g');
ylabel("Stresses (Pa)");
yyaxis right;
plot(elem,EpsxElem3, 'm');
plot(elem,EpsyElem3, 'g');
plot(elem,EpszElem3, 'b');
plot(elem,EpsxyElem3, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("Third element");
ylabel("Strains");
xlabel("Number of elements in logarithmic scale");

subplot(2,3,4);
plot(elem,SigmaxElem4,'b');
hold
plot(elem,SigmayElem4,'r');
plot(elem,SigmaxyElem4,'g');
ylabel("Stresses (Pa)");
yyaxis right;
plot(elem,EpsxElem4, 'm');
plot(elem,EpsyElem4, 'g');
plot(elem,EpszElem4, 'b');
plot(elem,EpsxyElem4, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("Fourth element");
ylabel("Strains");
xlabel("Number of elements in logarithmic scale");

subplot(2,3,[5,6]);
plot(elem,vonMise1,'b');
hold
plot(elem,vonMise2,'m');
plot(elem,vonMise3,'g');
plot(elem,vonMise4,'k');
legend('First element','Second element','Third element','Fourth element');
title("Von Mises Stresses")
xlabel("Number of elements in logarithmic scale");
ylabel("Stresses (Pa)");


