function Fp = getpforce(nodf, dofpos)
%
% Fp = getpforce(nodf, dofpos)
%
% function that creates the force vector from the specified nodal point loads
%
% Inputs:
%   nodf - nodal force vector from the input file
%   dofpos - positioning of the degrees of freedom in the unknowns
% 
% Output:
%	Fp - force vector corresponding to the point loads [ndofx1]
%
ndof = size(dofpos, 1)*size(dofpos, 2);
nnodf = size(nodf, 1);
Fp = sparse(ndof, 1);
%
for inodf = 1:nnodf
    % degree of freedom of the nodal force
    idof = dofpos(nodf(inodf, 1), nodf(inodf, 2)); 
    % value of the prescribed force
    iF = nodf(inodf, 3);
    Fp(idof, :) = iF;
end