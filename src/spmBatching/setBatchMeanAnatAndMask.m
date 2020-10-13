% (C) Copyright 2019 CPP BIDS SPM-pipeline developpers

function matlabbatch = setBatchMeanAnatAndMask(opt, funcFWHM, isMVPA, rfxDir)

    [group, opt, BIDS] = getData(opt);

    matlabbatch = {};

    % Create Mean Structural Image
    fprintf(1, 'BUILDING JOB: Create Mean Structural Image...');

    subCounter = 0;

    for iGroup = 1:length(group)

        groupName = group(iGroup).name;

        for iSub = 1:group(iGroup).numSub

            subCounter = subCounter + 1;

            subID = group(iGroup).subNumber{iSub};

            printProcessingSubject(groupName, iSub, subID);

            %% STRUCTURAL
            struct = spm_BIDS(BIDS, 'data', ...
                              'sub', subID, ...
                              'type', 'T1w');
            % we assume that the first T1w is the correct one (could be an
            % issue for data set with more than one
            struct = struct{1};

            [subStrucDataDir, file, ext] = spm_fileparts(struct);

            % get filename of the orginal file (drop the gunzip extension)
            if strcmp(ext, '.gz')
                fileName = file;
            elseif strcmp(ext, '.nii')
                fileName = [file ext];
            end

            files = inputFileValidation( ...
                                        subStrucDataDir, ...
                                        [spm_get_defaults('normalise.write.prefix'), ...
                                         spm_get_defaults('deformations.modulate.prefix')], ...
                                        fileName);

            matlabbatch{1}.spm.util.imcalc.input{subCounter, :} = files{1};

            %% Mask
            ffxDir = getFFXdir(subID, funcFWHM, opt, isMVPA);

            files = inputFileValidation(ffxDir, '', 'mask.nii');

            matlabbatch{2}.spm.util.imcalc.input{subCounter, :} = files{1};

        end
    end

    %% Generate the equation to get the mean of the mask and structural image
    % example : if we have 5 subjects, Average equation = '(i1+i2+i3+i4+i5)/5'
    nbImg = subCounter;
    imgRange  = 1:subCounter;

    tmpImg = sprintf('+i%i', imgRange);
    tmpImg = tmpImg(2:end);
    sumEquation = ['(', tmpImg, ')'];

    % meanStruct_equation = '(i1+i2+i3+i4+i5)/5'
    meanStruct_equation = ['(', tmpImg, ')/', num2str(nbImg)];

    % ------
    % TODO
    % not sure this makes sense for the mask as voxels that have no data for one
    % subject are excluded anyway !!!!

    % meanMask_equation = '(i1+i2+i3+i4+i5)>0.75*5'
    meanMask_equation = strcat(sumEquation, '>0.75*', num2str(nbImg));

    %% The mean structural will be saved in the RFX folder
    matlabbatch{1}.spm.util.imcalc.output = 'meanAnat.nii';
    matlabbatch{1}.spm.util.imcalc.outdir{:} = rfxDir;
    matlabbatch{1}.spm.util.imcalc.expression = meanStruct_equation;
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

    %% The mean mask will be saved in the RFX folder
    matlabbatch{2}.spm.util.imcalc.output = 'meanMask.nii';
    matlabbatch{2}.spm.util.imcalc.outdir{:} = rfxDir;
    matlabbatch{2}.spm.util.imcalc.expression = meanMask_equation;
    matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{2}.spm.util.imcalc.options.mask = 0;
    matlabbatch{2}.spm.util.imcalc.options.interp = 1;
    matlabbatch{2}.spm.util.imcalc.options.dtype = 4;

end
