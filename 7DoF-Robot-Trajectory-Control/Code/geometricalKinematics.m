clc;
clear all;
syms theta1 theta2 theta3 theta4 theta5 theta6 theta7;
theta = [theta1 theta2 0 theta4 -pi/2 pi/2 theta7 0];
%theta = [1.7129795181464604, 0.7690297165400057, 0, -0.0884798465072203, -1.5707963267948966, 1.5707963267948966, 1.6429077264446743];
%theta(1) = 0;
a = [0 0 0.0825 -0.0825 0 0 0.088 0];                  %Distance between the z axes along xi           
alpha = [-pi/2 pi/2 pi/2 -pi/2 0 pi/2 pi/2 0];         %Angle between the z axes from zi-1 to zi along xi
d = [0.333 0 0.316 0 0.3840 0 0 0.1070];               %Distance between the x axes along zi-1   
sinalpha = [];
cosalpha = [];
for i = 1:size(alpha,2)
    sinalpha = [sinalpha, sin(alpha(i))];
    cosalpha = [cosalpha, round(cos(alpha(i)),3)];
end
A = [];
Atot = eye(4);

WantedAngles = @(psi, theta, phi) [cos(theta)*cos(phi)*cos(psi)-sin(phi)*sin(psi) -cos(psi)*sin(phi)-cos(theta)*cos(phi)*sin(psi) cos(phi)*sin(theta);...
    cos(theta)*cos(psi)*sin(phi)+cos(phi)*sin(psi) cos(phi)*cos(psi)-cos(theta)*sin(phi)*sin(psi) sin(theta)*sin(phi);...
    -cos(psi)*sin(theta) sin(theta)*sin(psi) cos(theta)];
WantedPositionAndOrientation = [1 0 0 0.088; 0 1 0 0; 0 0 1 0.8; 0 0 0 1];
WantedPositionAndOrientation(1:3,1:3) = WantedAngles(0,0,0);

%theta1 = round(atan2(WantedPositionAndOrientation(1,4), WantedPositionAndOrientation(2,4)),3);
%theta(1) = theta1;

for i = 1:size(theta, 2)
    Ai = ([cos(theta(i)) -sin(theta(i))*cosalpha(i) sin(theta(i))*sinalpha(i) a(i)*cos(theta(i)); sin(theta(i)) cos(theta(i))*cosalpha(i) ...
        -cos(theta(i))*sinalpha(i) a(i)*sin(theta(i)); 0 sinalpha(i) cosalpha(i) d(i); 0 0 0 1]);
    A = [A, Ai];
    Atot = Atot*Ai;
end

Atot

    x7 = 0.2;
    y7 = 0;
    z7 = 0.9;
    theta1 = atan(y7/x7);
    z6 = z7+0.107;
    x6 = x7-0.088*cos(theta1);
    y6 = y7-0.088*sin(theta1);
    R = sqrt(x6^2+y6^2);
    S = z6;
    d1 = 0.333;
    d3 = 0.316;
    d5 = 0.384;
    a3 = 0.0825;
    l2 = sqrt(d3^2+a3^2);
    l4 = sqrt(d5^2+a3^2);
    alpha = atan(d3/a3);
    gamma = atan(a3/d5);
    D = (R^2+(S-d1)^2-l2^2-l4^2)/(2*l2*l4);
    xi = atan2(sqrt(1-D^2),D);
    beta = atan(d5/a3)-xi;
    khi = atan((S-d1)/R) + atan((l4*sin(xi))/(l2+l4*cos(xi)))
    E = (R-l2*cos(khi))/l4;
    beta2 = atan2(E,sqrt(1-E^2));
    theta7 = pi/2-beta2-gamma
    theta2 = khi + atan(a3/d3)-pi/2
    theta4 = pi-alpha-beta
    
    eval(Atot)
    
    %s1 = (x7*0.107+sqrt((x7*0.107)^2-(x7^2+y7^2)*(0.107^2-y7^2)))/(x7^2+y7^2);
    theta1 = atan(y7/x7) + asin(d(8)/(sqrt(x7^2+y7^2)));
    %theta1 = atan2(sqrt(1-s1^2), s1);
    x6 = x7-0.107*sin(theta1);
    y6 = y7+0.107*cos(theta1);
    r = z7-d(1);
    s = sqrt(x6^2+y6^2);
    lalpha = sqrt(d(3)^2+a(3)^2);
    lbeta = sqrt((d(5)+a(7))^2+a(3)^2);
    D = (r^2+s^2-lalpha^2-lbeta^2)/(2*lalpha*lbeta);
    beta = atan2(D, sqrt(1-D^2));
    %beta = atan2(sqrt(1-D^2),D);
    theta4 = -beta-atan2(d(5)+a(7), a(3));
    %theta4 = -beta-atan2(a(3),d(5)+a(7));
    alpha = atan2(r,s)-atan2(lalpha+lbeta*cos(beta),lbeta*sin(beta));
    %alpha = atan2(s,r)-atan2(lbeta*sin(beta),lalpha+lbeta*cos(beta));
    theta2 = alpha-atan2(d(3),a(3));
    %theta2 = alpha-atan2(a(3),d(3));
    theta7 = theta2-theta4-pi;
    
