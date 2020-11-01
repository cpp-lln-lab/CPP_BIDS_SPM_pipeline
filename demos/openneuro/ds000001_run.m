% (C) Copyright 2020 CPP BIDS SPM-pipeline developers

% runDs00014

clear;
clc;

% Smoothing to apply
FWHM = 6;

% directory with this script becomes the current directory
WD = fileparts(mfilename('fullpath'));

% we add all the subfunctions that are in the sub directories
addpath(genpath(fullfile(WD, '..', '..', 'src')));
addpath(genpath(fullfile(WD, '..', '..', 'lib')));

%% Set options
opt = ds000001_getOption();

checkDependencies();

reportBIDS(opt);

bidsCopyRawFolder(opt, 1);

bidsSTC(opt);

bidsSpatialPrepro(opt);

anatomicalQA(opt);

bidsSmoothing(FWHM, opt);

% Not implemented yet
% bidsFFX('specifyAndEstimate', opt, FWHM);
% bidsFFX('contrasts', opt, FWHM);
% bidsResults(opt, FWHM);
