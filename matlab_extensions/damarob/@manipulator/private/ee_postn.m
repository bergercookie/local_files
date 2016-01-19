function [x y z] = ee_postn(manip)
% EE_POSTN creates function handles that evaluate end-effector position
% through a simple forward kinematics algorithm.
%    syntax: [x y z] = ee_postn(manip)
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of GNU LGPLv2.1 DAMA^{ROB}
%    http://www.damarob.altervista.org
%

%     DAMA^{ROB}: a symbolic robotics toolbox for matlab(tm)
%     Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
%       http://www.damarob.altervista.org
%       damarobotics@gmail.com
% 
%     This library is free software; you can redistribute it and/or
%     modify it under the terms of the GNU Lesser General Public
%     License as published by the Free Software Foundation; either
%     version 2.1 of the License, or (at your option) any later version.
% 
%     This library is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%     Lesser General Public License for more details.
% 
%     You should have received a copy of the GNU Lesser General Public
%     License along with this library; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

% Initialization
DH=manip.DH.table;
r=manip.DH.r;

A = cell(1,r);
T = cell(1,r);

Tb0 = manip.kin.T.Tb0;
Tne = manip.kin.T.Tne;

%% Evaluation of single homogeneous transformation matrices

for i=1:r
    Ai = [cos(DH(i,4)) -sin(DH(i,4))*cos(DH(i,2))  sin(DH(i,4))*sin(DH(i,2)) DH(i,1)*cos(DH(i,4));
        sin(DH(i,4))  cos(DH(i,4))*cos(DH(i,2)) -cos(DH(i,4))*sin(DH(i,2)) DH(i,1)*sin(DH(i,4));
        0             sin(DH(i,2))               cos(DH(i,2))              DH(i,3)             ;
        0             0                          0                         1                  ];

    A{i} = Ai;
end

%% Evaluation of T and the position of the end-effector frame

T{1} = A{1};
for i=2:r
    T{i} = T{i-1} * A{i};           % T(i) = T(i-1)*A(i);
end
Tbe = Tb0 * T{r} * Tne;
pe = Tbe(1:3,4);


%% Creation of function handles
pe_ = cell(1,3);
for z = 1:1:3
    pe_{z} = char(pe(z));    
    for k = r:-1:1
        if DH(k,5) == 0         % revolute
            var_ind = strfind(pe_{z},['th',num2str(k)]);
            shift = 1;
        else
            var_ind = strfind(pe_{z},['d',num2str(k)]);
            shift = 2;
        end
        for j=var_ind(end:-1:1)
            for i = length(pe_{z}):-1:j
                pe_{z}(i+shift) = pe_{z}(i);
            end
            pe_{z}(j:j+length(['q(',num2str(k),')'])-1) = ['q(',num2str(k),')'];
        end
    end
end

x = eval(['@(q)',pe_{1}]);
y = eval(['@(q)',pe_{2}]);
z = eval(['@(q)',pe_{3}]);
end