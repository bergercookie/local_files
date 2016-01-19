function R = aa2rot(r,th)
% AA2ROT converts axis and angle to rotation matrix (direction cosine
% matrix).
%  syntax: R = aa2rot(r,th)
%
%  where:
%        r --> axis
%       th --> angle
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

if norm(r) == 0
    R = eye(3);
else
    r = r./norm(r);

    c = cos(th);
    s = sin(th);

    R = [r(1)^2*(1-c)+c                r(1)*r(2)*(1-c)-r(3)*s     r(1)*r(3)*(1-c)+r(2)*s;
        r(1)*r(2)*(1-c)+r(3)*s        r(2)^2*(1-c)+c             r(2)*r(3)*(1-c)-r(1)*s;
        r(1)*r(3)*(1-c)-r(2)*s        r(2)*r(3)*(1-c)+r(1)*s     r(3)^2*(1-c)+c];
end