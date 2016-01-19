function value = iszero(r)
% ISZERO checks if input is a 0, a nullvector or a null 2x2 matrix
%    syntax: result = iszero(r)
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

if size(r)*[1;0] > size(r)*[0;1]
    r=r.';
end
value = prod(double(r(1:end) == zeros(1,length(r))));
end