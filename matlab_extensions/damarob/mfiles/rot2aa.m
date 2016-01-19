function [r,theta] = rot2aa(R)
% ROT2AA converts rotation matrix (direction cosine matrix) to axis-angle.
%  syntax: [r,theta] = rot2aa(R)
%  
%  where:
%        r is a 3x1 vector
%    theta is a scalar
%   rtheta is a 4x1 vector
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

theta = acos(0.5*(R(1,1)+R(2,2)+R(3,3)-1));

if theta == 0
    r = [1;1;1]/norm([1;1;1]);
elseif theta == pi || theta == -pi
    r = [0;0;0];
    epsilon = 0.5*[signum(R(3,2)-R(2,3))*sqrt(R(1,1)-R(2,2)-R(3,3)+1);
        signum(R(1,3)-R(3,1))*sqrt(R(2,2)-R(3,3)-R(1,1)+1);
        signum(R(2,1)-R(1,2))*sqrt(R(3,3)-R(1,1)-R(2,2)+1)];
    for i = 1:3
        r(i) = epsilon(i)/sin(theta/2);
    end
else
    r = 0.5*inv((sin(theta)))*[R(3,2)-R(2,3) ; R(1,3)-R(3,1) ; R(2,1)-R(1,2)];
end
if nargout < 2
    r = [r; theta];
end
end

function y = signum(x)
if x == 0
    y = 1;
else
    y = sign(x);
end
end

