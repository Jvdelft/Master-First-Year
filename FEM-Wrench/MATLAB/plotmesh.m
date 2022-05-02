function plotmesh(inpname)
%
% plotmesh(inpname)
%
% function that plots the mesh of the input data file for TRIM3
%
% Input:
%	inpname - name of the input data file without extension
%
% load model data file
eval(inpname)
%
nelem = size(elem, 1);
for ielem = 1:nelem 
    inodee = 1:3;
    inode = elem(ielem, 4+inodee);
    X(:, ielem) = node(inode, 1); 
    Y(:, ielem) = node(inode, 2); 
    D(:, ielem) = elem(ielem, 1);
end 
%
% plot 
figure
fill(X, Y, D)
title('Plot of the mesh')
colorbar
axis equal
