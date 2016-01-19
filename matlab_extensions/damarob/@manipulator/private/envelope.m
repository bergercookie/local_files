function lim = envelope(manip)
% ENVELOPE find the minimum and maximum workspace coordinates x y z for a 
% manipulator.
%   syntax: lim = envelope(manip)
%
%                  [xmin, xmax]
%           lim =  [ymin, ymax]
%                  [zmin, zmax]
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

% q boundles
q_min = double(manip.DH.table(:,6));              % limits
q_max = double(manip.DH.table(:,7));
r = manip.DH.r;                                   % number of joints
for i = 1:1:r                                     % check finite value limits
    if q_min(i) == -Inf
        if manip.DH.table(i,5) == 0
            q_min(i) = -4;
        else
            q_min(i) = -1;
        end
    end
    if q_max(i) == Inf
        if manip.DH.table(i,5) == 0
            q_max(i) = 4;
        else
            q_max(i) = 1;
        end
    end
end

x = cell(1,r);
xM = cell(1,r);
syms q;
var = sym(zeros(1,r));
varM = sym(zeros(1,r));

for i=1:1:r    % FIND MIN MAX X
    var(i) = q;
    varM(i)= q;
    varc = char(vpa(var,4));
    varMc = char(vpa(varM,4));
    x{i} = eval(['@(q)manip.func.x(',varc(9:end-2),')']);
    xM{i} = eval(['@(q)-1*manip.func.x(',varMc(9:end-2),')']);
    var(i) = fminbnd(x{i},q_min(i),q_max(i));
    varM(i) = fminbnd(xM{i},q_min(i),q_max(i));
end
xmin = manip.func.x(double(var));
xmax = manip.func.x(double(varM));



for i=1:1:r    % FIND MIN MAX Y
    var(i) = q;
    varM(i)= q;
    varc = char(vpa(var,4));
    varMc = char(vpa(varM,4));
    x{i} = eval(['@(q)manip.func.y(',varc(9:end-2),')']);
    xM{i} = eval(['@(q)-1*manip.func.y(',varMc(9:end-2),')']);
    var(i) = fminbnd(x{i},q_min(i),q_max(i));
    varM(i) = fminbnd(xM{i},q_min(i),q_max(i));
end
ymin = manip.func.y(double(var));
ymax = manip.func.y(double(varM));



for i=1:1:r    % FIND MIN MAX Z
    var(i) = q;
    varM(i)= q;
    varc = char(vpa(var,4));
    varMc = char(vpa(varM,4));
    x{i} = eval(['@(q)manip.func.z(',varc(9:end-2),')']);
    xM{i} = eval(['@(q)-1*manip.func.z(',varMc(9:end-2),')']);
    var(i) = fminbnd(x{i},q_min(i),q_max(i));
    varM(i) = fminbnd(xM{i},q_min(i),q_max(i));
end
zmin = manip.func.z(double(var));
zmax = manip.func.z(double(varM));


lim = [xmin, xmax; ymin, ymax; zmin, zmax];
end

