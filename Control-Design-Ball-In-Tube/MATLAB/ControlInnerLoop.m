close all;
clear all;

Ts = 0.01; % Sampling time

Fan = tf(10, [2.497 1]); %Transfer function of the fan system

% The zero order holder must be taken into account. It introduces a delay
% of half a sampling period. We add a delay of twice this value to our
% model.

Fan_Delay = Fan;
Fan_Delay.outputd = Ts;   %Delayed transfer function

Kp_in = 2.775;      %Max Kp without saturation after the equilibrium point

Pade = tf(1, [(Ts/2) 1]);
Fan_Delay_Pade = series(Pade, Fan); %Delayed transfer function using Pade' approximants
figure

rlocus(Pade*Fan);
%Reasonable minimum gain and phase margins are 6dB and 30°



ZOH = tf(1, [1 0]) - tf(1, [1 0], 'InputDelay', Ts);    %Real ZOH transfer function
figure
margin(series(ZOH, Fan));           %Check the gain and phase margin
OpenLoop = series(ZOH,Fan_Delay);
Control = series(Kp_in,OpenLoop);