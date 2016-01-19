function Direct_Dynamics(manip)
% DIRECT_DYNAMICS evaluates direct dynamics of a manipulator object
%    syntax: manip.Direct_Dynamics
%
%  Evaluates: dynamic matrices B C g
%             Jacobian matrices related to rotors' and joints' COM position
%             and stores them into manipulator as follows:
%
%     manip
%       |
%       +--dyn
%       |   +--B: manipulator inertia matrix
%       |   +--C: Coriolis and centripetal matrix (christoffeln)
%       |   +--g: gravity coloumn vector
%       |
%       +--kin
%       |   +-- Jp_l{1}..Jp_l{n}: geometric Jacobian matrix related to joints' COM position
%       |   +-- Jo_l{1}..Jo_l{n}: geometric Jacobian matrix related to joints' COM orientation
%       |   +-- Jp_m{1}..Jp_m{n}: geometric Jacobian matrix related to rotors' COM position
%       |   +-- Jo_m{1}..Jo_m{n}: geometric Jacobian matrix related to rotors' COM orientation
%
%
%    needs:
%       * direct kinematics evaluation through Direct_Kinematics.
%       * a correct set of dynamic data (masses, inertia tensors ...)
%         inserted through InsertDyndata,
%
%    note : COM stands for 'center of mass'
% 
%     See also manipulator
%              manipulator/InsertDyndata
%              manipulator/Direct_Kinematics
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

%% check data
if isempty(manip.dyndata) || manip.dyndata ~= 1
    NL = [char(13),char(10)]; % 'new line' string
    disp(['Dynamic Data not inserted correctly, see manipulator.dyndata ',NL,'Direct_Dynamics aborted.',NL]);
    return
end

if manip.DH.r == 0
    manip.display;
    return
end

if manip.evaluated.Direct_Dynamics == 1
    NL = [char(13),char(10)]; % 'new line' string
    disp(['Direct Dynamics already evaluated ',NL,'Direct_Dynamics aborted.',NL]);
    return
end

if manip.evaluated.Direct_Kinematics == 0
    NL = [char(13),char(10)]; % 'new line' string
    disp(['Direct Kinematics not evaluated ',NL,'Please run Direct_Kinematics first.',NL]);
    return    
end


%% Some initializations
g0 = manip.dyn.data.g0(:);
r = manip.DH.r;
DH = cell(1,r);
Jp_l = cell(1,r);
Jo_l = cell(1,r);
Jp_m = cell(1,r);
A = cell(1,r);
R = cell(1,r);
Rm = cell(1,r);
B = sym(zeros(r,r));
C = sym(zeros(r,r));
chr = sym(zeros(r,r,r));
g = sym(zeros(r,1));
% T = cell(1,r);

pl = manip.dyn.data.pl;
pm = manip.dyn.data.pm;
kr = manip.dyn.data.kr;
ml = manip.dyn.data.ml;
mm = manip.dyn.data.mm;
I_l = manip.dyn.data.Il;
I_m = manip.dyn.data.Im;
zm = manip.dyn.data.zm;

% coloumn vectors
for i=1:r
    pl{i} =  pl{i}(:);
    pm{i} =  pm{i}(:);
    zm{i} =  zm{i}(:);
end

% store manipulator's data into cell arrays
for i=1:r
    R{i} = manip.kin.R.R{i}; %R{i} = R_i
    %    T{i} = manip.kin.T.T{i}; %T{i} = T_i
    A{i} = manip.kin.A.A{i}; %A{i} = A_i
    % note that A_i is the homogeneous transformation matrix between frames i and i-i
end

%% Jacobian matrices of center of masses
disp('Evaluating jacobian matrices of center of masses ...');
for i=1:r
    DH{i} = manip.DH.table(1:i , :);    %firsts 'i' rows of DH table
    if DH{i}(i,5) == 0 % revolute joint
        DH{i}(i,1) = DH{i}(i,1) + [1 0 0]*pl{i};  % adds pl_i|x to a(i)
    else               % prismatic joint
        DH{i}(i,3) = [0 0 1 0] * A{i}*[pl{i};1];  %adds (l_i^(i-1))_z to d(i)
    end

    robtemp = manipulator([DH{i}(:,1),DH{i}(:,2),DH{i}(:,3),DH{i}(:,4),DH{i}(:,5)],'tmp');
    robtemp.Direct_Kinematics;

    Jli = [robtemp.kin.J.J zeros(6,r-i)];
    Jp_l{i} = Jli(1:3,:);
    Jo_l{i} = Jli(4:6,:);
    robtemp.delete;
end


% (store)
manip.kin.J.Jp_l=Jp_l;
manip.kin.J.Jo_l=Jo_l;

%% Jacobian matrices of motors

disp('Evaluating jacobian matrices of motors ...');
% Orientation
Jo_m = Jo_l;
for i=1:r
    Jo_m{i}(:,i) = kr(i)*R{i}*zm{i};
end

