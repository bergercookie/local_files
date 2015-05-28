function [S_out, peak_out] = sensitivity(varargin)
%SENSITIVITY Compute the sensitivity function of a system
% Example:

% Copyright 2015, Nikolaos Koukis

%% Input validation
classes_avail = {'tf'};
minimal = 0;

if nargin ~= 2 && nargins ~= 3
    % No of arguements
    error('sensitivity:InputValidation', ...
        'Invalid number of arguements');
else
    % minreal the 3rd arguement?
    if nargin == 3
        if ~strcmp(varargin{3}, 'minimal')
            error('sensitivity:InputValidation', ...
                'Unknown 3rd arguement specified');
        else
            minimal = 1;
        end
    end
    
    % Unpack the varargin variables
    for_fun = varargin{1};
    feed_fun = varargin{2};
    
    % Check for tranfser matrices format
    if ~strcmp(class(for_fun), 'tf') || ~strcmp(class(for_fun), 'tf')
        error('sensitivity:InputValidation', ...
            'The systems should be of transfer matrix form');
    end
end


%% Computation

% Sensitivity function
LoopGain = for_fun * feed_fun;
if minimal
    S = minreal(inv(eye(size(L)) + L)); % sensitivity function
else
    S = ( eye(size(LoopGain)) + LoopGain ) ^-1;
end

% Sensitivity -inf Gain
peak = getPeakGain(S);

%% PostProcessing
S_out = S;
peak_out = peak;

end
