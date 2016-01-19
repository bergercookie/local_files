function InsertDyndata(manip,value)
% INSERTDYNDATA inserts dynamic data into a manipulator object
%    syntax: manip.InsertDyndata(dyndata)
% 
%    where dyndata is a struct containing these fields:
%
%    dyndata
%       |
%       +--g0 [gx; gy; gz] --> gravity in 0-frame
%       +--ml [1 .. r] --> links' masses
%       +--mm [1 .. r] --> rotors' masses
%       +--kr [1 .. r] --> motorgears' ratios
%       +--zm {1 .. r} --> motor axes expressed in [i-frame]
%       +--Il {1 .. r} --> links' mass moments of inertia [i-frame]
%       +--Im {1 .. r} --> motors' mass moments of inertia
%       +--Fv  [rxr]   --> joints' viscous frictions
%       +--Fm  [rxr]   --> motors' viscous frictions
%       +--pl {1 .. r} --> position of center of mass of the
%       |                  i-link with respect to i-frame
%       +--pm {1 .. r} --> position of motors with respect to the
%                          previous joint axes
%
%   Please note:
%   Il{i} is a 3x3 matrix
%   Im{i} is a 3x3 matrix
%   pl{i} is a 3x1 column vector
%   pm{i} is a 3x1 column vector
%   zm{i} is a 3x1 column vector
%
%     See also manipulator
%              manipulator/Direct_Dynamics
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
    disp('Incorrect input arguments number, See help for more details')
    help manipulator/InsertDyndata
    return
end
r = manip.DH.r;
if r==0 && isfield(manip.DH,'table')
    disp(' Unable to insert joints data for a manipulator without joints');
    return
end

% errors struct:
%   0 = not checked
%   1 = correct value
%  -1 = not-existent field
%  -2 = error in field
errors = struct('g0',0,'ml',0,'mm',0,'pl',0,'pm',0,'Il',0,'Im',0,'kr',0,'Fm',0,'Fv',0,'zm',0);

% data dimension error conditions
condition_g0 = 'length(value.g0) > 3 || length(value.g0) < 3 || ~isvector(value.g0)';
condition_ml = 'length(value.ml) > r || length(value.ml) < r || ~isvector(value.ml)';
condition_mm = 'length(value.mm) > r || length(value.mm) < r || ~isvector(value.mm)';
condition_pl = 'iscell(value.pl) && (length(value.pl) > r || length(value.pl) < r)';
condition_pm = 'iscell(value.pm) && (length(value.pm) > r || length(value.pm) < r)';
condition_Il = 'iscell(value.Il) && (length(value.Il) > r || length(value.Il) < r)';
condition_Im = 'iscell(value.Im) && (length(value.Im) > r || length(value.Im) < r)';
condition_kr = 'length(value.kr) > r || length(value.kr) < r || ~isvector(value.kr)';
condition_Fm = 'prod(double(size(value.Fm) ~= [r r]))';
condition_Fv = 'prod(double(size(value.Fv) ~= [r r]))';
condition_zm = 'iscell(value.zm) && (length(value.zm) > r || length(value.zm) < r)';

errors = checkvalue(value,'g0',errors,condition_g0,r);
errors = checkvalue(value,'ml',errors,condition_ml,r);
errors = checkvalue(value,'mm',errors,condition_mm,r);
errors = checkvalue(value,'pl',errors,condition_pl,r);
errors = checkvalue(value,'pm',errors,condition_pm,r);
errors = checkvalue(value,'Il',errors,condition_Il,r);
errors = checkvalue(value,'Im',errors,condition_Im,r);
errors = checkvalue(value,'kr',errors,condition_kr,r);
errors = checkvalue(value,'Fm',errors,condition_Fm,r);
errors = checkvalue(value,'Fv',errors,condition_Fv,r);
errors = checkvalue(value,'zm',errors,condition_zm,r);

% look for missing fields
index = (struct2array(errors) == -1);
fields_name = {'g0','ml','mm','pl','pm','Il','Im','kr','Fm','Fv','zm'};
if ~isempty(fields_name(index))
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp(' ERROR : Following fields missing:');
    disp(fields_name(index));
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

