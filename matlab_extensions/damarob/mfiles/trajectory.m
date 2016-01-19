function pathd = trajectory(Ts,startpoint,startorient,orient_type,varargin)
% TRAJECTORY generates a trajectory in the operational space. The
% manipulator is initialized in an arbitrary configuration q0 in the joint
% space. Initial pose in operational space is given by applying the
% direct kinematics function to q0.
%
% syntax:
%      pathd = trajectory(Ts,startpoint,startorient,orient_type,varargin)
% 
% For each given input (varargin), a path is generated between two
% consecutive inputs, based on the specified path type. Inputs are structs in
% the form:
%
%  Rectilinear path
%
%   input.g --> goal point (column vector)
%   input.tf --> time to reach goal point (seconds)
%   input.path_type = 'r' --> specifies the type of path (rectilinear)
%   input.via --> point is via point (1) or not (0)
%
%  Circular path
%
%   input.g --> goal point (column vector)
%   input.tf --> time to reach goal point (seconds)
%   input.path_type = 'c' --> specifies the type of path (circular)
%   input.thf --> radians to be sweeped by the position vector
%   input.c --> centre of the circle
%   input.z --> axis of rotation
%   input.via --> point is via point (1) or not (0)
%
%  Other inputs are:
%
%   Ts --> sampling time
%   startpoint --> initial end-effector position (operational space)
%   startorient --> initial end-effector orientation (ZYZ Euler angles)
%   orient_type --> specifies which kind of representation is used to
%                   define orientation ('euler' for ZYZ or ZYX Euler 
%                   angles, 'aa' for axis/angle). Every input should use 
%                   the same type of representation.
%   
%  Orientation is specified by:
%
%   input.orient --> this can be a three component vector (for ZYX or ZYZ
%                    Euler angles) or a four component one (for axis/angle
%                    representation).
%
%  The output will be in the form of a struct, containing these variables:
%
%   pos, pos_d, pos_dd --> position, velocity and acceleration
%   orient, orient_d, orient_dd --> orientation (in Euler angles or
%                                   axis/angle representation) and it's
%                                   first and second derivative
%   w, w_d --> angular velocity and it's first derivative
%
%  Note: future versions of this program will include the possibility of
%  specifying orientation using unit quaternions and other combinations of
%  Euler angles.
%
% Copyright (C) 2009, by Carmine Dario Bellicoso and Marco Caputano.
% This file is part of Dario & Marco's Robotics Symbolic Toolbox for Matlab (DAMA^{ROB}).
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

%% Initialization

% This section initializes variables used in the function
startpoint = startpoint(:);         % column vectors
startorient = startorient(:);
r = nargin-4;                       % number of points (with the exception of the start point)
pose = cell(1,r);                   % structs containing input information
ts = cell(1,r);                     % time values
Dt = cell(1,r);                     % time advances for via points

%% Inizialization of all poses

pose{1}.g = startpoint;
pose{1}.orient = startorient;
pose{1}.tf = 0;                   % generation of the trajectory starts from pose{1}
pose{1}.via = 0;
ts{1} = pose{1}.tf;
pose{1}.orient_type = orient_type;

for i=1:r
 pose{i+1} = varargin{i};
 ts{i+1} = ts{i}+pose{i+1}.tf;
end

pose{end}.via = 0; % First and last points are not via points
Dt{1} = 0;

%% Check for errors in caller function

if ~strcmp(orient_type,'ZYZ euler') && ~strcmp(orient_type,'ZYX euler') && ~strcmp(orient_type,'aa')
        disp('');
        disp(' ERROR : Check input orient_type in caller function. It must be ''ZYZ euler'', ''ZYX euler'' or ''aa''.');
        disp('');
        pathd = struct([]);
        return
end

