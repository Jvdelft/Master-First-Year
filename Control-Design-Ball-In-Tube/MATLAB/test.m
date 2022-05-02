u = [0 20 40 60 80 100 120 140 160 180];
y = [7.2 6.3 4.8 2.6 2.4 2.2 1.8 1.6 1.5 1.2];
Ts=0.01;
SystemOrder=[0 1]; %Number of zeros and of poles (0 and 1), respectively.
sysIdent=IdentifySystem(u,y,SystemOrder,Ts)
