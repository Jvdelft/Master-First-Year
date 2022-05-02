function getreaction(datf, K, u, dofpos, Fext)
%
% getreaction(datf, K, u, dofpos)
% 
% function that saves the reaction forces of the structure
%
% Inputs:
%   datf - output data file name
%	K - structural stiffness matrix
%	u - displacement vector of the structure
%   dofpos - positioning of the degrees of freedom
%
Freac = zeros(length(u),1);
for (i = 1:length(u))
    for (j = 1:length(u))
        Freac(i) = Freac(i) + K(i,j)*u(j);
    end
end
Freac = Freac - Fext;
% -----------------------------------------------------------------------
% rearrange results for post-processing
nnode = size(dofpos, 1);
R = zeros(nnode, 2);
for inode = 1:nnode
    % fill in reaction force along x
    R(inode, 1) = Freac(dofpos(inode, 1));
    % fill in reaction force along y
    R(inode, 2) = Freac(dofpos(inode, 2));
end
%
% save to output file
save(datf, 'R', '-append');