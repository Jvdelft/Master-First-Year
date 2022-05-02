fileID = fopen('Mesh3.dat');
C = textscan(fileID,'%f %f %f %f %f');
fclose(fileID);

%Nombre element
N=C{1,1}(1);

%Création de "nodes"
node=zeros(N,2);

for i=1:1:N
    node(i,1)=C{1,2}(i+1);
    node(i,2)=C{1,3}(i+1);
end


%Creation de elem
Ligne=N+C{1,2}(1);      %nombre de ligne    
while C{1,2}(i+2)==C{1,2}(i+3)
    a=C{1,1}(i+3);      %Position du d�but de elem apr�s node
    i=i+1;
end
El=a+N+1;     %Ligne des elements
L=C{1,1}(end)-a;   %Nbr d'element
elem=zeros(L,8);
for i=1:1:L
elem(i,1)=1;
elem(i,2)=1;
elem(i,3)=1;
elem(i,4)=1;
elem(i,5)=C{1,3}(El+i);
elem(i,6)=C{1,4}(El+i);
elem(i,7)=C{1,5}(El+i);
elem(i,8)=0;
elem(i,9)=0;
end

clear C;

fileID = fopen('Force3.dat');
D = textscan(fileID,'%f %f %f %f %f');
fclose(fileID);

Nf = D{1,1}(1);
nodf=zeros(2*Nf,3);
pressure = 833333.333;
totForce = pressure*0.08;
%totForce = 2500*0.08;                             %COMMENT QUON FAIT POUR FAIRE LES PRESSIONS EN FORCE LA SA MERE LA SCHTROUMPF
appForce = totForce/Nf;                       %EN VRAI POURQUOI C'EST DANS LE MAUVAIS SENS STP ANTOINE (Mr RANDOUR)



for i=1:1:Nf
    nodf(2*i-1,1) = D{1,1}(i+1);
    nodf(2*i-1,2) = 1;
    nodf(2*i,2) = 2;
    nodf(2*i,3) = appForce;
    nodf(2*i-1,3) = 0;
    nodf(2*i,1) = D{1,1}(i+1);
end

clear D;

fileID = fopen('BC3.dat');
E = textscan(fileID, '%f %f %f %f %f');
fclose(fileID);

Nbc = E{1,1}(1);

pdof = zeros(2*Nbc,3);
for i = 1:1:Nbc
   pdof(2*i-1,1) = E{1,1}(i+1);
   pdof(2*i-1,2) = 1;
   pdof(2*i-1,3) = 0;
   pdof(2*i,1) = E{1,1}(i+1);
   pdof(2*i,2) = 2;
   pdof(2*i,3) = 0;
end

clear E;

geom=1;

data=1;

eltp=['trim3'];

mater=[190e9, 0.29];

