function opt = checkOptions(opt)
    % opt = checkOptions(opt)
    %
    % we check the option inputs and add any missing field with some defaults

    if nargin < 1
        opt = struct();
    end

    fieldsToSet = setDefaultOption();

    opt = setDefaultFields(opt, fieldsToSet);

    if ~all(cellfun(@ischar, opt.groups))

        disp(opt.groups);

        errorStruct.identifier = 'checkOptions:groupNotString';
        errorStruct.message = sprintf( ...
            'All group names should be string.');
        error(errorStruct);

    end

    if ~isempty (opt.STC_referenceSlice) && length(opt.STC_referenceSlice) > 1

        errorStruct.identifier = 'checkOptions:refSliceNotScalar';
        errorStruct.message = sprintf( ...
            'options.STC_referenceSlice should be a scalar. \nCurrent value is: %d', ...
            opt.STC_referenceSlice);
        error(errorStruct);

    end

    if ~isempty (opt.funcVoxelDims) && length(opt.funcVoxelDims) ~= 3

        errorStruct.identifier = 'checkOptions:voxDim';
        errorStruct.message = sprintf( ...
            'opt.funcVoxelDims should be a vector of length 3. \nCurrent value is: %d', ...
            opt.funcVoxelDims);
        error(errorStruct);

    end

    opt = orderfields(opt);

end

function fieldsToSet = setDefaultOption()
    % this defines the missing fields

    % group of subjects to analyze
    fieldsToSet.groups = {''};
    % suject to run in each group
    fieldsToSet.subjects = {[]};
    fieldsToSet.zeropad = 2;

    % task to analyze
    fieldsToSet.taskName = '';

    % space where we conduct the analysis
    fieldsToSet.space = 'MNI';

    % The directory where the derivatives are located
    fieldsToSet.dataDir = '';

    % fieldsToSet for slice time correction
    fieldsToSet.STC_referenceSlice = []; % reference slice: middle acquired slice
    fieldsToSet.sliceOrder = []; % To be used if SPM can't extract slice info

    % fieldsToSet for normalize
    % Voxel dimensions for resampling at normalization of functional data or leave empty [ ].
    fieldsToSet.funcVoxelDims = [];

    % Suffix output directory for the saved jobs
    fieldsToSet.jobsDir = '';

    % specify the model file that contains the contrasts to compute
    fieldsToSet.contrastList = {};
    fieldsToSet.model.file = '';

    % specify the results to compute
    fieldsToSet.result.Steps = [];
end
