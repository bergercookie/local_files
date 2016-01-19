% EX_NUM_SCARA generates a numeric 4-axes SCARA robot [RRPR].
% 
% This is a DAMA^{ROB} toolbox example.
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of GNU LGPLv2.1 DAMA^{ROB}
%    http://www.damarob.altervista.org
%

% homogeneous transform matrix: base to 0-frame
Tb0=[eye(3), [0;0;1]; [0 0 0 1]]; 
% homogeneous transform matrix: 3-frame to e-frame
Tne = eye(4);

% DH table with joints descriptor and mechanicals limits:
DHscara = [[0.5 0.5 0 0].',[0 pi 0 0].', [0 0 0 0].', [0 0 0 0].' ,[0 0 1 0].',[-pi/2 -pi/2 0.25 -2*pi].' ,[pi/2 pi/4 1 2*pi].' ];

% construct manipulator object
manip_scara = manipulator(DHscara,'scara',Tb0,Tne) %#ok<NOPTS>
manip_scara.jointpos(3) = 0.25;  % set prismatic joint position to lower limit
manip_scara.drive_manip;
%% Dynamics Data
dyndata.g0=[0; 0; -9.8];         % gravity in 0-frame
dyndata.ml=[25; 25; 10; 0];      % links mass
dyndata.mm=[0; 0; 0; 0];         % rotors mass
% links' center of mass position:
dyndata.pl={[-0.25; 0; 0], [-0.25; 0; 0], [0; 0; -0.5], [0; 0; 0]};
% rotors' center of mass position
dyndata.pm={[0; 0; 0], [0; 0; 0], [0; 0; 0], [0; 0; 0]};
% links' inertia tensors
dyndata.Il{1} = [0 0 0; 0 0 0; 0 0 5];
dyndata.Il{2} = [0 0 0; 0 0 0; 0 0 5];
dyndata.Il{3} = [0 0 0; 0 0 0; 0 0 0];
dyndata.Il{4} = [0 0 0; 0 0 0; 0 0 1];
% rotors' inertia tensors
dyndata.Im{1} = [0 0 0; 0 0 0; 0 0 0.02];
dyndata.Im{2} = [0 0 0; 0 0 0; 0 0 0.02];
dyndata.Im{3} = [0 0 0; 0 0 0; 0 0 0.005];
dyndata.Im{4} = [0 0 0; 0 0 0; 0 0 0.001];
% motorgear ratio
dyndata.kr=[1;1;50;20];
%viscous friction
dyndata.Fm = diag([1e-4 1e-4 1e-2 5e-3]);
dyndata.Fv = dyndata.Fm*(diag(dyndata.kr).^2);
%a motor axes:
dyndata.zm{1} = [0;0;1];     % in 0-frame
dyndata.zm{2} = [0;0;1];     % in 1-frame
dyndata.zm{3} = [0;0;1];     % in 2-frame
dyndata.zm{4} = [0;0;1];     % in 3-frame
manip_scara.InsertDyndata(dyndata);

% Evaluate Kinematics matrices and functions
manip_scara.Direct_Kinematics();

% Evaluate Dynamics matrices and functions
manip_scara.Direct_Dynamics();
