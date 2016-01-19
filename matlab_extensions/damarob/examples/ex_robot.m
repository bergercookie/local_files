% EX_ROBOT - trajectory and kinematics demo
% Run this file to see an example of trajectory generation, kinematics 
% inversion and virtual reality simulation. 
% 
% This is a DAMA^{ROB} toolbox example.
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of GNU LGPLv2.1 DAMA^{ROB}
%    http://www.damarob.altervista.org
%

clc
disp(' DAMA^{ROB} Toolbox: a symobolic robotics toolbox for Matlab(tm)');
disp(' ');
disp(' DAMA^{ROB} DEMO');
disp(' This demo will show some basic functionalities of DAMA^{ROB} Toolbox:');
disp(' ');
disp(' - creation of a numeric 6-axes anthropomorphic manipulator with spherical wrist');
disp(' - manipulator Direct Kinematics evaluation');
disp(' - trajectory generation');
disp(' - inverse kinematics algorithm');
disp(' ');
disp(' Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.');
disp(' This file is part of GNU LGPLv2.1 DAMA^{ROB}');
disp('    http://www.damarob.altervista.org');
disp(' ');
disp('                         Press a key to go on');
pause;


%% define an anthropomorphic robot with spherical wrist, drive it
disp(' Creating a numeric 6-axes anthropomorphic manipulator with spherical wrist');
disp(' and opening manual-drive window through ex_num_anthrop_sph_wrist.m');
ex_num_anthrop_sph_wrist;
disp(' ');
disp('                         Press a key to go on');
pause;
if ishandle(manip3.fig.manmov.mainfig)
    close(manip3.fig.manmov.mainfig)
end

%% evaluate robot's direct kinematics
disp(' Evaluating manipulator''s direct kinematics');
manip3.Direct_Kinematics;
disp(' ');
disp('                         Press a key to go on');
pause;


%% define a trajectory
disp(' Defining a trajectory');
startpoint = [0.2;0;0.3];    % [0;0.4;0.45;0;-0.3;0]
startorient = [0;0;pi];
Ts = 0.01;
orient_type = 'ZYX euler';

point_1.g = [0.278;-0.433;0.509];
point_1.orient = [0;0;pi];
point_1.tf = 6;
point_1.via = 1;
point_1.path_type = 'r';

point_2.g = [0.1;0.3;0.8];
point_2.orient = [0;0;pi];
point_2.tf = 4;
point_2.via = 0;
point_2.path_type = 'r';

point_3.g = [0.1;0.5;0.8];
point_3.orient = [0;pi/6;pi];
point_3.tf = 4;
point_3.via = 0;
point_3.path_type = 'r';

point_4.c = [0;0;0.7];
point_4.z = [0;0;1];
point_4.thf = pi;
point_4.orient = [0;0;pi];
point_4.tf = 5;
point_4.via = 1;
point_4.path_type = 'c';

point_5.g = [0.3;-0.4;0.8];
point_5.orient = [0;0;pi];
point_5.tf = 4;
point_5.via = 0;
point_5.path_type = 'r';

point_6.g = [0.3;0;0.7];
point_6.orient = [0;pi/8;pi];
point_6.tf = 4;
point_6.via = 0;
point_6.path_type = 'r';

point_7.g = [0.3;0;0.7];
point_7.orient = [0;-pi/8;pi];
point_7.tf = 4;
point_7.via = 0;
point_7.path_type = 'r';

path_des = trajectory(Ts,startpoint,startorient,orient_type,point_1,point_2,point_3,point_4,point_5,point_6,point_7);

%% inverse kinematics
Kp = 50*eye(3);
Ko = 50*eye(3);
Ts_mdl = 0.01;

disp(' ');
disp('                         Press a key to go on');
pause;

disp(' Executing inverse kinematics algorithm');
open('ex_kinematics_inversion')
sim('ex_kinematics_inversion');
disp(' Demo Completed');
disp(' ');
disp(' Type:')
disp('     manip3.delete');
disp(' To delete manip3 object and associated function m-files');

