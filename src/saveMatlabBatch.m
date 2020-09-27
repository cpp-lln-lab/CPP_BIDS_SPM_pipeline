function saveMatlabBatch(batch, batchType, opt, subID)
    % saveMatlabBatch(batch, batchType, opt, subID)
    %
    % Also save some basic environnment info
    %
    % batch : matlabbatch
    % batchType: (string) name to give to the batch file
    %
    %

    if nargin < 4 || isempty(subID)
        subID = 'group';
    else
        subID = ['sub-' subID];
    end

    jobsDir = fullfile(opt.jobsDir, subID);
    [~, ~, ~] = mkdir(jobsDir);

    filename = sprintf( ...
        '%s_jobs_matlabbatch_SPM12_%s.mat', ...
        datestr(now, 'yyyymmdd_HHMM'), ...
        batchType);

    [OS, GeneratedBy] = getEnvInfo();
    GeneratedBy(1).Description = batchType;

    save(fullfile(jobsDir, filename), 'batch', 'OS', 'GeneratedBy');

    % write as json for more "human readibility"
    opts.indent = '    ';

    json.matlabbach = batch;
    json.GeneratedBy = GeneratedBy;
    json.OS = OS;

    spm_jsonwrite( ...
        fullfile(jobsDir, strrep(filename, '.mat', '.json')), ...
        json, opts);

end
