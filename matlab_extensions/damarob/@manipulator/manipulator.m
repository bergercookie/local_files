classdef manipulator   
% MANIPULATOR constructor for manipulator class
%    syntax: manip = manipulator(DH,name,Tb0,Tne)
%
% Creates a manipulator object from:
% 
%   name:  string containing the name of the robot
% 
%     DH:  Denavit-Hartenberg table, including joint type and limits.
%          DH is a (r x 7) matrix as follows:
%            [a alpha d theta R/P min max]
%          Each row contains a link data. Note that R/P is a flag variable:
%                 R/P  = 0 indicates a revolute joint
%                 R/P != 0 indicates a prismatic joint
%          if no limits (min - max) is specified, range will be [-Inf, Inf]
%
%    Tb0: Homogeneous transformation matrix between b-frame and 0-frame
% 
%    Tne: Homogeneous transformation matrix between n-frame and e-frame
%           if not specified, Tb0 and Tne will be assumed identities
%
%     See also manipload
%              manipulator/drive_manip 
%              manipulator/InsertDyndata
%              manipulator/Direct_Kinematics
%              manipulator/Direct_Dynamics  
%              manipulator/plus
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


    %protected properties
    properties (SetAccess = 'protected', GetAccess = 'protected')
        is_sym;                             % flag: true if symbolic data robot
    end

    %read-only properties
    properties (SetAccess = 'protected')
        DH;                                 % struct containing: table,r,c,p,z
        name;                               % string: manipulator name
        jointvar;                           % struct (syms): q qp qpp: joint variables
        kin;                                % struct containing kinematics data
        dyn                                 % struct containing dynamics data
        evaluated;                          % struct: contains Direct_Kinematics and Direct_Dynamics flags
        func;                               % struct: handles of all m-functions
        vr_base;                            % vrworld: manipulator's wrl vr-object
        fig;                                % struct: handles of all figures
        dyndata;                            % flag: 1 means dynamic dataset ready
    end
    
    %public properties
    properties %(Dependent = 'true')
        % add here full access properties and be careful !!! ;)
        jointpos;			    % joint position (also used for 3d animation)
    end

    methods
%% CONSTRUCTORS
        function manip = manipulator(DH,name,Tb0,Tne)
            global LatexSymbolTable; %#ok<NUSED>
            evalin('base', 'global LatexSymbolTable');

%% void input: constructor
            if nargin == 0
                manip.DH = [];
                manip.DH.r = 0;
                return
            end

%% incomplete data
            if nargin == 2                                                  %  no Tb0 Tne specified
                Tb0 = eye(4);
                Tne = eye(4);
                Tb0Tne_added = 1;  %#ok<NASGU> it's ok: it's in nargin couunt
            end

            if (size(DH) * [0;1]) == 5                                      % no limits specified: 5 coloumns: a alpha d theta R/P
                DH(:,6:7) = ones(size(DH)*[1;0],1) * [-inf +inf];
            end

%% manipulator in input: no constructor,copy manipulator
            if isa(DH,'manipulator')
                manip = DH;            
            
