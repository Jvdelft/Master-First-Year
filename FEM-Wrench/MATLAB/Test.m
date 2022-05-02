angle = pi/6;
nodee = [0 0;1 0;0 1];
geome = 1;
matere = [210e9 0.29];
datae1 = 2;
datae2 = 1;
ue = [0;0;1;0;0;0];
be = [];
keystrainstress = 'P';
keystiffness = 'K';
[outstrainstress_plainstrain] = trim3(nodee, geome, matere, datae1, ue, be, keystrainstress);
[outstrainstress_plainstress] = trim3(nodee, geome, matere, datae2, ue, be, keystrainstress);
[outK] = trim3(nodee, geome, matere, datae1, ue, be, keystiffness);

strain_plainstrain = outstrainstress_plainstrain(1,1:4)
stress_plainstrain = outstrainstress_plainstrain(2,1:4)

strain_plainstress = outstrainstress_plainstress(1,1:4)
stress_plainstress = outstrainstress_plainstress(2,1:4)


K = outK;
%epsZ = out(9)
%sigZ = out(10)
