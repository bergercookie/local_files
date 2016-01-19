function manipY = plus(manipA,manipB)
% PLUS (operator +) concatenates manipulator objects.
%    syntax: 
%          manipC = manipA + manipB
%
% Creates a manipulator manipC with:
%        Tb0 of manipA
%        all manipA links
%        all manipB links
%        Tne of manipB
%
%  note: manipA and manipB must be both numeric or symbolic
%
%     See also manipulator
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


if nargin ~=2
    disp(' please specify two manipulators. aborted');
    manipY = manipulator();
    return
end
if xor(manipA.is_sym, manipB.is_sym)
    disp(' manipulators aren''t both numeric or symbolic. aborted');
    manipY = manipulator();
else
    DHA = manipA.DH.table;
    DHB = manipB.DH.table;
    DHY = [DHA;DHB];
    Y_Tb0 = manipA.kin.T.Tb0;
    Y_Tne = manipB.kin.T.Tne;
    Y_name = [manipA.name,'_',manipB.name];

    manipY = manipulator(DHY,Y_name,Y_Tb0,Y_Tne);
end
end
