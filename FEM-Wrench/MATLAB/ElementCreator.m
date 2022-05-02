function [node, elem, pdof] = ElementCreator(Nx,Ny, n, dir)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
node = zeros(1+n, 2);
S = Nx*Ny;
Ssquare = 2*S/n;
k = 1;
elem = zeros(n, 9);
Trim3Side = sqrt(Ssquare);
pdof = zeros(1+n, 3);
for i = 0:Trim3Side:Nx
    for j = 0:Trim3Side:Ny
        node(k,:) = [j, i];
        k = k + 1;
    end
end
    for(j = 1:Ny/Trim3Side)
        for(i = 1:2*Nx/Trim3Side)
            if mod(i,2) == 1
                
                k = ceil(i/2);
                elem(i+ (j-1)*2*Nx/Trim3Side,5:7) = [k+(j-1)*(Nx/Trim3Side+1)   k+1+(j-1)*(Nx/Trim3Side+1)   k+j*(Nx/Trim3Side+1)];
                
            else
                
                k = i/2;
                elem(i+ (j-1)*2*Nx/Trim3Side,5:7) = [k+1+(j-1)*(Nx/Trim3Side+1)   k+1+j*(Nx/Trim3Side+1)   k+j*(Nx/Trim3Side+1)];
                
            end
        end
    end
    for(i = 1:n)
        elem(i, 1:4) = [1 1 1 1];
        elem(i,8:9) = [0 0];
    end
    
    for(i = 1 : size(node,1))
        if(i ~= ceil(size(node,1)/2))
            pdof(i,1:3) = [i dir 1];
            if(dir ==1)
                pdof(i+1,1:3) = [ceil(i/2) dir+1 0];
            end
        else
            k = i;
            
        end
    end    
    pdof(k,:) = [];
end

