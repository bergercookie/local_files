function Direct_Kinematics(manip)
% DIRECT_KINEMATICS evaluate direct kinematics of a manipulator object
%    syntax: manip.Direct_Kinematics
%
%  Evaluates: rotation matrices, homogeneous transformation matrices,
%             Jacobian matrices and stores them into manipulator as 
%             follows:
%
%  manip.kin
%       |
%       +--T
%       |  +-- Tb0: homogeneous transformation matrices from b-frame to 0-frame
%       |  +-- Tne: homogeneous transformation matrices from n-frame to e-frame
%       |  +-- Tbe: homogeneous transformation matrices from b-frame to e-frame
%       |  +-- T{1}..T{n}: homogeneous transformation matrices from 0-frame to i-frame
%       |
%       +--J
%       |  +-- J: geometric Jacobian matrix
%       |  +-- Jd: time-derivative of geometric Jacobian matrix
%       |
%       +--nsap: orientation-position matrix in a coloumn: [n;s;a;p]
%       |
%       +--R
%       |  +-- R{1}..R{n}: rotation matrices from 0-frame to i-frame
%       |
%       +--A
%          +-- A{1}..A{r}: homogeneous transformation matrices from
%          (i-1)-frame to i-frame 
%
%     See also manipulator
%              manipulator/pose
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


if manip.DH.r == 0
    manip.display;
    return
end

if manip.evaluated.Direct_Kinematics == 1
    NL = [char(13),char(10)]; % 'new line' string
    disp(['Direct Kinematics already evaluated ',NL,'Direct_Kinematics aborted.',NL]);
    return
end

% Initialization
DH=manip.DH.table;
r=manip.DH.r;
q = manip.jointvar.q;
qd = manip.jointvar.qd;
qdd = manip.jointvar.qdd;

A = cell(1,r);
T = cell(1,r);

p = cell(1,r);
z = cell(1,r);

R = cell(1,r);
J = sym(zeros(6,r));

Tb0 = manip.kin.T.Tb0;
Tne = manip.kin.T.Tne;

%% Evaluation of single homogeneous transformation matrices

for i=1:r
    Ai = [cos(DH(i,4)) -sin(DH(i,4))*cos(DH(i,2))  sin(DH(i,4))*sin(DH(i,2)) DH(i,1)*cos(DH(i,4));
        sin(DH(i,4))  cos(DH(i,4))*cos(DH(i,2)) -cos(DH(i,4))*sin(DH(i,2)) DH(i,1)*sin(DH(i,4));
        0             sin(DH(i,2))               cos(DH(i,2))              DH(i,3)             ;
        0             0                          0                         1                  ];

    A{i} = Ai;
end

%% Evaluation of T and the position of the end-effector frame

T{1} = A{1};
for i=2:r
    T{i} = T{i-1} * A{i};           % T(i) = T(i-1)*A(i);
end
Tbe = Tb0 * T{r} * Tne;

p0 = [0;0;0];
pe = T{r} * Tne; pe = pe(1:3,4);
% pe = Tbe(1:3,4);
z0  = [0;0;1];
ze = T{r} * Tne; ze = ze(1:3,3);


for i=2:r
    % Position vector of the origin of Frame i with respect to Frame 0
    p{i-1} = T{i-1}(1:3,4);
    % Unit vector z of Frame i with respect to Frame i-1
    z{i-1}  = T{i-1}(1:3,3);
end

manip.DH.p.p0=sym(p0);
manip.DH.p.pe=sym(pe);

manip.DH.z.z0=sym(z0);
manip.DH.z.ze=sym(ze);

for i=1:1:r-1
    manip.DH.p.p{i} = p{i};
end

for i=1:1:r-1
    manip.DH.z.z{i} = z{i};
end

manip.kin.T.Tbe = Tbe;
nsap = Tbe([1:3,5:7,9:11,13:15]).';
manip.kin.nsap = nsap;

%% Evaluation of the geometric Jacobian matrix

if( DH(1,5) == 1)
    % Prismatic joint
    J(1:3,1) = z0;
else
    % Revolute joint
    J(1:3,1) = cross(z0, (pe - p0));
    J(4:6,1) = z0;
end


for i=2:r
    if( DH(i,5) == 1)
        % Prismatic joint
        J(1:3,i) = z{i-1};
    else
        % Revolute joint
        J(1:3,i) = cross(z{i-1}, (pe - p{i-1}));
        J(4:6,i) = z{i-1};
    end
