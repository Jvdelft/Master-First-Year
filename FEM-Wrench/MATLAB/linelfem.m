function linelfem(inpname)
close all;
%
% linelfem(inpname)
%
% main routine of the finite element code for linear elastic computations
%
% Input:
%	inpname - input file name
%
% -----------------------------------------------------------------------
% INPUT DATA FILE
% -----------------------------------------------------------------------
% read data file
[node, nnode, elem, nelem, eltp, geom, mater, data, pdof, npdof, ...
       nodf, nnodf] = getdata(inpname);
% show some info on the data
ndof = nnode*2;
fprintf(1, '\n  datafile  = %9s \n \n', inpname);
fprintf(1, ['\n  nelem  = %9i  nnode  = %9i  ndof   = %9i\n  npdof  = %9i  nnodf  = %9i \n'], ...
    nelem, nnode, ndof, npdof, nnodf);
% basic positioning of the degrees of freedom of the structure in 2D
% line = node number, column 1: diplacement x, column 2: displacement y
dofpos = [1:2:(2*nnode -1); 2:2:(2*nnode)]';
% save input data to file
save(inpname, 'node', 'elem', 'eltp', 'geom', 'mater', 'data', 'pdof', 'nodf', 'dofpos');
% -----------------------------------------------------------------------
% EXTERNAL FORCE VECTOR
% -----------------------------------------------------------------------
% the external point load force vector
Fext = getpforce(nodf, dofpos);
%
% -----------------------------------------------------------------------
% STIFFNESS MATRIX
% -----------------------------------------------------------------------
% assembly of the structural stiffness matrix
Ksys = assembly(node, elem, eltp, geom, mater, data, dofpos);
%
% apply the boundary conditions
[Kcl, Fcl] = boundcond(pdof, Ksys, Fext, -1, dofpos);
%
% -----------------------------------------------------------------------
% SOLVE THE SYSTEM
% -----------------------------------------------------------------------
u = Kcl\Fcl;
%
% -----------------------------------------------------------------------
% POST-PROCESSING OF THE RESULTS
% -----------------------------------------------------------------------
% save displacement data
getdispla(inpname, u, dofpos);
% save the reaction forces
getreaction(inpname, Ksys, u, dofpos, Fext);
% save strains and stresses
getstrainstress(inpname, node, elem, eltp, mater, data, u, dofpos);
plotmesh(inpname);
plotstress(inpname, 1, 1);
plotstrain(inpname, 1, 1);
plotdeform(inpname, 1);
