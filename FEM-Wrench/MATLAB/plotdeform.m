function plotdeform(inpname, fact)
%
% plotdeform(inpname, fact)
%
% function that plots the deformed mesh for TRIM3
%
% Input:
%	inpname - name of the input data file without extension
%	fact - multiplication factor of the displacements
%
% load model data file 
if exist([inpname '.mat'],'file') ~= 2
  error(['Data file not found: ', inpname, '.'])
end
[node, nnode, elem, nelem, eltp, geom, mater, data, ...
          pdof, npdof, nodf, nnodf] = getdata(inpname);
load(inpname, 'displa');
%
% build element patches
nelem = size(elem, 1);
D = sparse(3, nelem); 
for ielem = 1:nelem         
    inodee = 1:3;
    inode = elem(ielem, 4+inodee);        
    X(:, ielem) = node(inode, 1) + displa(inode, 1)*fact; 
    Y(:, ielem) = node(inode, 2) + displa(inode, 2)*fact;         
end 
%
% plot
figure
title(['Plot of the deformed configuration with a multiplying factor of ',num2str(fact)])
fill(X, Y, D)
axis equal
