function [pos, ornt] = pose(manip, q)

% POSE numerically evaluates pose through forward kinematics
%    syntax: [position, orientation] = manipulator.pose(q)
%            [pose] = manipulator.pose(q)
%
%     See also manipulator
%              manipulator/Direct_Kinematics
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

if manip.is_sym == 0
    if manip.evaluated.Direct_Kinematics == 0
        disp(' attempted to evaluate pose without computing kinematics'); 
        pos = [];
        ornt = [];
        return
    else
        nsap = manip.func.nsap(q);
        pos = nsap(10:12);
        [o1 o2 o3 o4] = rot2aa(reshape(nsap(1:9),3,3));
        ornt = [o1;o2;o3;o4];
    end

    if nargout <= 1
        pos = [pos; ornt];
    end
else
    disp(' Unable to call pose.m for a symbolic manipulator. ');
    disp(' Try to evaluate Direct_Kinematics, then use:')
    disp('     manipulator.kin.nsap  or manipulator.kin.T.Tbe');
end