%% error in input data
            elseif (nargin ~= 4) && ~isvarname('Tb0Tne_added')                  % not enough inputs
                sprintf('\n       %s\n', 'manipulator: SYNTAX');
                help manipulator;
                error(' please specify DH and manipulator name ');

            elseif ~isvarname(name)
                disp(' ');
                disp(['   The string: ''',name,''' is not a valid manipulator name.']);
                disp('   A valid manipulator name is a character string of letters, digits and');
                disp('   underscores, with length <= namelengthmax, the first character a letter,');
                disp('   and the name is not a keyword.');
                disp(' ');
                error('    Please specify a valid manipulator name.');

            elseif (Tb0(4,4) ~= 1) || (Tne(4,4) ~= 1) || ...               %Tb0 or Tne not valid homogeneous transformation matrix:
                    (sum(sum(Tb0(1:3,1:3)  * Tb0(1:3,1:3).' ~= eye(3))) == 9) ||...
                    (sum(sum(Tne(1:3,1:3)  * Tne(1:3,1:3).' ~= eye(3))) == 9)
                help manipulator;
                error(' Tb0 or Tne is not a valid homogeneous transformation matrix:');

            elseif  (size(DH) * [0;1]) ~= 7 && ~isempty(DH)                            % wrong n.coloumns
                sprintf('\n       %s\n', 'manipulator: SYNTAX') ;
                help manipulator;
                error('\n    %s\n        %s', 'please insert all and only these 7 parameters in DH table: ', 'a alpha d theta RP min max ');

            elseif ~isempty(DH) && ~isreal( DH(:,6:7) ) && ~isreal( eval(DH(:,6:7)) )   % symbolic limits
                sprintf('\n       %s\n', 'manipulator: SYNTAX');
                help manipulator;
                error('\n    %s\n        %s', 'please specify numeric limits');


            elseif  ~isempty(DH) && ~isreal( DH(:,5) )                                  % symbolic limits
                sprintf('\n       %s\n', 'manipulator: SYNTAX');
                help manipulator;
                error('\n    %s\n        %s', 'error in joint types P/R');

%% standard constructor
            else
                r = size(DH) * [1; 0];                 % number of links
                manip.dyndata = 0;
                manip.evaluated = struct('Direct_Kinematics',0,'Direct_Dynamics',0);
                manip.DH = struct;
                manip.DH.table = sym(DH);
                manip.DH.r = r;
                manip.DH.p = struct('p0',sym,'pe',sym);
                manip.DH.p.p = cell(1,r-1);
                manip.DH.z = struct('z0',sym,'ze',sym);
                manip.DH.z.z = cell(1,r-1);

                manip.name = name;

                % This section initializes symbolic and latex variables by creating the
                % LatexSymbolTable struct.
                if ~isempty(manip.DH.table) 
                    rp = manip.DH.table(:,5);
                else
                    q = [];
                    q_d = [];
                    q_dd = [];
                    
                end
                for h = 1:manip.DH.r
                    i = num2str(h);
                    if rp(h) == 0
                        eval(['syms th' i ' th' i '_d' ' th' i '_dd;']);
                        eval(['theta(' i ') = th' i ';']);
                        eval(['q(' i ') = th' i ';']);
                        eval(['q_d(' i ') = th' i '_d;']);
                        eval(['q_dd(' i ') = th' i '_dd;']);
                        eval(['LatexSymbolTable.th' i '.sym = ''th' i ''';']);
                        eval(['LatexSymbolTable.th' i '.tex = ''\theta_' i ''';']);
                        eval(['LatexSymbolTable.th' i '_d.sym = ''th' i '_d'';']);
                        eval(['LatexSymbolTable.th' i '_d.tex = ''\dot{\theta_' i '}'';']);
                        eval(['LatexSymbolTable.th' i '_dd.tex = ''\ddot{\theta_' i '}'';']);
                        eval(['LatexSymbolTable.th' i '_dd.sym = ''th' i '_dd'';']);
                        manip.DH.table(h,4) = q(h);
                    else
                        manip.DH.table(h,5) = 1;
                        eval(['syms d' i ' d' i '_d' ' d' i '_dd;' ]);
                        eval(['d(' i ') = d' i ';']);
                        eval(['q(' i ') = d' i ';'])
                        eval(['q_d(' i ') = d' i '_d;']);
                        eval(['q_dd(' i ') = d' i '_dd;']);
                        eval(['LatexSymbolTable.d' i '.sym = ''d' i ''';']);
                        eval(['LatexSymbolTable.d' i '.tex = ''d_' i ''';']);
                        eval(['LatexSymbolTable.d' i '_d.sym = ''d' i '_d'';']);
                        eval(['LatexSymbolTable.d' i '_d.tex = ''\dot{d_' i '}'';']);
                        eval(['LatexSymbolTable.d' i '_dd.sym = ''d' i '_dd'';']);
                        eval(['LatexSymbolTable.d' i '_dd.tex = ''\ddot{d_' i '}'';']);
                        manip.DH.table(h,3) = q(h);
                    end
                end

                % look for symbolic data
                if ~isempty(manip.DH.table) 
                is_manip_numeric = isreal(vpa(DH(:,1:2),2)) && ...
                    isreal(DH(:,4) .* DH(:,5)) && ...
                    isreal(DH(:,3) .* (1 - DH(:,5))) && ...
                    isreal(vpa(Tb0)) && ... 
                    isreal(vpa(Tne)) ;
                else
                    is_manip_numeric = isreal(vpa(Tb0)) && isreal(vpa(Tne));
                end

%% standard constructor [assign values]
                manip.is_sym = ~is_manip_numeric;
                manip.jointvar = struct;
                manip.jointvar.q = q;
                manip.jointvar.qd = q_d;
                manip.jointvar.qdd = q_dd;
                manip.kin = struct('T', struct('Tb0',Tb0,'Tne',Tne), ...
                    'J', struct('J',sym,'Jd',sym,'Jp_l',sym,'Jo_l',sym,'Jp_m',sym,'Jo_m',sym));
                manip.dyn = struct;
                manip.vr_base = vrworld();
                manip.fig.vr = vrfigure();
                
                if (manip.is_sym == 0)&& ~strcmp(manip.name,'tmp') && ~isempty(manip.DH.table)
                    manip.jointpos= zeros(1,manip.DH.r);
                    [fx fy fz] = ee_postn(manip);
                    manip.func.x = fx;
                    manip.func.y = fy;
                    manip.func.z = fz;
                    [manip.fig.vr, manip.vr_base] = createVR(manip);
                end
            end
        end     %end CONSTRUCTOR
         
%% function: set.jointpos(manip,value)
function manip = set.jointpos(manip,value)
    if manip.is_sym == 0
        oldpos = manip.jointpos;
        manip.jointpos = value;

        offset = double((manip.DH.table(:,5)*0.5)).'; %#ok<NASGU>                                     % CORRECT OFFSET HERE

        % draw 3D if someone has closed the window
        if ~isvalid(manip.fig.vr) && isvalid(manip.vr_base)
            if ~isopen(manip.vr_base)
                open(manip.vr_base)
            end
            manip.fig.vr = view(manip.vr_base);
        end

        if ~isempty(oldpos) % && ~isempty(find(oldpos - manip.jointpos, 1))
            %                joint = find(oldpos - manip.jointpos);
            joint = 1:1:manip.DH.r;
            for j = joint
                if manip.DH.table(j,5) == 0                         % revolute joint
                    eval(['manip.vr_base.Z', num2str(j-1), '.rotation = [0 0 1 value(j)-offset(j)];']);
                else                                                    % prismatic joint
                    eval(['manip.vr_base.Link', num2str(j), '.translation = [0 0 value(j)-offset(j)];']);
                end
            end
        end
    else
        disp(' Unable to drive or show a symbolic manipulator');
        manip = manipulator;
    end
end
     
%% DESTRUCTOR
function delete(manip)
    if manip.DH.r == 0
        objname = inputname(1);
        evalin('caller',['clear ',objname]);
        return
    end
    
    if isfield(manip.fig,'manmov')
        if ishandle(manip.fig.manmov.mainfig)
            close(manip.fig.manmov.mainfig)
        end
    end
    
    try
        if isfield(manip.fig,'vr')
            if isvalid(manip.fig.vr)
                close(manip.fig.vr)
            end
        end
    catch %#ok<CTCH>
        disp('  warning: unable to close VR figure');        
    end
    if isvalid(manip.vr_base)
        close(manip.vr_base)
        try
            delete(manip.vr_base)
        catch  %#ok<CTCH>
            disp('  warning: unable to delete an open VR World');            
        end
    end
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
    objname = inputname(1);
    evalin('caller',['clear ',objname]);

    function delete_file(namefile)
        if exist([pwd,'/',namefile],'file')
            delete(namefile);
        end
    end
end
    end% methods
end% classdef
