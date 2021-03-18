% (C) Copyright 2019 CPP BIDS SPM-pipeline developers

function checkDependencies(varargin)
  %
  % Checks that that the right dependencies are installed:
  % - SPM
  % - Nifti tools
  % Also loads the spm defaults.
  %
  % Can also be used to check the presence of SPM toolboxes like Marsbar
  %
  % USAGE::
  %
  %   checkDependencies()
  %
  %   checkDependencies('marsbar')
  %
  % .. TODO:
  %    - refactor in a several sub functions to cehck each dependency
  %    - need to check other dependencies (bids-matlab, spmup)
  %

  fprintf('Checking dependencies\n');

  SPM_main = 'SPM12';
  SPM_sub = '7487';

  %% check spm version
  try
    [a, b] = spm('ver');
    fprintf(' Using %s %s\n', a, b);
    if any(~[strcmp(a, SPM_main) strcmp(b, SPM_sub)])
      str = sprintf('%s %s %s.\n%s', ...
                    'The current version SPM version is not', SPM_main, SPM_sub, ...
                    'In case of problems (e.g json file related) consider updating.');
      warning(str); %#ok<*SPWRN>
    end
  catch
    error('Failed to check the SPM version: Are you sure that SPM is in the matlab path?');
  end

  spm('defaults', 'fmri');

  %% Check the Nifti tools are indeed there.
  nifti_tools_url = ...
      ['https://www.mathworks.com/matlabcentral/fileexchange/' ...
       '8797-tools-for-nifti-and-analyze-image'];

  a = which('load_untouch_nii');
  if isempty(a)
    errorStruct.identifier = 'checkDependencies:missingDependency';
    errorStruct.message = sprintf('%s \n%s', ...
                                  ['Failed to find the Nifti tools: ' ...
                                   'Are you sure they in the matlab path?'], ...
                                  'You can download them here: %s', nifti_tools_url);
    error(errorStruct);
  else
    fprintf(' Nifti tools detected\n');
  end

  fprintf(' We got all we need. Let''s get to work.\n');

end
