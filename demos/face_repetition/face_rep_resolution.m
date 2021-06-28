% (C) Copyright 2019 Remi Gau
%
%
% runs preprocessing with different final spatial resolution in MNI space
%

clear;
clc;
close all;

FWHM = 6;

downloadData = true;

run ../../initCppSpm.m;

%% Set options

opt = face_rep_get_option_results();

%% Removes previous analysis, gets data and converts it to BIDS
if downloadData

  download_convert_face_rep_ds();

end

%% Run batches

reportBIDS(opt);

modelFile = opt.model.file;

for iResolution = 2:1:3

  opt.pipeline.type = 'preproc';
  opt.pipeline.name = ['cpp_spm-preproc-res' num2str(iResolution)];

  opt.funcVoxelDims = repmat(iResolution, 1, 3);

  opt.dir.preproc = spm_file( ...
                             fullfile(opt.dir.raw, ...
                                      '..', ...
                                      'derivatives', ...
                                      opt.pipeline.name), ...
                             'cpath');

  % create a new BIDS model json file
  % this way the GLM output will be store in a different directory for each
  % resolution as the name of the GLM directory is based on the name of the
  % model in the BIDS model
  content = spm_jsonread(opt.model.file);
  content.Name = [content.Name, ' resolution - ', num2str(iResolution)];

  p = bids.internal.parse_filename(modelFile);
  p.entities.model = [p.entities.model, ' resolution', num2str(iResolution)];
  newModel = spm_file(opt.model.file, 'filename', createFilename(p));
  opt.model.file = newModel;

  spm_jsonwrite(newModel, content, struct('indent', '   '));

  % run analysis
  bidsCopyInputFolder(opt);

  bidsSTC(opt);

  bidsSpatialPrepro(opt);

  bidsSmoothing(FWHM, opt);

  opt.pipeline.type = 'stats';
  opt.pipeline.name = ['cpp_spm-stats-res' num2str(iResolution)];
  opt = checkOptions(opt);

  bidsFFX('specifyAndEstimate', opt, FWHM);
  bidsFFX('contrasts', opt, FWHM);

  % specify underlay image
  subLabel = '01';
  [BIDS, opt] = getData(opt, opt.dir.preproc);
  [~, anatDataDir] = getAnatFilename(BIDS, subLabel, opt);
  opt.result.Steps(1).Output.montage.background = spm_select('FPList', ...
                                                             anatDataDir, ...
                                                             '^wm.*desc-skullstripped.*.nii$');

  bidsResults(opt, FWHM);

end
