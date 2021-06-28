function bidsCopyInputFolder(opt, unzip)
  %
  % Copies the folders from the ``raw`` folder to the
  % ``derivatives`` folder, and will copy the dataset description and task json files
  % to the derivatives directory.
  %
  % Then it will search the derivatives directory for any zipped ``*.gz`` image
  % and uncompress the files for the task of interest.
  %
  % USAGE::
  %
  %   bidsCopyRawFolder([opt,] ...
  %                     [deleteZippedNii = true,])
  %
  % :param opt: structure or json filename containing the options. See
  %             ``checkOptions()`` and ``loadAndCheckOptions()``.
  % :type opt: structure
  % :param modalitiesToCopy: for example ``{'anat', 'func', 'fmap'}``
  % :type modalitiesToCopy: cell
  % :param unZip:
  % :type unZip: boolean
  %
  % (C) Copyright 2019 CPP_SPM developers

  if nargin < 1 || isempty(opt)
    opt = [];
  end

  if nargin < 2 || isempty(unzip)
    unzip = true();
  end

  opt = loadAndCheckOptions(opt);

  cleanCrash();

  printWorklowName('copy data', opt);

  %% All tasks in this experiment
  % raw directory and derivatives directory
  createDerivativeDir(opt);

  %% Loop through the groups, subjects, sessions
  if any(ismember(opt.query.modality, 'func'))
    [BIDS, opt] = getData(opt, opt.dir.input);
  else
    [BIDS, opt] = getData(opt, opt.dir.input, 'T1w');
  end

  use_schema = true;
  overwrite = true;
  skip_dependencies = false;

  for iModality = 1:numel(opt.query.modality)

    filter = opt.query;
    filter.modality = opt.query.modality{iModality};
    filter.sub = opt.subjects;

    if strcmp(filter.modality, 'func')
      filter.task = opt.taskName;
    end

    bids.copy_to_derivative(BIDS, ...
                            opt.pipeline.name, ...
                            fullfile(opt.dir.preproc, '..'), ...
                            filter, ...
                            'unzip', unzip, ...
                            'force', overwrite, ...
                            'skip_dep', skip_dependencies, ...
                            'use_schema', use_schema, ...
                            'verbose', opt.verbosity > 0);

    fprintf(1, '\n\n');
  end

end
