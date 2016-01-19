% EX_SYM_ANTHROP_SPH_WRIST generates a symbolic 6-axes anthropomorphous
% robot with spherical wrist [RRRRRR].
% 
% This is a DAMA^{ROB} toolbox example.
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of GNU LGPLv2.1 DAMA^{ROB}
%    http://www.damarob.altervista.org
%


% homogeneous transform matrix: base to 0-frame
Tb0=[eye(3), [0;0;0]; [0 0 0 1]];

% homogeneous transform matrix: 3-frame to e-frame
Tne = eye(4); 

% DH table with joints descriptor and mechanicals limits:
syms a2 d4 d6;
DHantrosph_s = [[0 a2 0 0 0 0].',[pi/2 0 pi/2 -pi/2 pi/2 0].',[0 0 0 d4 0 d6].',[0 0 0 0 0 0].',...
[0 0 0 0 0 0].',[-3/4*pi 0 0 -pi -0.5 -2*pi].', [3/4*pi pi/2 pi/2 pi 0.5 2*pi].']; 

% construct manipulator object
manip5 = manipulator(DHantrosph_s,'anthropomorphous_spherical_wrist_sym',Tb0,Tne);

% evaluates Direct Kinematics
manip5.Direct_Kinematics
