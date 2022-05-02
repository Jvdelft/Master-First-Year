ControlInnerLoop;
close all;
G = tf(0.37815, [1 0]);     %Second system transfer function
Td = 0.087;                 %Found thanks to rltool
Kp = 0.70753;               %Found thanks to rltool
%Kp = 5.0766;               %Kp for the second linear zone of the sensor          
N = 5;                      %Filtering value
Cd = tf([Td 0], [Td/N 1]);  %Derivative regulation transfer function
C = Kp*(Cd+1);              %Controller transfer function
figure
rlocus(C*G*8.03*feedback(Kp_in*Fan,1));     %rlocus of the full system with regulation
FullSys = G*8.03*feedback(Kp_in*Fan,1);     %Full system in order to find the right controller with rltool
%FullSys = G*1.08*feedback(Kp_in*Fan,1);    %Full system with the sensor gain in the other zone
controlSystemDesigner('rlocus', FullSys);   %rltool
figure
margin(C*G*8.03*feedback(Kp_in*Fan_Delay,1));   %Check the final margin with the controller