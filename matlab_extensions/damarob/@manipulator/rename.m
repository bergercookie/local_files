function manip = rename(manip,newname)

% RENAME renames manipulator objects.
%    syntax:
%          manip.rename('newname')
%
% Changes manipulator name to 'newname', also rename function files
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
    error('    syntax:  manip.rename(''newname'') ');
end

if ~isvarname(newname)
    disp(' ');
    disp(['   The string: ''',newname,''' is not a valid manipulator name.']);
    disp('   A valid manipulator name is a character string of letters, digits and');
    disp('   underscores, with length <= namelengthmax, the first character a letter,');
    disp('   and the name is not a keyword.');
    disp(' ');
    error('    Please specify a valid manipulator name.');
end

close(manip.vr_base)
delete(manip.vr_base)

delete_file([manip.name,'VR_base.wrl']);
delete_file([manip.name,'_Jd_qd.m']);
delete_file([manip.name,'_J_qdd.m']);
delete_file([manip.name,'_Jt_he.m']);
delete_file([manip.name,'_B_qdd.m']);
delete_file([manip.name,'_B_matrix.m']);
delete_file([manip.name,'_C_qd.m']);
delete_file([manip.name,'_g.m']);
delete_file([manip.name,'_nsap.m']);
delete_file([manip.name,'VR_base.wrl']);
delete_file([manip.name,'_3D.png']);

manip.name = newname;
manip.updateFiles;

assignin('caller',inputname(1),manip);
end

%% subfunctions
function delete_file(namefile)
if exist([pwd,'/',namefile],'file')
    delete(namefile);
end
end