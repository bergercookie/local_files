function str = char(manipulator)
% CHAR returns a string containing manipulator data
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

%% VOID MANIPULATOR
if manipulator.DH.r == 0 && ~isfield(manipulator.DH,'table')
    str = sprintf('\nans = \n\n   void manipulator object \n');
    return
end

%% DH TABLE
str = sprintf('\n %s \n ',['Manipulator Name: ',manipulator.name]);

if manipulator.is_sym
    str = [str, '                  Symbolic Data Manipulator'];
else
    str = [str, '                  Numeric Data Manipulator'];
end

str = [str, sprintf('\n\n%s \n', 'joint     a      alpha    d      theta      P/R    min   max')];




table = vpa(manipulator.DH.table,4);
for i=1:1:manipulator.DH.r;
%    strA =  sprintf('  %d \t %2.2f \t %2.2f \t %2.2f \t %2.2f', [i, table(i,1:4)]);
    strA = sprintf('  %d \t ', i);
        for j = 1:4
            if( isreal(table(i,j)) )
                strA =  [strA, sprintf('%2.2f \t ', double(table(i,j)))]; %#ok<AGROW>
            else
                strA =  [strA, sprintf('%s \t ', char(table(i,j)))]; %#ok<AGROW>
            end
        end
    
    if eval(table(i,5)) == 0
        strB = sprintf('    %s', 'R');
    else
        strB = sprintf('    %s', 'P');
    end
    strC = sprintf('     %2.2f  %2.2f \n', double(table(i,6:7)));
    str = [str, strA, strB, strC]; %#ok<AGROW>
end

%% Tb0 and Tne
strTname = sprintf('\n\n  \t %s  \t \t \t \t \t %s \n','Tb0','Tne');
strTdata = [];
for i=1:4
    strTdata = [strTdata, sprintf('%2.2f \t %2.2f \t %2.2f \t %2.2f \t\t %2.2f \t %2.2f \t %2.2f \t %2.2f \n',manipulator.kin.T.Tb0(i,:),manipulator.kin.T.Tne(i,:) )]; %#ok<AGROW>
end

%% Kinematics Data
if manipulator.evaluated.Direct_Kinematics == 1
    strKin = sprintf('\n  Direct Kinematics computed');
else
    strKin = '';
end
%% Dynamics Data
if manipulator.dyndata == 1
    strDyndata = sprintf('\n  valid dynamics data inserted');
    if manipulator.evaluated.Direct_Dynamics == 1
        strDyndata = [strDyndata, ' - Direct_Dynamics computed' ];
    end        
else
    strDyndata = sprintf('\n  INVALID dynamics data inserted');
end

%% assemble
NL = sprintf('\n');
str = [str, strTname, strTdata, strKin, strDyndata, NL];


end