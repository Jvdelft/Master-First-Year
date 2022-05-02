function [Kcl, Fcl] = boundcond(pdof, Ksys, Fext, method, dofpos)
%
% [Kcl, Fcl] = boundcond(node, nndof, dofpos, method, Ksys, Fext)
%
% function that applies the boundary conditions to the structural system
%
% Inputs:
%   pdof - prescribed degrees of freedom matrix from the input file
%	Ksys - structural stiffness matrix without the boundary conditions
%	Fext - external force vector without the boundary conditions
%	method - if method < 0 direct method
%		 if method > 0 penalty method (Z = method)
%	dofpos - positioning matrix of the degrees of freedom
%
% Outputs:
%	Kcl - structural stiffness matrix with the boundary conditions applied
%	Fcl - external force vector with the boundary conditions applied
%
% total number of nodes in the structure
nnode = length(dofpos);
% the total number of degrees of freedom of the system
ndof = 2*nnode - size(pdof, 1);
% the number of nodal degrees of freedom
ndof_node = 2;
% initialize Kcl and Fcl
Fcl = Fext;
Kcl = Ksys;
%
if method < 0
    % solution by the direct method
    %
    for (i = 1:size(pdof,1))
        n = dofpos(pdof(i,1),pdof(i,2));
        Fcl = Fcl - Kcl(:,n).*pdof(i,3);
        Kcl(:,n) = 0;
        Kcl(n,:) = 0;
        Kcl(n,n) = 1;
        Fcl(n)=pdof(i,3);
    end
else
    % solution by the penalty method
    Z = method;
    % check for the value of Z! (is it high enough?)
    if(Z >= 10e6)
        for(i = 1:size(pdof,1))
            n = dofpos(pdof(i,1),pdof(i,2));
            Kcl(n,n) = Kcl(n,n) + Z;
            Fcl(n) = Fcl(n) + Z*pdof(i,3);
        end
        
    end
    
end
%