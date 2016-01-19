function [cropped, xm,xM,ym,yM] = cropimage(m,RGB)
% CROPIMAGE returns cropped image of a manipulator snapshot.
%    syntax: [cropped, xm,xM,ym,yM] = cropimage(m,RGB)
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

m = double(m(1:end-9,:,:));
s = size(m);

for i=1:1:s(2)
    if iszero(m(:,i,1)-RGB(1)) && iszero(m(:,i,2)-RGB(2)) && iszero(m(:,i,3)-RGB(3))
    else
        break
    end
end
xm = i;

for i=1:1:s(2)
    if iszero(m(:,s(2)+1-i,1)-RGB(1)) && iszero(m(:,s(2)+1-i,2)-RGB(2)) && iszero(m(:,s(2)+1-i,3)-RGB(3))
    else
        break
    end
end
xM = s(2)+1-i;

for i=1:1:s(1)
    if iszero(m(i,:,1)-RGB(1)) && iszero(m(i,:,2)-RGB(2)) && iszero(m(i,:,3)-RGB(3))
    else
        break
    end
end
ym = i;

for i=1:1:s(1)
    if iszero(m(s(1)+1-i,:,1)-RGB(1)) && iszero(m(s(1)+1-i,:,2)-RGB(2)) && iszero(m(s(1)+1-i,:,3)-RGB(3))
    else
        break
    end
end
yM = s(1)+1-i;

% return
cropped = uint8(m(ym:yM,xm:xM,:));

if nargout==0
    image(cropped);
    cropped=[];
    disp '    xm  xM  ym  yM';
    disp([xm,xM,ym,yM]);
end
end