Jp_m{1} = 0*Jp_l{1}; % init
% Position
for i=1:r-1
    DH{i} = manip.DH.table(1:i , :);    %firsts 'i' rows of DH table
    if DH{i}(i,5) == 0 % revolute joint
        DH{i}(i,1) = DH{i}(i,1) + [1 0 0]*pm{i+1};  % adds pm_(i+1)|x to a(i)
    else               % prismatic joint
        %adds (pm_(i+1)^(i-1))_z to d(i)
        DH{i}(i,3) = [0 0 1 0] * A{i}*[pm{i+1};0];
    end

    %     robtemp = Denavit_Hartenberg_Table(DH{i}(:,1).', ...
    %         DH{i}(:,2).',DH{i}(:,3).',DH{i}(:,4).',DH{i}(:,5).');
    %     robtemp = Direct_Kinematics(robtemp);
    robtemp = manipulator([DH{i}(:,1),DH{i}(:,2),DH{i}(:,3),DH{i}(:,4),DH{i}(:,5)],'tmp');
    robtemp.Direct_Kinematics;

    Jmip1 = [robtemp.kin.J.J zeros(6,r-i)];
    Jp_m{i+1} = Jmip1(1:3,:);
    robtemp.delete;
end


% (store)
manip.kin.J.Jp_m=Jp_m;
manip.kin.J.Jo_m=Jo_m;

%% Rotor's rotation matrices

disp('Evaluating rotor''s rotation matrices ...');
%   Rm matrices will be:
% [ 0 0  | ]
% [ 0 0 zm ]
% [ 0 0  | ]
% where first two columns will be two vectors orthonormal to zm

for i=1:r
    zmi = R{i}*zm{i} / norm(zm{i});      % zmi in 0-frame, normalized
    ymi = cross(zmi,rand(3,1));  % pseudorandom vector, perpendicular to zm
    norm_ymi = (ymi.'*ymi)^(1/2);
    ymi = ymi/norm_ymi;                        % ymi orthonormal to zm
    xmi = cross(ymi,zmi);                        % xmi
    Rm{i} = [xmi, ymi, zmi];
end

%% Dynamics Matrices

disp('Evaluating dynamics matrices ...');
% B
for i=1:r
    B = B + ml(i) * (Jp_l{i}.' * Jp_l{i}) + ...
        (Jo_l{i}.' *R{i} *I_l{i} *R{i}.'  * Jo_l{i}) + ...
        mm(i) * Jp_m{i}.' * Jp_m{i} + ...
        (Jo_m{i}.' *Rm{i} *I_m{i} *Rm{i}.'  * Jo_m{i}) ;
end
disp ('  B');

% christoffel's signs (C)
for i=1:r
    for j=1:r
        for k=1:r
            chr(i,j,k) = 1/2* ( diff(B(i,j), manip.jointvar.q(k)) + ...
                diff(B(i,k), manip.jointvar.q(j)) - ...
                diff(B(j,k), manip.jointvar.q(i)));
        end
    end
end

% C
for i=1:r
    for j=1:r
        for k=1:r
            C(i,j) = C(i,j) + chr(i,j,k) * manip.jointvar.qd(k);
        end
    end
end
disp ('  C');

% -g
for i=1:r
    for j=1:r
        g(i) = g(i) + ml(j) * g0.' * Jp_l{j}(:,i)  + mm(j) * g0.' * Jp_m{j}(:,i);
    end
end
disp ('  g');

disp (' simplifying expressions');
manip.dyn.B = simple_(B);
disp ('  B simplified');
manip.dyn.C = simple_(C);
disp ('  C simplified');
manip.dyn.g = simple_(-g);
disp ('  g simplified');

% symbolic data robot:
% future versions should calculate Y matrix, piv vector
if manip.is_sym || (isa(manip.dyn.data.Il,'sym') || ...
        isa(manip.dyn.data.Im ,'sym') || ...
        isa(manip.dyn.data.ml ,'sym') || ...
        isa(manip.dyn.data.mm ,'sym') || ...
        isa(manip.dyn.data.pl ,'sym') || ...
        isa(manip.dyn.data.pm ,'sym'))
    disp('symbolic data robot, no function files generated');
else

    % numeric data robot
    % generate functions for simulation
    disp('numeric data robot: generating function files ...');

%     disp ('  calculating inv(B)');
%     invB = inv(B);
% 
%     disp ('  simplifying inv(B)');
%     invB = simple_(invB);
%     manip.dyn.invB = invB;


    % generate symbolic variables tau_1 .. tau_r
%     tau = cell(1,r);
%     for i=1:1:r
%         i_str = num2str(i);
%         eval(['syms tau_', i_str, ';']);
%         eval(['tau{i} = tau_', i_str, ';']);
%     end
%     tau_v = horzcat(tau{:});

    % write function file
%     sym_mat2func(manip.dyn.invB , tau_v, manip.jointvar.q ,...
%         [manip.name,'_invB_tau'],30);
%     eval(['manip.func.invB_tau = @', manip.name, '_invB_tau;']);

    sym_mat2func(manip.dyn.B(:) , [], manip.jointvar.q ,...
        [manip.name,'_B_matrix'],30);
    eval(['manip.func.B_matrix = @', manip.name, '_B_matrix;']);


    sym_mat2func(manip.dyn.B , manip.jointvar.qdd, manip.jointvar.q ,...
        [manip.name,'_B_qdd'],30);
    eval(['manip.func.B_qdd = @', manip.name, '_B_qdd;']);


    sym_mat2func(manip.dyn.C , manip.jointvar.qd, ...
        [manip.jointvar.q manip.jointvar.qd] ,[manip.name,'_C_qd'],30);
    sym_mat2func(manip.dyn.g, [] , [manip.jointvar.q] ,[manip.name,'_g'],30);

    eval(['manip.func.C_qd = @', manip.name, '_C_qd;']);
    eval(['manip.func.g = @', manip.name, '_g;']);
    disp ('  functions created. ');
    disp ('  Execution Completed. ');
end

manip.evaluated.Direct_Dynamics = 1;
assignin('caller',inputname(1),manip);

return
