function show_manip(manip,show_axes)
% SHOW_MANIP shows a 3D view of a manipulator object.
%    syntax: show_manip(manip,show_axes)
%            show_axes is a flag to view axes
%
%     See also manipulator
%              manipulator/drive_manip
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

if manip.DH.r==0 && isfield(manip.DH,'table')
    disp(' Unable to drive or show a manipulator without joints');    
    return    
end
if manip.is_sym == 0
    if nargin == 1
        show_axes = 1;
    end
    manip.jointpos = manip.jointpos;                  % open 3D window
    scale = [1,1,1]*show_axes;
    for i=1:1:manip.DH.r
        eval(['manip.vr_base.Xaxis',num2str(i-1),'.scale = [',num2str(scale),'];']);
        eval(['manip.vr_base.Yaxis',num2str(i-1),'.scale = [',num2str(scale),'];']);
        eval(['manip.vr_base.Zaxis',num2str(i-1),'.scale = [',num2str(scale),'];']);
    end
else
    disp(' Unable to drive or show a symbolic manipulator');
end