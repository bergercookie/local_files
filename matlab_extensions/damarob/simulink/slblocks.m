function blkStruct = slblocks
%SLBLOCKS Defines the Simulink library block representation for DAMAROB Toolbox
  
  
blkStruct.Name    = ['DAMA^{ROB}',sprintf('\n'),'Toolbox'] ;
blkStruct.OpenFcn = 'DAMA_lib';
blkStruct.MaskDisplay = 'image(imread(''dama_150.png''));';


% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it
Browser.Library = 'DAMA_lib';
Browser.Name    = 'DAMA^{ROB} Toolbox';
Browser.IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% Define information for model updater
%blkStruct.ModelUpdaterMethods.fhDetermineBrokenLinks = @UpdateSimulinkBrokenLinksMappingHelper;
%blkStruct.ModelUpdaterMethods.fhUpdateModel = @UpdateSimulinkBlocksHelper;

% End of slblocks.m