% look for errors in data (dimensions)
if errors.g0 == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp(' ERROR : The field g0 (gravity in 0-frame) must be a vector of three elements');
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

if errors.ml == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field ml (links'' masses) must be a vector of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

if errors.mm == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field mm (rotors'' masses) must be a vector of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

if errors.pl == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field pl (joint''s COM positions) must be a cell of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
else
    if errors.pl == 1
        for i = 1:length(value.pl)
            if length(value.pl{i}) ~= 3 || ~isvector(value.pl{i})
                %   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                disp([' ERROR : Element ' num2str(i) ' of pl cell is not a vector of three elements']);
                disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                errors.pl = -2;
            end
        end
    end
end

if errors.pm == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field pm (rotors'' COM positions) must be a cell of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
else
    if errors.pm == 1
        for i = 1:length(value.pm)
            if length(value.pm{i}) ~= 3 || ~isvector(value.pm{i})
                %   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                disp([' ERROR : Element ' num2str(i) ' of pm cell is not a vector of three elements']);
                disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
            end
        end
    end
end

if errors.Il == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field Il (joints'' inertia tensor) must be a cell of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
else
    if errors.Il == 1
        for i = 1:length(value.Il)
            if sum(double(size(value.Il{i}) ~= [3 3]))
                %   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                disp([' ERROR : Element ' num2str(i) ' of Il cell is not a 3x3 matrix']);
                disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                errors.Il = -2;
            end
        end
    end
end

if errors.Im == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field Im (rotors'' inertia tensor) must be a cell of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
else
    if errors.Im == 1
        for i = 1:length(value.Im)
            if sum(double(size(value.Im{i}) ~= [3 3]))
                %   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                disp([' ERROR : Element ' num2str(i) ' of Im cell is not a 3x3 matrix']);
                disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                errors.Im = -2;
            end
        end
    end
end

if errors.kr == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field kr (motorgear ratios) must be a vector of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

if errors.Fv == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field Fv (joints viscous friction) must be a [' num2str(r) 'x' num2str(r) '] matrix']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

if errors.Fm == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field Fm (motors viscous friction) must be a [' num2str(r) 'x' num2str(r) '] matrix']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end

if errors.zm == -2
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp([' ERROR : The field zm (rotors'' axes) must be a cell of ' num2str(r) ' elements']);
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
else
    if errors.zm == 1
        for i = 1:length(value.zm)
            if length(value.zm{i}) ~= 3 || ~isvector(value.zm{i})
                %   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                disp([' ERROR : Element ' num2str(i) ' of zm cell is not a vector of three elements']);
                disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
            end
        end
    end
end

% no errors occurred
if prod(double(struct2array(errors) == 1))
    value.g0 = value.g0(:);
    value.ml = value.ml(:).';
    value.kr = value.kr(:).';

    for i=1:1:r
        value.pl{i} = value.pl{i}.';
        value.pm{i} = value.pm{i}.';
        value.zm{i} = value.zm{i}.';
    end

    if isempty(struct2cell(manip.dyn))
        old_data = [];
    else
        old_data = manip.dyn.data;
    end

    manip.dyn = struct('data', value  );
    manip.dyndata = 1;

    if ~compare_dyndata(old_data, value)
        manip3.evaluated.Direct_Dynamics = 0;
    end
    
    
    
    assignin('caller',inputname(1),manip);
end

end

%% Function checkvalue
function errors = checkvalue(value,field,errors,condition,r) %#ok<INUSD>
if isfield(value,field)
    if eval(condition)
        errors.(field) = -2;
    else
        errors.(field) = 1;
    end
else
    errors.(field) = -1;
end
end

%% Function compare_dyndata: compare all dyndata fields but Fm and Fv
function res = compare_dyndata(data1, data2)
if ~isstruct(data1) || ~isstruct(data2)
    res = 0;
else %assuming that data1 and data2 are correct dyndata structures
    res = zeros(1,9);
    for i = {'g0','ml','mm','pl','pm','Il','Im','kr','zm'};
        res(i) = data1.(i) == data2.(i);
    end
    res = prod(res);
end
end
