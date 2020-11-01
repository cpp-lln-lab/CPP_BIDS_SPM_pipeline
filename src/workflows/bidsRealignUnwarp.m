% (C) Copyright 2020 CPP BIDS SPM-pipeline developers

function bidsRealignUnwarp(opt)
  % bidsRealignReslice(opt)
  %
  % The scripts realigns the functional
  % Assumes that bidsSTC has already been run

  %% TO DO
  % find a way to paralelize this over subjects

  % if input has no opt, load the opt.mat file
  if nargin < 1
    opt = [];
  end
  opt = loadAndCheckOptions(opt);

  % load the subjects/Groups information and the task name
  [group, opt, BIDS] = getData(opt);

  %% Loop through the groups, subjects, and sessions
  for iGroup = 1:length(group)

    groupName = group(iGroup).name;

    for iSub = 1:group(iGroup).numSub

      % Get the ID of the subject
      % (i.e SubNumber doesnt have to match the iSub if one subject
      % is exluded for any reason)
      subID = group(iGroup).subNumber{iSub}; % Get the subject ID

      printProcessingSubject(groupName, iSub, subID);

      matlabbatch = [];
      [matlabbatch, ~] = setBatchRealign( ...
                                         matlabbatch, ...
                                         BIDS, ...
                                         subID, ...
                                         opt, ...
                                         'realignUnwarp');

      saveMatlabBatch(matlabbatch, 'realign_unwarp', opt, subID);

      spm_jobman('run', matlabbatch);

    end
  end

end
