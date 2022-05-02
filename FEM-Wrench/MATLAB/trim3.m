function [out] = trim3(nodee, geome, matere, datae, ue, be, key)
%
% [out] = trim3(nodee, geome, matere, datae, ue, key)
% 
% TRIM3 finite element for plane stress/plane strain analysis
%
% Inputs:
%	nodee - nodal coordinates of the element nodes [x y] x node
%	geome - geometry data of the element
%	matere - material data of the element
%	datae - element data of the element
%	ue - displacement vector of the element [ux uy] x nnode
%   be - the volume force vector [bex bey bez]
%	key - if key = 'K' the output is the stiffness matrix of the element
%	      if key = 'P' the output is the stress and strain
%
% Output:
%	out - depends on the value of 'key'
%

%Coordinate of the nodes
x1 = nodee(1,1);
y1 = nodee(1,2);
x2 = nodee(2,1);
y2 = nodee(2,2);
x3 = nodee(3,1);
y3 = nodee(3,2);

Delta = 1/2*abs(det([1 1 1;x1 x2 x3; y1 y2 y3]));

%Matere
E = matere(1);
nu = matere(2);

if (size(ue,1) == 3)
    u = zeros(6,1);
    k = 1;
    for i = 1:3
        for j = 1:2
            u(k) = ue(i,j);
            k = k+1;
        end
    end
else
    u = ue;
end


B = (-1/(2*Delta))*[y3-y2 0 y1-y3 0 y2-y1 0; 0 x2-x3 0 x3-x1 0 x1-x2; x2-x3 y3-y2 x3-x1 y1-y3 x1-x2 y2-y1];

if (datae == 1) %plane stress
    if(key == 'P')
        eps_e = B*u;
        eps_e2 = [eps_e(1); eps_e(2); -(eps_e(1)+eps_e(2))*nu/(1-nu); eps_e(3)];

        %Stress for plane stress !!!
        H_stress = (E*(1-nu))/((1+nu)*(1-2*nu))*[1 nu/(1-nu) nu/(1-nu) 0; nu/(1-nu) 1 nu/(1-nu) 0; nu/(1-nu) nu/(1-nu) 1 0; 0 0 0 (1-2*nu)/(2*(1-nu))];
        sig_e = H_stress*eps_e2;
    end
    H = E/(1-nu^2)*[1 nu 0; nu 1 0; 0 0 (1-nu)/2];

elseif (datae == 2)
    if(key == 'P')
        eps_e = B*u;
        eps_e2 = [eps_e(1); eps_e(2); 0; eps_e(3)];

        %Stress for plane strain !!!
        H_stress = ((E*(1-nu))/((1+nu)*(1-2*nu)))*[1 nu/(1-nu) nu/(1-nu) 0; nu/(1-nu) 1 nu/(1-nu) 0; nu/(1-nu) nu/(1-nu) 1 0; 0 0 0 (1-2*nu)/(2*(1-nu))];
        sig_e = H_stress*eps_e2;  
    end
    H = E/((1+nu)*(1-2*nu))*[1-nu nu 0; nu 1-nu 0; 0 0 (1-2*nu)/2];
end
       

%Ke implementation
%Ke = B.' * H_stress * B*de*Delta;


if key == 'K'
% compute the stiffness matrix of the finite element
    Kel = transpose(B)*H*B*geome*Delta;
    out = Kel;
elseif key == 'P'
% post-processing step, compute the strain and stress matrix
    strain = eps_e2'; % [1 x 4]
    stress = sig_e'; % [1 x 4]
    out = [strain; stress];
else    
    fprintf(1, '\n Unknown key when calling TRIM3 element routine! \n')
end
