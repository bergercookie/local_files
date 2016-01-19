function manipload(varargin)
% MANIPLOAD load manipulator(s) from file
%    syntax: manipload FILENAME
%            manipload FILENAME x
%            manipload FILENAME x y z
%
%    examples:
%            manipload FILENAME       -- load all variables stored in FILENAME
%            manipload FILENAME x y z -- load only x y z from FILENAME
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

if nargin == 0
    help manipload;
    return
end

list = whos('-file', varargin{1});
n = length(list);
num = length(varargin);

for i=1:1:n    
    if strcmp(list(i).class, 'manipulator')
        if num == 1
            evalin('caller',['load ',varargin{1}, ' ',list(i).name ]);
            evalin('caller',[list(i).name,'.updateFiles;' ]);
        end
        for j=2:1:num
            if strcmp(list(i).name, varargin{j})
                evalin('caller',['load ',varargin{1}, ' ',list(i).name ]);
                evalin('caller',[list(i).name,'.updateFiles;' ]);
            end
        end
    end
end

return