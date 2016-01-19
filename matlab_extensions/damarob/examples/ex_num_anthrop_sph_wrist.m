% EX_NUM_ANTHROP_SPH_WRIST generates a numeric 6-axes anthropomorphic 
% robot with spherical wrist [RRRRRR].
% 
% This is a DAMA^{ROB} toolbox example.
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of GNU LGPLv2.1 DAMA^{ROB}
%    http://www.damarob.altervista.org
%


% homogeneous transform matrix: base to 0-frame
Tb0=[eye(3), [0;0;0.8]; [0 0 0 1]];

% homogeneous transform matrix: 3-frame to e-frame
Tne = eye(4); 
a2 = 0.2;
d4 = 0.3;
d6 = 0.2;

% DH table with joints descriptor and mechanicals limits:
DHantrosph = [[0 a2 0 0 0 0].',[pi/2 0 pi/2 -pi/2 pi/2 0].',[0 0 0 d4 0 d6].',...
[0 0 0 0 0 0].',[0 0 0 0 0 0].',[-3/4*pi 0 0 -pi -0.5 -2*pi].', [3/4*pi pi/2 pi/2 pi 0.5 2*pi].']; 

% construct manipulator object
manip3 = manipulator(DHantrosph,'manip3',Tb0,Tne);

manip3.drive_manip  %manual drive manipulator
