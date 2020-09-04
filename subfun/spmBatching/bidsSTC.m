function bidsSTC(opt)
    % Performs SLICE TIMING CORRECTION of the functional data. The
    % script for each subject and can handle multiple sessions and multiple
    % runs.
    %
    % Slice timing units is in milliseconds to be BIDS compliant and not in slice number
    % as is more traditionally the case with SPM.
    %
    % In the case the slice timing information was not specified in the json FILES
    % in the BIDS data set (e.g it couldnt be extracted from the trento old scanner),
    % then add this information manually in opt.sliceOrder field.
    %
    % If this is empty the slice timing correction will not be performed
    %
    % If not specified this function will take the mid-volume time point as reference
    % to do the slice timing correction
    %
    % See README.md for more information about slice timing correction
    %
    % INPUT:
    % opt - options structure defined by the getOption function. If no inout is given
    % this function will attempt to load a opt.mat file in the same directory
    % to try to get some options

    % if input has no opt, load the opt.mat file
    if nargin < 1
        load('opt.mat');
        fprintf('opt.mat file loaded \n\n');
    end

    % load the subjects/Groups information and the task name
    [group, opt, BIDS] = getData(opt);

    fprintf(1, 'DOING SLICE TIME CORRECTION\n');

    % get slice order
    sliceOrder = getSliceOrder(opt, 1);
    if isempty(sliceOrder)
        return
    end

    % prefix of the files to look for
    prefix = getPrefix('STC', opt);

    % get metadata for STC
    % Note that slice ordering is assumed to be from foot to head. If it is not, enter
    % instead: TR - INTRASCAN_TIME - SLICE_TIMING_VECTOR

    % SPM accepts slice time acquisition as inputs for slice order (simplifies
    % things when dealing with multiecho data)
    nbSlices = length(sliceOrder); % unique is necessary in case of multi echo
    TR = opt.metadata.RepetitionTime;
    TA = TR - (TR / nbSlices);

    maxSliceTime = max(sliceOrder);
    minSliceTime = min(sliceOrder);
    if isempty(opt.STC_referenceSlice)
        referenceSlice = (maxSliceTime - minSliceTime) / 2;
    else
        referenceSlice = opt.STC_referenceSlice;
    end
    if referenceSlice > TA
        error('%s (%f) %s (%f).\n%s', ...
          'The reference slice time', referenceSlice, ...
          'is greater than the acquisition time', TA, ...
          ['Reference slice time must be in milliseconds ' ...
          'or leave it empty to use mid-acquisition time as reference.']);
    end

    matlabbatch = [];

    %% Loop through the groups, subjects, and sessions
    % For each group

    for iGroup = 1:length(group)

        groupName = group(iGroup).name;

        for iSub = 1:group(iGroup).numSub

            % Get the ID of the subject
            % (i.e SubNumber doesnt have to match the iSub if one subject is exluded)
            subNumber = group(iGroup).subNumber{iSub};

            printProcessingSubject(groupName, iSub, subNumber);

            %% GET FUNCTIOVAL FILES
            fprintf(1, ' BUILDING STC JOB : STC\n');

            [sessions, nbSessions] = getInfo(BIDS, subNumber, opt, 'Sessions');

            for iSes = 1:nbSessions

                % get all runs for that subject across all sessions
                [runs, nbRuns] = getInfo(BIDS, subNumber, opt, 'Runs', sessions{iSes});

                for iRun = 1:nbRuns

                    % get the filename for this bold run for this task
                    [fileName, subFuncDataDir] = getBoldFilename( ...
                      BIDS, ...
                      subNumber, sessions{iSes}, runs{iRun}, opt);

                    % check that the file with the right prefix exist
                    files = inputFileValidation(subFuncDataDir, prefix, fileName);

                    % add the file to the list
                    matlabbatch{1}.spm.temporal.st.scans{iRun} = cellstr(files);

                    disp(files{1});

                end

            end

            matlabbatch{1}.spm.temporal.st.nslices = nbSlices;
            matlabbatch{1}.spm.temporal.st.tr = TR;
            matlabbatch{1}.spm.temporal.st.ta = TA;
            matlabbatch{1}.spm.temporal.st.so = sliceOrder;
            matlabbatch{1}.spm.temporal.st.refslice = referenceSlice;
            % The following lines are commented out because those parameters
            % can be set in the spm_my_defaults.m
            % matlabbatch{1}.spm.temporal.st.prefix = spm_get_defaults('slicetiming.prefix');

            %% SAVE THE MATLABBATCH
            % Create the JOBS directory if it doesnt exist
            JOBS_dir = fullfile(opt.JOBS_dir, subNumber);
            [~, ~, ~] = mkdir(JOBS_dir);

            save(fullfile(JOBS_dir, 'jobs_matlabbatch_SPM12_STC.mat'), 'matlabbatch');
            spm_jobman('run', matlabbatch);

        end
    end

end