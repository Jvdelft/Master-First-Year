function getstrainstress(datf, node, elem, eltp, mater, data, u, dofpos)
%
% getstrainstress(datf, node, elem, mater, data, u, dofpos)
%
% function that saves the strain and stress vectors for the structure
% from element data
%
% Inputs:
%       datf - data file name
%       node - nodal coordinates
%       elem - element matrix
%       eltp - element type matrix
%       mater - material data
%       data - element data
%       u - diplacement vector
%       dofpos - positioning of the degrees of freedom
%
nelem = size(elem, 1);
strain = zeros(nelem, 4);
stress = zeros(nelem, 4);
for ielem = 1:nelem
    % element type
    eltpe = eltp(elem(ielem, 1),:);
    % material type
    matere = mater(elem(ielem, 3), :);
    % element data
    datae = data(elem(ielem, 4), :);
    if eltpe == 'trim3'
        % get nodal coordinates of the element (nodel) and the
        % displacement vector of the element (uel) [6 x 1]
        m = 1;
        for i = 1:3
            for j = 1:2            
                nodee(m, j) = node(elem(ielem, 4+i), j);
                ue(m, j) = u(dofpos(elem(ielem, 4+i), j));                    
            end
            m = m + 1;
        end
        
% get strains and stresses from the element
        [results] = trim3(nodee, [], matere, datae, ue, [], 'P');
    else
        fprintf(1, '\n Unknown element type \n');
    end
    strain(ielem, :) = -results(1, :);
    stress(ielem, :) = -results(2, :);
end

% save to output file
save(datf, 'strain', 'stress', '-append')