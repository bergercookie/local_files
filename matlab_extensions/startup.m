    % nickkouk - 03-Apr-2015
% Startup file

%%% INITIALIZATION 
edit to_know.m
edit shortcuts.m
edit startup.m

clc;

% motivational message of the day
quotes;
fprintf(1, '---------------------------------------------------------------------\n');

%% Windows specific settings
if strfind(computer, 'WIN')
    cd('C:\Users\nick\Documents\MATLAB\');
    fprintf(1, 'Current Dir:\n\t%s\n\n', pwd);
end

%% FIGURES
fontsize = 9;
linewidth = 1.0;

% grid on by default
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on')

% Specifying a property value of 'factory' sets the property to its 
% factory-defined value.
% (i.e) set(h,'EdgeColor','factory')


% Taken from http://se.mathworks.com/matlabcentral/newsreader/view_thread/161797

set(0, 'DefaultFigureColor', [0.5 0.5 0.5], ...
'DefaultFigurePaperType', 'a4letter', ...
'DefaultAxesColor',  'white', ...
'DefaultAxesFontUnits', 'points', ...
'DefaultAxesFontSize', fontsize, ...
'DefaultAxesFontAngle', 'Normal', ...
'DefaultAxesFontName', 'Times', ...
'DefaultAxesGridLineStyle', ':', ...
'DefaultAxesInterruptible', 'on', ...
'DefaultAxesLayer', 'Bottom', ...
'DefaultAxesXGrid','on', ...
'DefaultAxesYGrid','on', ...
'DefaultAxesNextPlot', 'replace', ...
'DefaultAxesUnits', 'normalized', ...
'DefaultAxesXcolor', [0, 0, 0], ...
'DefaultAxesYcolor', [0, 0, 0], ...
'DefaultAxesZcolor', [0, 0, 0], ...
'DefaultAxesVisible', 'on', ...
'DefaultLineLineStyle', '-', ...
'DefaultLineLineWidth', linewidth, ...
'DefaultLineMarker', 'none', ...
'DefaultLineMarkerSize', 12, ...
'DefaultTextColor', [0, 0, 0], ...
'DefaultTextFontUnits', 'Points', ...
'DefaultTextFontSize', fontsize, ...
'DefaultTextFontName', 'Palatino', ...
'DefaultTextVerticalAlignment', 'middle', ...
'DefaultTextHorizontalAlignment', 'left');

% make the figures docked
set(0,'DefaultFigureWindowStyle','docked')
% set(0,'DefaultFigureWindowStyle','normal')

%% VARIOUS

% get the desktop handle
desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
desktop.restoreLayout('personal');


%% CONTROL THEORY
s = tf('s');
double_int = 1/s^2;

%% ENDING ARGS
clear i;

% folders to add to path
addpath(genpath('~/local/matlab_extensions/damarob/'))
addpath(genpath('~/local/matlab_extensions/rvctools/'))
addpath(genpath('/Users/nick/Documents/MATLAB/SupportPackages/R2014a/'))
addpath(genpath('/Users/nick/local/matlab_extensions/grep04apr06'));
addpath(genpath('/Users/nick/local/matlab_extensions/unit_converters'));

% set certain warnings off
warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure')
