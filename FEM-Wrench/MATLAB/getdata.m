function [node, nnode, elem, nelem, eltp, geom, mater, data, ...
          pdof, npdof, nodf, nnodf] = getdata(datf)
%
% [node, nnode, elem, nelem, eltp, geom, mater, data, ...
%          pdof, npdof, nodf, nnodf] = getdata(datf)
%
% function that gets the input data from the input file
%
% Input:
%	datf - input file name without the .m extension
%
% Outputs:
%	node - nodal coordinates
%	nnode - number of nodes in the structure
%	elem - element matrix
%	nelem - number of elements in the structure
%	eltp - element type
%	geom - geometry data
%	mater - material data
%	data - element data
%	pdof - prescribed degrees of freedom matrix
%	npdof - number of prescribed degrees of freedom
%	nodf - nodal point loads matrix
%	nnodf - number of nodal point loads
%
% check existence of data file
if exist(datf,'file') ~= 2
  error(['Data file not found: ', datf, '.'])
end
%
% read data from data file
eval(datf)
%
%
% Process model data
% ------------------
% check for critical missing information
if ~exist('node','var')
   error('No nodes in the structure (missing "node").')
end
nnode = size(node, 1);
if ~exist('elem','var')
   error('No elements in the structure (missing "elem").')
end
nelem = size(elem, 1);
if ~exist('mater','var')
  error('No material data supplied (missing "mater").');
end
if ~exist('pdof','var')
   error('No prescribed degrees of freedom (missing "pdof").');
end
npdof = size(pdof, 1);
% add absent items to model
if ~exist('eltp','var')
   eltp = 'trim3';
   fprintf(1, '  Warning: No element type given, default value "trim3" taken.\n');
end
if ~exist('geom','var')
  geom = 1 ;
  fprintf(1, '  Warning: No geometry data supplied, default value 1 taken.\n');
end
if ~exist('data','var')
  data = 1 ;
  fprintf(1, '  Warning: No element data supplied, default value 1 taken.\n');
end
if ~exist('nodf','var')
  nodf = [];
end
nnodf = size(nodf, 1);
node = node;
elem = elem;
mater = mater;
pdof = pdof;