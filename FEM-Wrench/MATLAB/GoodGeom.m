close all;
elem = [148 1598 3940 6144 11446 22954];                %Le premier c'est un coarse, puis un very fine, puis coarse avec une face locale de 0.0005, puis pareil avec local de 0.0004, 0.0003, 0.0002

Node1Sigmax = [-13243089.199 -51900000 -45700000 -56700000 -56771820 -42580658];
Node2Sigmax = [63440969.038 112000000 121000000 129000000 129269266 177561559];
Node3Sigmax = [1423079.098 145000000 199000000 205043059 205043059 219296863];
Node4Sigmax = [1423079.098 -144000000 -200000000 -206281137 -206281137 -221689646];

Node1Sigmay = [29875284.997 97200000 113000000 124232291 124232291 209149311];
Node2Sigmay = [-16135723.823 -79600000 -97500000 -123782129 -123782129 -196398387];
Node3Sigmay = [17489254.344 2860000 2776596 1600633 1600633 9669666];
Node4Sigmay = [17489254.334 -2690000 -3148692 -2448995 -2448995 -1280460];

Node1Sigmaxy = [-28780485.974 -71600000 -84508286 -88934261 -88934261 -148962412];
Node2Sigmaxy = [-2698637.368 1400000 -3378266 -5612422 -5612422 -3659324];
Node3Sigmaxy = [-7363437.962 6430000 12177218 10988938 10988938 7281475];
Node4Sigmaxy = [-73633437.962 8070000 13879123 11280703 11280703 10475464];

Node1Epsx = [-0.000115 -0.000422 -0.000415 -0.000488 -0.000488 -0.000543];
Node2Epsx = [0.000359 0.000712 0.000789 0.000869 0.000869 0.001234];
Node3Epsx = [-0.000019 0.00076 0.001043 0.001077 0.001077 0.001153];
Node4Epsx = [-0.000019 -0.000757 -0.001048 -0.001082 -0.001082 -0.001165];

Node1Epsy = [0.000177 0.000591 0.00067 0.000741 0.000741 0.001166];
Node2Epsy = [-0.000182 -0.00059 -0.000699 -0.000849 -0.000849 -0.001305];
Node3Epsy = [0.000090 -0.000207 -0.000289 -0.000305 -0.000305 -0.000330];
Node4Epsy = [0.000090 0.000206 0.000289 0.000302 0.000302 0.000332];

Node1Epsz = [-0.000025 -0.000069 -0.000104 -0.000103 -0.000103 -0.000254];
Node2Epsz = [-0.000072 -0.00005 -0.000037 -0.000008 -0.000008 0.000029];
Node3Epsz = [-0.000029 -0.000226 -0.000308 -0.000315 -0.000315 -0.000336];
Node4Epsz = [-0.000029 0.000225 0.000310 0.000319 0.000319 0.000340];

Node1Epsxy = [-0.000195 -0.000487 -0.000574 -0.000604 -0.000604 -0.001011];
Node2Epsxy = [-0.000018 0.00001 -0.000023 -0.000038 -0.000038 -0.000025];
Node3Epsxy = [-0.00005 0.000044 0.000083 0.000075 0.000075 0.000049];
Node4Epsxy = [-0.00005 0.000055 0.000094 0.000077 0.000077 0.000071];

vonMise1 = sqrt(Node1Sigmax.^2+Node1Sigmay.^2 - (Node1Sigmax.*Node1Sigmay)+3*(Node1Sigmaxy.^2));
vonMise2 = sqrt(Node2Sigmax.^2+Node2Sigmay.^2 - (Node2Sigmax.*Node2Sigmay)+3*(Node2Sigmaxy.^2));
vonMise3 = sqrt(Node3Sigmax.^2+Node3Sigmay.^2 - (Node3Sigmax.*Node3Sigmay)+3*(Node3Sigmaxy.^2));
vonMise4 = sqrt(Node4Sigmax.^2+Node4Sigmay.^2 - (Node4Sigmax.*Node4Sigmay)+3*(Node4Sigmaxy.^2));


figure
subplot(2,3,1);
plot(elem,Node1Sigmax,'b');
hold
plot(elem,Node1Sigmay,'r');
plot(elem,Node1Sigmaxy,'g');
yyaxis right;
plot(elem,Node1Epsx, 'm');
plot(elem,Node1Epsy, 'g');
plot(elem,Node1Epsz, 'b');
plot(elem,Node1Epsxy, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("First node");

subplot(2,3,2);
plot(elem,Node2Sigmax,'b');
hold
plot(elem,Node2Sigmay,'r');
plot(elem,Node2Sigmaxy,'g');
yyaxis right;
plot(elem,Node2Epsx, 'm');
plot(elem,Node2Epsy, 'g');
plot(elem,Node2Epsz, 'b');
plot(elem,Node2Epsxy, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("Second node");

subplot(2,3,3);
plot(elem,Node3Sigmax,'b');
hold
plot(elem,Node3Sigmay,'r');
plot(elem,Node3Sigmaxy,'g');
yyaxis right;
plot(elem,Node3Epsx, 'm');
plot(elem,Node3Epsy, 'g');
plot(elem,Node3Epsz, 'b');
plot(elem,Node3Epsxy, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("Third node");

subplot(2,3,4);
plot(elem,Node4Sigmax,'b');
hold
plot(elem,Node4Sigmay,'r');
plot(elem,Node4Sigmaxy,'g');
yyaxis right;
plot(elem,Node4Epsx, 'm');
plot(elem,Node4Epsy, 'g');
plot(elem,Node4Epsz, 'b');
plot(elem,Node4Epsxy, 'c');
legend('sigmax','sigmay','sigmaxy', 'Epsx','Epsy','Epsz','Epsxy');
title("Fourth node");

subplot(2,3,[5,6]);
plot(elem,vonMise1,'b');
hold
plot(elem,vonMise2,'m');
plot(elem,vonMise3,'g');
plot(elem,vonMise4,'k');
legend('First','Second','Third','Fourth');
title("Von Mise Stresses")



