function [it_is_out] = is_proper(varargin)
%IS_PROPER Investigate if a transfer function is of proper form (more poles 
% than zeros). If the 'strict' argument is given IS_PROPER returns true for 
% equal number of poles and zeros.

it_is = false; % set if false at first

if ~strcmp((varargin{1}), 'tf')
    [r, c] = size(varargin{1});
    if r > 1 || c > 1
        error('is_proper:InputValidation', ...
            'Method not iplemented yet for tf matrices');
    end
else
    error('is_proper:InputValidation', ...
        'Function takes a tf object as first arguement');
end

G = varargin{1};
Gprop = zpk(G); % zpk fields are structs
zs = Gprop.z{1};
ps = Gprop.p{1};

if nargin == 1
    % More poles than zeros.
    if max(size(zs)) < max(size(ps))
        it_is = true;
    end
elseif nargin == 2
    if strcmp(varargin{2}, 'strict')
        % Equal poles and zeros Case included.
        if max(size(zs)) <= max(size(ps))
            it_is = true;
        end
    else
        error('is_proper:InputValidation', ...
            'Unknown option %s', varargin{2});
    end
else
    error('is_proper:InputValidation:InvalidNoArguements', ...
        'Invalid number of arguements: The user should input at most 2 arguements');
end

it_is_out = it_is;
end