end

% evaluation of geometric Jacobian from 0-frame to b-frame
Ru = manip.kin.T.Tb0(1:3,1:3);
J = [Ru, zeros(3,3) ; zeros(3,3), Ru] * J;
manip.kin.J.J=J;

%% Evaluation of the analytical Jacobian matrix

% if ~exist('ph','var')
%     syms ph;
% end
% 
% if ~exist('th','var')
%     syms th;
% end
% 
% Tph_e = [0     -sin(ph)   cos(ph)*sin(ph);
%     0      cos(ph)   sin(ph)*sin(th);
%     1      0         cos(th)];
% 
% Ta = [eye(3)    zeros(3);
%     zeros(3)  Tph_e   ];
% 
% Ja = inv(Ta)*J;
% %    Ja = Ja(1:4,:);
% manip.kin.J.Ja=Ja;

% % ???
% Ja_or = analytic_jacobian(manip);                                                          %% DOES IT WORK???
% Ja = [J(1:3,:); Ja_or];
% manip.kin.J.Ja = Ja;


%% time-derivative of J

Jd = sym(zeros(6,r));
for i=1:6
    for j=1:r
        Jd(i,j) = jacobian(manip.kin.J.J(i,j),q) * qd.';
    end
end
manip.kin.J.Jd = Jd;

% Ja_d = sym(zeros(6,r));
% for i=1:4
%     for j=1:r
%         Ja_d(i,j) = jacobian(manip.kin.J.Ja(i,j),q) * qd.';
%     end
% end
% manip.kin.J.Ja_d = Ja_d;

if (manip.is_sym == 0) && ~strcmp(manip.name,'tmp')
    name = manip.name;
    sym_mat2func(manip.kin.J.Jd , qd, q , [name,'_Jd_qd'],10);
    eval(['manip.func.Jd_qd = @', name, '_Jd_qd;']);

    syms h1 h2 h3 h4 h5 h6;
    sym_mat2func(J.' , [h1 h2 h3 h4 h5 h6] , q , [name,'_Jt_he'],10);
    eval(['manip.func.Jt_he = @', name, '_Jt_he;']);

    sym_mat2func(J , qdd , q , [name,'_J_qdd'],10);
    eval(['manip.func.J_qdd = @', name, '_J_qdd;']);

    syms u1 u2 u3 u4 u5 u6;

%     % Transpose Jacobian m-file
%     sym_mat2func(Ja.' , [u1 u2 u3 u4 u5 u6] , q , [name,'_Jat_u'],10);
%     eval(['func.Jat_u = @', name, '_Jat_u;']);

    %     % Inverse Jacobian m-file
    %     sym_mat2func(inv(Ja) , [u1 u2 u3 u4 u5 u6] , robotdata.q , [robotdata.name,'_Jainv_u'],10);
    %     eval(['manip.func.Jainv_u = @', name, '_Jainv_u;']);

%     sym_mat2func(Ja , qd , q , [name,'_Ja_u'],10);
%     eval(['manip.func.Ja_u = @', manip.name, '_Ja_u;']);
% 
%     sym_mat2func(Ja_d , q , q , [name,'_Jad_u'],10);
%     eval(['manip.func.Jad_u = @', name, '_Jad_u;']);
    
    sym_mat2func(manip.kin.nsap , [], q , [name,'_nsap'],10);
    eval(['manip.func.nsap = @', name, '_nsap;']);
end

%% Rotation matrices of Frame i with respect to Frame 0

for i=1:r
    R{i} = T{i}(1:3,1:3);
end

manip.kin.R.R = R;


%% Simplify

if ( isnumeric(DH) == 0)
    for i=1:r
        manip.kin.A.A{i} = simple_(A{i});
        manip.kin.R.R{i} = simple_(manip.kin.R.R{i});
        manip.kin.T.T{i} = simplify(T{i});
    end

    for i=1:r-1
        manip.DH.p.p{i} = simple_(p{i});
        manip.DH.z.z{i} = simple_(z{i});
    end
    
%	manip.DH.p.p = p;
    
%    manip.kin.J.Ja = simple_(manip.kin.J.Ja);
    manip.kin.J.J = simplify(manip.kin.J.J);
    manip.DH.p.pe = simplify(pe);
    manip.kin.T.Tbe = simplify(Tbe);
end

manip.evaluated.Direct_Kinematics = 1;
assignin('caller',inputname(1),manip);

return
