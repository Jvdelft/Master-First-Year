u=out.simout.Data(:,1).';
y=out.simout.Data(:,2).';
time=out.simout.Time.';
offset_u=1.2; %Operating point
offset_y=1.2; %Operating point
Ts=0.01;
%u = u(200:end);
%y = y(200:end);
%f= @(t,u) u.*t; 
%time = time(1:(end-199));
SystemOrder=[0 1]; %Number of zeros and of poles (0 and 1), respectively.
sysIdent=IdentifySystem(u-offset_u,y-offset_y,SystemOrder,Ts)
%sysIdent=IdentifySystem(f(time,u)-offset_u,y-offset_y,SystemOrder,Ts)
plot(time,y-offset_y,'.');
hold on;
lsim(sysIdent,u-offset_u,time);