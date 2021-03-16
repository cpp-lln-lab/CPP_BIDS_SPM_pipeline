% (C) Copyright 2020 CPP BIDS SPM-pipeline developers

function saveOptions(opt)
  %
  % Short description of what the function does goes here.
  %
  % USAGE::
  %
  %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
  %
  % :param opt: Options chosen for the analysis. See ``checkOptions()``.
  % :type opt: structure
  %

  optionDir = fullfile(pwd, 'cfg');
  [~, ~, ~] = mkdir(optionDir);  

  taskString = '';
  if isfield(opt, 'taskName')
    taskString = ['_task-', opt.taskName];
  end

  filename = fullfile(pwd, ['options', ...
                            taskString, ...
                            '_date-' datestr(now, 'yyyymmddHHMM'), ...
                            '.json']);

  jsonFormat.indent = '    ';
  spm_jsonwrite(filename, opt, jsonFormat);

  fprintf('Options saved in: %s\n\n', filename);

end