for i=1:(r+1)
  if  pose{i}.via == 0  
    if (strcmp(orient_type,'ZYZ euler') || strcmp(orient_type,'ZYX euler')) && ~(length(pose{i}.orient)==3)
        disp('');
        if i == 1
            disp(' ERROR : Orientation choosed is Euler angles. Please check input ''startorient'' in caller function.');
        else
            disp([' ERROR : Orientation choosed is Euler angles. Please check point number ' num2str(i-1) '.']);
        end
        disp('');
        pathd = struct([]);
        return
    elseif strcmp(orient_type,'aa') && ~(length(pose{i}.orient)==4)
        disp('');
        if i == 1
            disp(' ERROR : Orientation choosed is axis/angle. Please check input startorient in caller function');
        else
            disp([' ERROR : Orientation choosed is axis/angle. Please check point number ' num2str(i-1) '.']);
        end
        disp('');
        pathd = struct([]);
        return
    end
  end
end

%% Computation of time advances for via points

% Time advance will be 20% of actual length
for i=1:(r+1)
    Dt{i+1} = Dt{i} + ( 0.2 * pose{i}.tf - mod(0.2*pose{i}.tf,Ts) ) * pose{i}.via;
end

%% Assignment and initialization of other variables

tN = ts{end}-Dt{end};                         % real time length of the generated trajectory
t = 0:Ts:tN;                                  % time vector
n_samples = size(0:Ts:tN)*[0;1];              % number of discrete samples
pos = zeros(3,n_samples);
pos_d = zeros(3,n_samples);
pos_dd = zeros(3,n_samples);
ph_e.euler = zeros(3,n_samples);
ph_e_d.euler = zeros(3,n_samples);
ph_e_dd.euler = zeros(3,n_samples);
ph_e.quat = zeros(4,n_samples);
ph_e_d.quat = zeros(4,n_samples);
ph_e_dd.quat = zeros(4,n_samples);
w = [];
w_d = [];
ph_e.aa = [];

%% Path generation

   % Position trajectory planning
     for i=1:r
         if pose{i+1}.path_type == 'r'
               [pos,pos_d,pos_dd] = ...
                                     rectpath(pose{i},pose{i+1},pos,pos_d,pos_dd,ts{i},ts{i+1},Dt{i+1},Ts,tN,n_samples);
         elseif pose{i+1}.path_type == 'c'
               [pos,pos_d,pos_dd,pose{i+1}] = ...
                                     circpath(pose{i},pose{i+1},pos,pos_d,pos_dd,ts{i},ts{i+1},Dt{i+1},Ts,tN,n_samples,startpoint);
         end
     end

   % Update total position, velocity and acceleration matrices. Position
   % matrix needs the initial pose
     pos = (pose{1}.g*ones(1,n_samples) + pos).';
     pos_d = pos_d.';
     pos_dd = pos_dd.';

%% Orientation trajectory planning

     k = 0;
     R = cell(1,r+1);
     ts_orient = cell(1,r);   % FIXME: fix the cell dimension
     w_temp = cell(1,r+1);
     w_d_temp = cell(1,r+1);
     
   % Evaluate time instants between which the orientation will be planned
     for i=1:(r+1)
         if pose{i}.via == 0
            k = k+1;
            ts_orient{k} = [ts{i}-Dt{i};i];
            if strcmp(orient_type,'ZYZ euler')
                R{i} = euler2rot(pose{i}.orient,'ZYZ');  %rotation matrix of each specified orientation
            elseif strcmp(orient_type,'ZYX euler')
                R{i} = euler2rot(pose{i}.orient,'ZYX');
            elseif strcmp(orient_type,'aa')
                R{i} = aa2rot(pose{i}.orient(1:3),pose{i}.orient(4));
            end
         else
            R{i} = eye(3);
         end
     end

     for i=1:(k-1)
         ti_orient = ts_orient{i}(2);    % Start and final planning time for each segment
         tf_orient = ts_orient{i+1}(2);

