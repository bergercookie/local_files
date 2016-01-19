function R = euler2rot(angles,type)
% EULER2ROT converts a three component vector (angles) of Euler angles to a rotation
% matrix.
%  syntax: R = euler2rot(angles,type)
%
%  where:
%       type = 'ZYZ' --> ZYZ Euler angles
%       type = 'ZYX' --> ZYX Euler angles (roll-pitch-yaw)
%             angles --> vector of Euler angles
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

ph = angles(1);
th = angles(2);
ps = angles(3);

if strcmp(type,'ZYZ')

R = [(cos(ph)*cos(th)*cos(ps) - sin(ph)*sin(ps)) (-cos(ph)*cos(th)*sin(ps) - sin(ph)*cos(ps))   cos(ph)*sin(th);
     (sin(ph)*cos(th)*cos(ps) + cos(ph)*sin(ps)) (-sin(ph)*cos(th)*sin(ps) + cos(ph)*cos(ps))   sin(ph)*sin(th);
     -sin(th)*cos(ps)                                  sin(th)*sin(ps)                                  cos(th)];
 
elseif strcmp(type,'ZYX')
    
R = [(cos(ph)*cos(th))     (cos(ph)*sin(th)*sin(ps)-sin(ph)*cos(ps))   (cos(ph)*sin(th)*cos(ps)+sin(ph)*sin(ps));
     (sin(ph)*cos(th))     (sin(ph)*sin(th)*sin(ps)+cos(ph)*cos(ps))   (sin(ph)*sin(th)*cos(ps)-cos(ph)*sin(ps));
     -(sin(th))            (cos(th)*sin(ps))                           (cos(th)*cos(ps))];
    
else
    disp('');
    disp(' ERROR : second input must be ''ZYZ'' or ''ZYX''');
    disp('');
    return
end