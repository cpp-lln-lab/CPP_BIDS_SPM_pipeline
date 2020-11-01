% (C) Copyright 2020 CPP BIDS SPM-pipeline developers

function [prefix, motionRegressorPrefix] = getPrefix(step, opt, funcFWHM)
  % [prefix, motionRegressorPrefix] = getPrefix(step, opt, funcFWHM)
  %
  % generates prefix to append to file name to look for

  if nargin < 3
    funcFWHM = 0;
  end

  prefix = '';
  motionRegressorPrefix = '';

  allowedPrefixCases = {
                        'STC'; ...
                        'preprocess'; ...
                        'smoothing_space-individual'; ...
                        'smoothing'; ...
                        'FFX_space-individual'; ...
                        'FFX'};

  switch step

    case 'STC'

    case 'preprocess'
      prefix = prefixForSTC(prefix, opt);

      % when smoothing is done on non-normalized data (in the space of T1w)
    case 'smoothing_space-individual'
      prefix = prefixForSTC(prefix, opt);
      prefix = [spm_get_defaults('unwarp.write.prefix') prefix];

    case 'smoothing'
      prefix = prefixForSTC(prefix, opt);
      prefix = [spm_get_defaults('normalise.write.prefix') prefix];

    case 'FFX_space-individual'
      prefix = prefixForSTC(prefix, opt);
      prefix = [spm_get_defaults('unwarp.write.prefix') prefix];

      % Check which level of smoothing is applied
      if funcFWHM > 0 % else, take the smoothed files
        prefix = [spm_get_defaults('smooth.prefix') num2str(funcFWHM) prefix];
      end

    case 'FFX'
      prefix = prefixForSTC(prefix, opt);
      prefix = [spm_get_defaults('normalise.write.prefix') prefix];

      % Check which level of smoothing is applied
      if funcFWHM > 0
        prefix = [spm_get_defaults('smooth.prefix') num2str(funcFWHM) prefix];
      end

    otherwise

      fprintf(1, '\nAllowed prefix cases:\n');
      for iCase = 1:numel(allowedPrefixCases)
        fprintf(1, '- %s\n', allowedPrefixCases{iCase});
      end

      errorStruct.identifier = 'getPrefix:unknownPrefixCase';
      errorStruct.message = sprintf('%s\n%s', ...
                                    ['This prefix case you have requested ' ...
                                     'does not exist: %s.'], ...
                                    'See allowed cases above', step);
      error(errorStruct);

  end

end

function prefix = prefixForSTC(prefix, opt)
  % Check the slice timing information is not in the metadata and not added
  % manually in the opt variable.
  if (isfield(opt.metadata, 'SliceTiming') && ...
      ~isempty(opt.metadata.SliceTiming)) || ...
          ~isempty(opt.sliceOrder)
    prefix = [spm_get_defaults('slicetiming.prefix') prefix];
  end
end