%% EULER ZYZ ANGLES

    if (strcmp(orient_type,'ZYZ euler') || strcmp(orient_type,'ZYX euler'))
        orient_norm = norm(pose{tf_orient}.orient-pose{ti_orient}.orient);
        [ph_e ph_e_d ph_e_dd] = euler_orient(ph_e,ph_e_d,ph_e_dd,pose,tf_orient,...
            ti_orient,orient_norm,ts_orient{i}(1),ts_orient{i+1}(1),tN,Ts,n_samples);
    end
                         
%% AXIS/ANGLE
    
    [ph_e,th_t_d,th_t_dd,axis] = aa_orient(ph_e,R{ti_orient},R{tf_orient},...
                                       ts_orient{i}(1),ts_orient{i+1}(1),Ts,i);
                                 
                              
%% ANGULAR VELOCITY

    [r_f th_f] = rot2aa(R{ti_orient}.'*R{tf_orient});
    w_i = r_f*th_t_d;
    w_i_d = r_f*th_t_dd;
    w_temp{i} = R{ti_orient}*(w_i);
    w_d_temp{i} = R{ti_orient}*(w_i_d);

    if i == 1
        w = [w w_temp{i}];
        w_d = [w_d w_d_temp{i}];
    else
        w = [w(:,1:(end-1)) w_temp{i}];
        w_d = [w_d(:,1:(end-1)) w_d_temp{i}];       
    end
    
%% UNIT QUATERNION (will be available in the next version)

%% Finish generation of the orientation part

     end
     
if (strcmp(orient_type,'ZYZ euler') || strcmp(orient_type,'ZYX euler'))
   % Update final orientation matrices (euler andgles)
     ph_e.euler = (pose{1}.orient*ones(1,n_samples) + ph_e.euler).';
     ph_e_d.euler = ph_e_d.euler.';
     ph_e_dd.euler = ph_e_dd.euler.';
end

% Save attitude info in a cell of structs
attitude = cell(1,k);

for i = 1:(k)
    attitude{i}.R = R{ts_orient{i}(2)};
    attitude{i}.pos = pose{ts_orient{i}(2)}.g;
end

%% Output

  % Assign outputs suitable to SIMULINK simulations
    t = t.';
    pathd.t = t;
    pathd.pos.time = t;
    pathd.pos.signals.values = pos;
    pathd.pos.signals.dimensions = 3;
    pathd.pos_d.time = t;
    pathd.pos_d.signals.values = pos_d;
    pathd.pos_d.signals.dimensions = 3;
    pathd.pos_dd.time = t;
    pathd.pos_dd.signals.values = pos_dd;
    pathd.pos_dd.signals.dimensions = 3;
    pathd.w.time = t;
    pathd.w.signals.values = w.';
    pathd.w.signals.dimensions = 3;
    pathd.w_d.time = t;
    pathd.w_d.signals.values = w_d.';
    pathd.w_d.signals.dimensions = 3;
    pathd.attitude = attitude;

if (strcmp(orient_type,'ZYZ euler') || strcmp(orient_type,'ZYX euler'))
    pathd.orient.euler.time = t;
    pathd.orient.euler.signals.values = ph_e.euler;
    pathd.orient.euler.signals.dimensions = 3;
    pathd.orient_d.euler.time = t;
    pathd.orient_d.euler.signals.values = ph_e_d.euler;
    pathd.orient_d.euler.signals.dimensions = 3;
    pathd.orient_dd.euler.time = t;
    pathd.orient_dd.euler.signals.values = ph_e_dd.euler;
    pathd.orient_dd.euler.signals.dimensions = 3;
    pathd.orient.aa.time = t;
    pathd.orient.aa.signals.values = ph_e.aa.';
    pathd.orient.aa.signals.dimensions = 4;
end   
   
    pathd.orient.aa.time = t;
    pathd.orient.aa.signals.values = ph_e.aa.';
    pathd.orient.aa.signals.dimensions = 4;

%% Plot the generated trajectory

  % Vectorfielplot.m is a script that plots the generated trajectory along 
  % with velocity and acceleration vectors  
    vectorfieldplot(pathd,Ts);

end

%% ----------------SUBFUNCTIONS----------------
%%
%% Cubic polynomial generation (includes the case of a via point)

function [s,s_d,s_dd,t] = cubicarc_via(sf,ti,tf,tN,Dt,Ts)

  % Evaluation of the cubic polynomial coefficients
    A = [ti^3    ti^2    ti     1;
         3*ti^2  2*ti    1      0;
         tf^3    tf^2    tf     1;
         3*tf^2  2*tf    1      0];
    B = [0;       % s(ti) = 0;
         0 ;      % s_d(ti) = 0;
         sf;      % s(tf) = sf;
         0];      % s_d(tf) = 0;  
    a = A\B;
    
  % Arc length s is zero from initial time t = 0 to segment start
  % time t = ti
    s_0 = zeros(size(0:Ts:(ti-Dt)));    % s_j(t) = 0 for 0 <= t <= ti
    
  % Arc length s is given by the cubic polynomial interpolation for
  % ti < t < tf
    t = (ti+Ts-Dt):Ts:(tf-Ts-Dt);
    s_j = a(1)*(t+Dt).^3 + a(2)*(t+Dt).^2 + a(3)*(t+Dt) + a(4);
    s_j_d = 3*a(1)*(t+Dt).^2 + 2*a(2)*(t+Dt) + a(3);
    s_j_dd = 6*a(1)*(t+Dt) + 2*a(2);
    
  % Arc length s is sf from time t = tf to final trajectory time t = tN
    t = (tf-Dt):Ts:tN;
    s_j_f = sf*ones(size(t));
    
  % Total arc length and it's first and second derivatives are simply
  % given by CAT of:
    s = [s_0 s_j s_j_f];
    s_d = [s_0 s_j_d 0*s_j_f];
    s_dd = [s_0 s_j_dd 0*s_j_f];
    
  % Total time is given by:
    t = 0:Ts:tN;

end

%% Rectpath

    function [pos,pos_d,pos_dd] = rectpath(pose_i,pose_f,pos,pos_d,pos_dd,ts_i,ts_f,Dt_seg,Ts,tN,n_samples)
         
    segment = zeros(3,n_samples);
    segment_d = zeros(3,n_samples);
    segment_dd = zeros(3,n_samples);
    
       % Rectilinear Path
          % Arc length computation
            [s.s s.s_d s.s_dd s.t] = cubicarc_via(norm(pose_f.g-pose_i.g),ts_i,ts_f,tN,Dt_seg,Ts);
            if norm(pose_f.g-pose_i.g) == 0
                % Manipulator doesn't move, don't do anything
            else
          % Manipulator moves     
            segment = (pose_f.g-pose_i.g)*s.s/norm(pose_f.g-pose_i.g);
            segment_d = (pose_f.g-pose_i.g)*s.s_d/norm(pose_f.g-pose_i.g);
            segment_dd = (pose_f.g-pose_i.g)*s.s_dd/norm(pose_f.g-pose_i.g);
          % Update the current position, velocity and acceleration matrices
            pos = pos + segment;
            pos_d = pos_d + segment_d;
            pos_dd = pos_dd + segment_dd;
            end
            
    end

%% Circpath

function [pos,pos_d,pos_dd,pose_f] = circpath(pose_i,pose_f,pos,pos_d,pos_dd,ts_i,ts_f,Dt_seg,Ts,tN,n_samples,startpoint)

    segment = zeros(3,n_samples);
    segment_d = zeros(3,n_samples);
    segment_dd = zeros(3,n_samples);

       % Circular Path
            % Circle radius
              rho_v = pose_i.g-pose_f.c;
              rho = norm(rho_v);
            % Arc length computation
              [s.s s.s_d s.s_dd s.t] = cubicarc_via(pose_f.thf*rho,ts_i,ts_f,tN,Dt_seg,Ts);
              if pose_f.thf == 0;
                % Manipulator doesn't move, don't do anything
              else
            % Manipulator moves
            % x1 y1 z1 are the column vectors of the rotation matrix R,
            % which describes the rotation of the reference system of the
            % circle with respect to the base reference system
              x1 = rho_v/rho;
              z1 = pose_f.z/norm(pose_f.z);
              y1 = cross(z1,x1);
              R1 = [x1 y1 z1];
              j = length(s.s);
            % Description of position, velocity and acceleration of a
            % circle in a suitable reference system
              p1s = [rho*cos(s.s./rho); ...
                     rho*sin(s.s./rho); ...
                     zeros(1,j)];
              p1s_d = [-s.s_d .* sin(s.s./rho); ...
                        s.s_d .* cos(s.s./rho); ...
                        zeros(1,j)]; 
              p1s_dd = [-s.s_d.^2.*cos(s.s./rho)/rho - s.s_dd .* sin(s.s./rho) ; ...
                        -s.s_d.^2.*sin(s.s./rho)/rho - s.s_dd .* cos(s.s./rho) ; ...
                         zeros(1,j)];
                     
            % This operation is needed to successfully generate the circle
            % segment
              segment = R1*p1s + (pose_f.c - pose_i.g)*ones(1,n_samples);
              
            % Path segment should be zero until it's start time
              segment(:,1:ts_i) = zeros(3,ts_i); 
              segment_d = R1*p1s_d;
              segment_dd = R1*p1s_dd;
              
            % Update thye current position, velocity and acceleration
            % matrices 
              pos = pos + segment;
              pos_d = pos_d + segment_d;
              pos_dd = pos_dd + segment_dd;
              pose_f.g = pos(:,end)+startpoint;
              end
end


%% Euler orientation

function [ph_e ph_e_d ph_e_dd orient orient_d orient_dd] = ...
                  euler_orient(ph_e,ph_e_d,ph_e_dd,pose,tf_orient,ti_orient,orient_norm,ts_i_orient,ts_f_orient,tN,Ts,n_samples)
              
% Arc length computation
[s.s_orient s.s_orient_d s.s_orient_dd s.t] = cubicarc_via(orient_norm,...
                                         ts_i_orient,ts_f_orient,tN,0,Ts);

    if orient_norm == 0
        % Orientation doesn't change
        orient = zeros(3,n_samples);
        orient_d = zeros(3,n_samples);
        orient_dd = zeros(3,n_samples);
    else
        % Orientation changes
        orient = (pose{tf_orient}.orient-pose{ti_orient}.orient)*s.s_orient/orient_norm;
        orient_d = (pose{tf_orient}.orient-pose{ti_orient}.orient)*s.s_orient_d/orient_norm;
        orient_dd = (pose{tf_orient}.orient-pose{ti_orient}.orient)*s.s_orient_dd/orient_norm;
        % Update orientation position, velocity and acceleration matrices
        ph_e.euler = ph_e.euler + orient;
        ph_e_d.euler = ph_e_d.euler + orient_d;
        ph_e_dd.euler = ph_e_dd.euler + orient_dd;
    end
end

%% Axis/Angle Orientation

function [ph_e,th_t_d,th_t_dd,axis] = aa_orient(ph_e,R1,R2,ts_i,ts_f,Ts,i)

th = [];
axis = [];

Rif = R1.'*R2;
[r_f th_f] = rot2aa(Rif);
[th_t th_t_d th_t_dd] = cubicarc_via(th_f,0,ts_f-ts_i,ts_f-ts_i,0,Ts);

%th = zeros(1,length(th_t));
%axis = zeros(3,length(th_t));
for l = 1:length(th_t)
    R_i = aa2rot(r_f,th_t(l));
    [axis_new th_new] = rot2aa(R1*R_i);

    %    th(l) = th_new;
    %    axis(:,l) = axis_new;
    th = [th th_new];
    axis = [axis axis_new];
end

orient_aa = [axis ;th];

    if i == 1
       ph_e.aa = [ph_e.aa orient_aa];
    else
       ph_e.aa = [ph_e.aa(:,1:(end-1)) orient_aa];
    end
end
