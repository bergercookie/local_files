% EX_TRAJECTORY generates an example trajectory.
% 
% This is a DAMA^{ROB} toolbox example.
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of GNU LGPLv2.1 DAMA^{ROB}
%    http://www.damarob.altervista.org
%

startpoint = [0;0;0];
startorient = [0;0;0];
Ts = 0.001;
orient_type = 'ZYZ euler';

point_1.g = [1;0;0];
point_1.orient = [pi/2;0;0];
point_1.tf = 6;
point_1.via = 0;
point_1.path_type = 'r';

point_2.g = [1;0;1];
point_2.tf = 4;
point_2.via = 1;
point_2.path_type = 'r';

point_3.c = [1;0.5;1];
point_3.z = [0;0;1];
point_3.thf = pi;
point_3.orient = [pi/2;pi/2;0];
point_3.tf = 5;
point_3.via = 0;
point_3.path_type = 'c';

path_des = trajectory(Ts,startpoint,startorient,orient_type,point_1,point_2,point_3);