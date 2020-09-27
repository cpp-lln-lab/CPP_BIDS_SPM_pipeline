function opt = getOption()
    %   __  ____  ____     _      _    _
    %  / _)(  _ \(  _ \   | |    / \  | )
    % ( (_  )___/ )___/   | |_  / _ \ | \
    %  \__)(__)  (__)     |___||_/ \_||__)
    %
    % Thank you for using the CPP lap pipeline - version 0.0.3.
    %
    % Current list of contributors includes
    %  Mohamed Rezk
    %  Rémi Gau
    %  Olivier Collignon
    %  Ane Gurtubay
    %  Marco Barilari
    %
    % Please cite using the following DOI:
    %  https://doi.org/10.5281/zenodo.3554332
    %
    % For bug report, suggestions for improvements or contributions see our github repo:
    %  https://github.com/cpp-lln-lab/CPP_BIDS_SPM_pipeline

    % returns a structure that contains the options chosen by the user to run
    % slice timing correction, pre-processing, FFX, RFX.

    if nargin < 1
        opt = [];
    end

    % group of subjects to analyze
    opt.groups = {''};
    % suject to run in each group
    opt.subjects = {[]};

    % task to analyze
    opt.taskName = 'visMotion';

    % The directory where the data are located
    opt.dataDir = '/home/remi/BIDS/visMotion/derivatives/';

    % specify the model file that contains the contrasts to compute
    opt.model.univariate.file = ...
        '/home/remi/github/CPP_BIDS_SPM_pipeline/model-visMotionLoc_smdl.json';
    opt.model.multivariate.file = '';

    % specify the result to compute
    % Contrasts.Name has to match one of the contrast defined in the model json file
    opt.result.Steps(1) = struct( ...
        'Level',  'dataset', ...
        'Contrasts', struct( ...
                        'Name', 'VisMot_gt_VisStat', ... %
                        'Mask', false, ... % this might need improving if a mask is required
                        'MC', 'FWE', ... FWE, none, FDR
                        'p', 0.05, ...
                        'k', 0, ...
                        'NIDM', true));

    % Options for slice time correction
    % If left unspecified the slice timing will be done using the mid-volume acquisition
    % time point as reference.
    % Slice order must be entered in time unit (ms) (this is the BIDS way of doing things)
    % instead of the slice index of the reference slice (the "SPM" way of doing things).
    % More info here: https://en.wikibooks.org/wiki/SPM/Slice_Timing
    opt.sliceOrder = [];
    opt.STC_referenceSlice = [];

    % Options for normalize
    % Voxel dimensions for resampling at normalization of functional data or leave empty [ ].
    opt.funcVoxelDims = [];

    % Suffix output directory for the saved jobs
    opt.jobsDir = fullfile( ...
        opt.dataDir, '..', 'derivatives', ...
        'SPM12_CPPL', 'JOBS', opt.taskName);

    % Save the opt variable as a mat file to load directly in the preprocessing
    % scripts
    save('opt.mat', 'opt');

end
