function plotstress(inpname, fact, comp)
%
% plotstress(inpname, fact, comp)
%
% function that plots the stress distribution in the deformed configuration
%
% Input:
%	inpname - name of the input data file without extension
%	fact - multiplication factor of the displacements
%   comp - stress component to plot
%
% load model data file 
if exist([inpname '.mat'],'file') ~= 2
  error(['Data file not found: ', inpname, '.'])
end
[node, nnode, elem, nelem, eltp, geom, mater, data, ...
          pdof, npdof, nodf, nnodf] = getdata(inpname);
load(inpname,'stress','displa');
%
% build element patches
nelem = size(elem, 1);
for ielem = 1:nelem         
    inodee = 1:3;
    inode = elem(ielem, 4+inodee);
    X(:, ielem) = node(inode, 1) + displa(inode, 1) * fact;
    Y(:, ielem) = node(inode, 2) + displa(inode, 2) * fact; 
    D(:, ielem) = stress(ielem, comp)*inodee';
end 
%
% plot
figure
fill(X, Y, D)
title(['Plot of the stress ',num2str(comp)])
shading flat
colorbar
lim = caxis
caxis([-300000000 300000000]);
axis equal
