%-------------------------- Shortcut functions --------------------------%

% The purpose of this module is to provide a template for every frequently
% used action in maltab for which I probably have to resort to a google search
% to find the answer

%% Logos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KTH, Royal Institute of Technology %
% School of Engineering Sciences     %
% nkoukis, January 2014              %
% Computational Fluid Dynamics       %
% Homework II                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NTUA, National Technical University of Athens                  %
% School of Mechanical Engineering                               %
% Laboratory of Automatic Control & Machine and Plant Regulation %
% nickkouk, June 2015                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FIGURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure handling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the handle of all active figures
figHandles = findobj('Type','figure');
% or 
figHandles = findall(0,'Type','figure');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% legend - axes fonts configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fontsize = 9;
xlabel('Mach', 'FontSize', fontsize);
ylabel('Excess Thrust [N]', 'FontSize', fontsize);
title('Stability Region','FontSize', fontsize+2);
h_legend = legend([h1, h2], {'kalimera', 'kalinuxta'});
set(h_legend, 'FontSize', fontsize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set legend position manually
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rect = [0.25, 0.25, .25, .25]; % x, y, width, height
set(h_legend, 'Position', rect)
set(h_legend, 'Location', 'East'); % alternative way
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eps
path_to_plots = '../report/figures/';
name = 'kalimera'
print(gcf, '-depsc2',[path_to_plots,'kalimera']);
saveas(gcf, [path_to_plots, 'kalimera'], 'fig');
%tif
figname = 'kalimera';
saveas(gcf, [path_to_plots, figname], 'fig');
print(gcf, '-dtiff',[path_to_plots,figname]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure - Generalized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Saving figures - alternative approach
figures = {'step_resps', 'singular', 'simul'};
figures = strcat(cases{case_num}, '_', figures);
%.....
% save all the plots
if savefigs
    fprintf(fid, 'Saving the figures.\n');
    figs = flip(findobj('type', 'figure'));
    for i=1:length(figs)
        % get the current figure
        figure(figs(i));
        % save it
        figname = figures{i};
        saveas(gcf, [path_to_plots, figname], 'fig');
        print(gcf, '-dtiff',[path_to_plots,figname]);
    end
    fprintf(fid, 'Saving of figures completed.\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting axis limits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% only lower
limsy=get(gca,'YLim');
set(gca,'Ylim',[2, limsy(2)]);
% only upper
limsy=get(gca,'YLim');
set(gca,'Ylim',[limsy(1), 10]);
% both
ylim([lower_bnd, upper_bnd]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting linewidth of plotline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
linewidth = 1.5;
plot(x, y, 'Linewidth', linewidth);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color - Style Configuration in Figures (use of structs)
% usefull arrays in printing - initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colors_ar = {'g', 'r', 'b', 'c', 'k', 'y'};
mstyles_ar = {'-', '--',  '-.', ':', 'o-'};
style_ar = allcomb(mstyles_ar, colors_ar);
style_ar = strcat(style_ar(:, 1), style_ar(:, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title for multiple subplots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=mtit('Level Flight Trim Conditions',...
    'fontsize',fontsize+2,'color',[1 0 0]);
% refine title using its handle <p.th>
set(p.th,'edgecolor',1*[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% textbox - upper left top
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
annotation('textbox',...
    [0.13 0.74 0.19 0.19],...
    'String', text1,...
    'FontSize',16,...
    'FontName','Arial',...
    'LineStyle','--',...
    'EdgeColor',[1 1 0],...
    'LineWidth',2,...
    'BackgroundColor',[0.9  0.9 0.9],...
    'Color',[0.84 0.16 0]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplots configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eachline = 3; 
if neigs <= eachline
    nplots_y = neigs;

else
    nplots_y = eachline;
end
nplots_x = ceil(neigs/eachline);

subplot(sprintf('%d%d%d', nplots_x, nplots_y, eigenv));
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplots in 'half' positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,7.5)
subplot(3,3,8.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define a colorlist in RGB form
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
red = [255, 0, 0]/255;
red2 = [255, 51, 0]/255;
orange1 = [255, 94, 0]/255;
orange2 = [255, 128, 0]/255;
orange3 = [255, 162, 0]/255;
yellow1 = [255, 222, 0]/255;
yellow2 = [239, 255, 0]/255;
green1 = [188, 255, 0]/255;
green2 = [102, 255, 0]/255;
green3 = [51, 255, 0]/255;
green4 = [0, 255, 26]/255;
cyan1 = [0, 255, 111]/255;
cyan2 = [0, 255, 171]/255;
cyan3 = [0, 255, 255]/255;
blue1 = [0, 196, 255]/255;
blue2 = [0, 137, 255]/255;
blue3 = [0, 85, 255]/255;
blue4 = [0, 17, 255]/255;
colors_array = [red;
    red2;
    orange1; 
    orange2; 
    orange3;
    yellow1;
    yellow2;
    green1;
    green2;
    green3;
    green4;
    cyan1;
    cyan2;
    cyan3;
    blue1;
    blue2;
    blue3;
    blue4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot with RGB colors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(x,y,'Color',[0 0 1],'Marker','+')
hold on;
plot(x,z,'Color',[1 0 1],'Marker','+'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show figure now
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% custom subplot configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the results
figure(1); clf()
subplot(3,4,1:3)
subplot(3,4,5:7)
subplot(3,4,9:11)
subplot(3,4,[4 8 12])



% bold text in title, labels
title('Test','fontweight','bold','fontsize',16);
ylabel('\bfY\rm', 'fontsize',14); % using TEX syntax

% linebreak in ylabel
ylabel({2010;'Population';'in Years'}) % http://www.mathworks.com/help/matlab/ref/ylabel.html
% latex notation
xlabel('t_{seconds}')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transparent legend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(rand(5)); 
lgnd = legend('one','two','three','four','five');
set(lgnd,'color','none');

% 2nd way - http://undocumentedmatlab.com/blog/transparent-legend#more-5617
set(hLegend.BoxFace, 'ColorType','truecoloralpha', ...
    'ColorData',uint8(255*[.5;.5;.5;.8]));  % [.5,.5,.5] is light gray; 0.8 means 20% transparent


% Image to graphics file
imwrite(img, 'kalimera.tiff')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change properties in all figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set title, axes labels, and legend font size
set(findall(gcf,'Type','text'),'FontSize',11)
% Set data line width and color
set(findall(gcf,'Type','line'),'LineWidth',2,'Color','red')
% Set axes tick label font size, color, and line width
set(findall(gcf,'Type','axes'),'FontSize',11,'LineWidth',2,...
    'XColor','black','YColor','black')

% how to change the properties of each subfigure
for subfig_num = [subfig1, subfig2]
    subplot(subfig_num)
    % Set title, axes labels, and legend font size
    set(findall(gcf,'Type','text'),'FontSize',fontsize)
    % Set data line width and color
    set(findall(gcf,'Type','line'), 'LineWidth', linewidth, 'Color', 'red')
    % Set axes tick label font size, color, and line width
    set(findall(gcf,'Type','axes'),'FontSize',fontsize,...
        'XColor','black','YColor','black')
end

% autoArrange the figures
autoArrangeFigures(0, 0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Renaming a structure     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ph_struct.(nname) = ph_struct.(fldname);
ph_struct = rmfield(ph_struct, fldname);

% displays an animated comet plot of vector Y vs. X.
comet(X,Y);


%% SYMBOLICS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define a symbolic variable with respect to t
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms I1(t) % defines t as symbolic automatically
% differentiate that variable
dI1(t) = diff(I1(t), t);
dI1(t) = diff(I1(t), t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find laplace transform of eq1(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L1(t) = laplace(eq1,t,s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% substituting values in symbolic function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms LI1 LQ
NI1 = subs(L1(t),{R1,R2,R3,L,C,I1(0),Q(0)}, ...
    {4,2,3,1.6,1/4,15,2});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the inverse  Laplace of function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1 = ilaplace(LI1, s, t);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assumptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = sym('x','real');
y = sym('y','positive');
z = sym('z','integer');
t = sym('t','rational');

%% OUTPUT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display complex number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s\n', num2str(complex_number));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display a matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(a_matrix);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output to a file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path_to_logs = '../logfiles/';
fid = fopen(strcat(path_to_logs, 'kalimera.log'), 'w'); fid_open = 1;
fprintf(fid, '...\n');
if fid_open; fclose(fid); end

% fprintf a matrix A
fprintf([repmat('%f\t', 1, size(A, 2)) '\n'], A');
%% MATRIX OPERATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate random logical matrices 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = randi([0 1], 50, 10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% diagonal operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extracts the diagonals specified by d.
B = spdiags(A,d);
% place values in the diagonals of a matrix
e = ones(n, 1);
B = [e, -2*e, e];
A = zeros(5,5);
A = spdiags(B, -1:1, 3, 3);

% convert sparse to full matrix
A = full(A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating a struct array
% alatitude, thrusts, powers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alt_curve = struct('alt', 0,...
    'thrusts', zeros(length(mach_range), 1), ...
    'powers', zeros(length(mach_range), 1));
% replicate style into an array
curves = repmat(alt_curve, length(alt_range), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter out trailing zeros in array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_vals = n_vals(1:find(n_vals,1,'last'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpolate through set of data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
de = @(t) interp1(timeforde, de_values, t);


%% SIMULINK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simOut = sim('vdp','SimulationMode','rapid','AbsTol','1e-5',...
            'StopTime', '30', ... 
            'ZeroCross','on', ...
            'SaveTime','on','TimeSaveName','tout', ...
            'SaveState','on','StateSaveName','xoutNew',...
            'SaveOutput','on','OutputSaveName','youtNew',...
            'SignalLogging','on','SignalLoggingName','logsout');
        
%% Various Operations
string = evalc(['disp(someVariable)']);
toString = @(var) evalc(['disp(var)']);
        
%% TODO

% ode template

%% CONTROL TOOLBOX

% Open GUI for setting Control System Toolbox Preferences.
ctrlpref

% get peak gain of tf
gpeak = getPeakGain(sys,tol,fband);

%% VARIOUS

%  clear the matalb toolbox path cache - common problem
rehash toolboxcache

% fsolve - suppress output
opts = optimoptions('fsolve');
opts.Display = 'off';

% using bsxfun/repmat for array manipulations - timeit
fbsxfun = @() bsxfun(@minus,A,mean(A));
frepmat = @() A - repmat(mean(A),size(A,1),1);
timeit(fbsxfun)

% deal inputs to outputs - multiple variable assignment
[a,b] = deal('kalimera', 'kalinuxta');
[a,b,c] = deal(1)

a = stepplot(1/s^2, 1/s^3) % alternative to step. Returns the handle of the object for further manipulation

sys(1,2) % get a submatrix of the system
sys_ss = ss(sys,'minimal') % produces a state-space realization with no uncontrollable or unobservable states.
sys_ss = ss(sys,'explicit')% computes an explicit realization (E = I) of the dynamic system model sys. If sys is improper, ss returns an error.

% compute transfer function/matrix at certain point!
evalfr(G1, 1/2+0j)

%%%%%%%%%%%%%%%%%%%%%%%
% CLASS OF OBJECT     %
%%%%%%%%%%%%%%%%%%%%%%%
isa(x, 'double'); isa(x, 'numeric'); isa(x, 'char')
% also isfloat, isnumeric, isinteger, exist..
% isa(h, 'function_handle')% see if variable h is a function handle.

%%%%%%%%%%%%%%%%%%%%%%%
% THE PROFILER        %
%%%%%%%%%%%%%%%%%%%%%%%
profile on; % start the profiler
profile viewer; % view the profiler GUI
profsave(stats,'mydir') % save the profiler stats

%%%%%%%%%%%%%%%%%%%%%%%
%     CELLS           %
%%%%%%%%%%%%%%%%%%%%%%%
flip(A); % reverse the order of elements in a cell.

celldisp(A); % display the contents of a cellarray
A(3, :) = []; % delete the 3rd row of the cell array


% apply a function in a cell array
B = cellfun('isreal', A);

%Place all elements of a numeric array into separate cells.
a1 = 1:4;
a2 = num2cell(a1);
% deal the contents of cell array into different variables
[a,b,c,d] = deal(kalimera{:}) % kalimera is a cell array

%%%%%%%%%%%%%%%%%%%%%%%
%    ERROR HANDLING   %
%%%%%%%%%%%%%%%%%%%%%%%
try
    (commands1)
catch ERR% in case of error
    (commands2)
    rethrow(ERR) % raise the error
end
lasterr % describe the error
lasterror % describe the error thoroughly

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    NAME/VALUES MATLAB FUNS   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function example(varargin)

%# define defaults at the beginning of the code so that you do not need to
%# scroll way down in case you want to change something or if the help is
%# incomplete
options = struct('firstparameter',1,'secondparameter',magic(3));

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments
nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
   error('EXAMPLE needs propertyName/propertyValue pairs')
end

for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
   inpName = lower(pair{1}); %# make case insensitive

   if any(strcmp(inpName,optionNames))
      %# overwrite options. If you want you can test for the right class here
      %# Also, if you find out that there is an option you keep getting wrong,
      %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
      options.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name',inpName)
   end
end


% Loading worspace variables - if path contains a cell
load(path{:});

% CREATE EMPTY FILE - open & close file
fclose(fopen('nonexistentfile.txt', 'w'))
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    TO BE IMPLEMENTED IN MATLAB   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,p] = chol(A) % second arguement is 0 if matrix is PD
all(eig((A+A')/2)>=0)  % returns 1 if matrix is PD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    CURVE FITTING                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Polyfit
p = polyfit(x_vals, y_vals, pol_order);

% Set the path in matlab
p = pathdef; % have the pathdef.m in your local settings - returns a string with your desired path configuration
path(p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   STATUS FILE                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete previous txt files
delete(strcat(path_to_controllers, '*.txt'));

% Add new file
curTime = datestr(now);
curTime = strrep(curTime, ':', '-');
fname = strcat(path_to_controllers, sprintf('UPDATED ON %s', curTime), ...
    '.txt');
fopen(fname, 'w+');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM MAC TERMINAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlab -nodesktop -nosplash

% add folder + subfolders to path
addpath(genpath('path_to_folder')


% check which toolbox does one command [roty] belong to
which roty

%% IMAGE PROCESSING TOOLBOX

rgb2gray('image_path');
imshow; % show an image
imread; % read an image
drawnow; % force image to display now
% histogram of an image
[pixelCount, grayLevels] = imhist(originalImage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPLYING A COLOR THRESHOLD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Threshold the image to get a binary image (only 0's and 1's) of class "logical."
% Method #1: using im2bw()
%   normalizedThresholdValue = 0.4; % In range 0 to 1.
%   thresholdValue = normalizedThresholdValue * max(max(originalImage)); % Gray Levels.
%
% nickkouk
% THIS IS WRONG, should have used thresholdValue instead of normalized one
%   binaryImage = im2bw(originalImage, normalizedThresholdValue);       % One way to threshold to binary
%
% Method #2: using a logical operation.
thresholdValue = 100;
binaryImage = originalImage > thresholdValue; % Bright objects will be chosen if you use >.

% identify the seperate objects in an image
labeledImage = bwconncomp(binaryImage);

% shape-based filtering
% remove all object containing fewer than 30 pixels
bw = bwareaopen(bw,30);


% http://se.mathworks.com/help/images/examples/identifying-round-objects.html
% fill a gap in the pen's cap
se = strel('disk',2);
bw = imclose(bw,se);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw = imfill(bw,'holes');

imshow(bw)

% convert the found labels into rgb image for visualization
label2rgb(L, MAP)

% Global image threshold using Otsu's method
level = graythresh(I)
[level EM] = graythresh(I)

% You can view the builtin demo images here
ls('/Applications/MATLAB_R2014a.app/toolbox/images/imdemos')
ls('/Applications/MATLAB_R2014a.app/toolbox/images/imdata')

% Image segmentation

% Subsract an Image of another (e.g compare against background)
imgDifff = abs(img1BW - img2BW);
%or 
imgDiff = imsubstract(img1BW - imb2BW);

% Find circles using Circular Hough Transform.
% in order to detect the circles you need to configure the 'Sensitivity'
% paameter as well!! 
CENTERS = imfindcircles(A, RADIUS);  % finds cercles with approximately the specified RADIUS
[CENTERS, RADII] = imfindcircles(A, RADIUS_RANGE, 'objectPolarity', 'dark'); 
viscircles(centers, radii); % show the detected circles

% add noise!
% add salt&pepper noise to an image!
imnoise(x.data, 'salt & pepper');

% you can also process images "in blocks" for memory reasons
% save to a file, not to a var just to save memory
filename = 'mandi.tif';
blocksize = [280, 640];
blockproc(filename, blocksize, @(x) imnoise(x.data, 'salt & pepper'), ...
    'destination', 'myresult.tif', ... 
    'UseParallel', false);

% write reduced resolution set image for easier viewing
% Clarity of the image and memory usage are balanced
rset_file = rsetwrite('myresult.tif');
imtool(rset_file);

% show two images side by side
imshowpair(img1, img2, 'montage');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI BUILDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Have this line at the end of function if you want to update the handles
% struct
guidata(hObject, handles); % Update handles structure

%get set methods for getting/setting widget variables
get(handles.widget_tag, 'PropertyName');
set(handles.widget_tag, 'PropertyName', PropValue);

% change the GUI Position
% You can specify 'movegui' as a CreateFcn callback for a figure
movegui(hObject, 'center');
% maximize GUI size
set(gcf,'units','pixel','position',get(0,'screensize'))

% pre-defined dialog boxes
% http://se.mathworks.com/help/matlab/predefined-dialog-boxes.html

%HELPDLG
helpdlg('window prompt',...
        'Window name');
    
%MSGBOX
h = msgbox('Operation Completed');
h = msgbox({'Operation' 'Completed'}); % use cell for line breaks
h = msgbox('Invalid Value', 'Error (window name)','error'); % include error icon
% Use an RGB image of your own
myicon = imread('landOcean.jpg');
h=msgbox('Operation Completed','Success','custom',myicon);

% Construct a QUESTDLG with three options
choice = questdlg('Would you like a dessert?', ...
	'Dessert Menu', ...
	'Ice cream','Cake','No thank you','No thank you');
% Handle response
switch choice
    case 'Ice cream'
        disp([choice ' coming right up.'])
        dessert = 1;
    case 'Cake'
        disp([choice ' coming right up.'])
        dessert = 2;
    case 'No thank you'
        disp('I''ll bring you your check.')
        dessert = 0;
end

playagain = menu('Do you want to play again?', 'Yes!', 'No.... :/');


% Camera Support
webcamlist % print a list of the available cameras to use
cam = webcam; % select the first, you can also use indexes
preview(cam)
closePreview(cam)
img = snapshot(cam);
imshow(img)
webcamlist

% Initialize video
vid = videoinput('macvideo',1);
hImage=image(zeros(699,1500,1),'Parent',handles.camera_axes);
set(vid, 'ReturnedColorSpace', 'RGB');
preview(vid,hImage); % no RGB image in this case


% display current time, date
 c = clock;
disp(datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));


% force GUI to close
close all force


% Strip string of linefeeds (codes 10, 13)
indx = find(s==char(13) | s==char(10) | s==' ');
s(indx) = [];

% check if  directory is on the MATLAB path
pathCell = regexp(path, pathsep, 'split');
if ispc  % Windows is not case-sensitive
  onPath = any(strcmpi(foldername, pathCell));
else
  onPath = any(strcmp(foldername, pathCell));
end


% matlab version and toolboxes available 
ver

% grep on a file in matlab
grep -i -n linewidth ~/local/matlab_extensions/startup.m


% get the home path
if ispc
home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
else
home = getenv('HOME');
end

% repeat a string N times in a sequence
repeatedString = repmat('*', 1, 69);


% suppress lsqcurvefit output
opts = optimset('Display','off');
a = lsqcurvefit(@model_fun, X, Y,opts);
