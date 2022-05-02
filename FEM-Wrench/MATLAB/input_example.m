% nodal coordinates [x y]
node = [
    0       0
    1       0
    2       0
    0       1
    1       1
    2       1
    0       2
    1       2
    2       2
    ];
    

% mesh connectivity 
% [type# geometry# material# data#    node1 node2 node3     bx by ]   
elem = [
    1       1         1        1        1     2     4       0   0 
    1       1         1        1        2     5     4       0   0
    1       1         1        1        2     3     5       0   0 
    1       1         1        1        3     6     5       0   0 
    1       1         1        1        4     5     7       0   0 
    1       1         1        1        5     8     7       0   0 
    1       1         1        1        5     6     8       0   0 
    1       1         1        1        6     9     8       0   0 
    ];

% prescribed degrees of freedom (displacements)
% [node# dir value]
pdof = [
    
    
    ];


% applied point/nodal loads
% [node# dir value]
nodf = [
    5 2 10
];

[node, elem, pdof] = ElementCreator(1,1,8,1);

% finite element type
eltp = ['trim3'];

% geometry (thickness)
geom = [ 1 ];

% material parameters
E = 210e9; % elastic modulus
nu = 0.3; % Poisson's ratio

% material parameter matrix
mater = [    
  E nu
  ];

% element data (plane switch: 1 = plane stress, 2 = plane strain)
data = [ 1 ];
