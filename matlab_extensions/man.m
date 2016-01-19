function man(varargin)
%MAN wrapper for calling the matlab help command. The 'More' command is
% used (just for this command) to start reading from the top of the help
% page
%
% Example:
%     man fprintf % read the documentation of fprintf
%     man help % read the documtation of help command
% Copyright: 2015, nickkouk
% Stockholm, Sweeden

% more('on')
nlines = 12; % num of lines to display

more(nlines)
help(varargin{1});
more('off')
end