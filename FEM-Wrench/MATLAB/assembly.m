function [Ksys] = assembly(node, elem, eltp, geom, mater, data, dofpos)
%
% [Ksys] = assembly(node, element, geom, mater, data)
%
% function that assembles the structural stiffness matrix from the element
% stiffness matrix contributions
%
% Inputs:
%	node - nodal coordinates matrix of the structure
%	elem - element defintion matrix of the structure
%   eltp - element type matrix
%	geom - geometry data matrix of the structure
%	mater - material properties data of the structure
%	data - element data (plane switch)
%     dofpos - position of the degrees of freedom
%
% Output:
%	Ksys - stiffness matrix of the complete system [ndof x ndof]
%
% number of elements in the structure

nelem = size(elem,1);
% total number of degrees of freedom of the structure
ndof =  2*size(node,1);
% initialize Ksys to empty sparse
Ksys = zeros(ndof,ndof);
%
for ielem = 1:nelem
    % nodes of the element
    nodelem = elem(ielem, 5:7);
    nodee = zeros(3,2);
    for k = 1:3
        nodee(k,:) = node(nodelem(k),:);
    end
    % geometry data of the element
    geome = geom(elem(ielem,2),:);
    % material data of the element
    matere = mater(elem(ielem,4),:);
    % element data of the element
    datae = data(elem(ielem,4),:);
    % element type of the element
    eltpe = eltp(elem(ielem, 1), :);
    % call element as a function of its type to get its stiffness matrix
    if eltpe == 'trim3'
        K = trim3(nodee,geome,matere,datae,[],[], 'K');
    end
    % determine the positioning of the dof in the unkowns
    for i = 1:6
        fnode = ceil(i/2);
        nodenumber = nodelem(fnode);
        if (mod(i,2) == 1)
            dir = 1;
        else
            dir = 2;
        end
        row = dofpos(nodenumber, dir);
    
        for j = 1:6
            vnode = ceil(j/2);
            vnodenumber = nodelem(vnode);
            if (mod(j,2) == 1)
                vdir = 1;
            else
                vdir = 2;
            end
            col = dofpos(vnodenumber, vdir);
            Ksys(row,col) = Ksys(row,col) + K(i,j);
        end
    end
    
    % add element contribution to the structural stiffness matrix
end
end
%
