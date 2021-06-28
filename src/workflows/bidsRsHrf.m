function bidsRsHrf(opt)
  %
  %
  % (C) Copyright 2021 CPP_SPM developers

  [BIDS, opt] = setUpWorkflow(opt, 'estimate HRF from rest data');

  manageWorkersPool('close', opt);

  for iSub = 8:numel(opt.subjects)

    subLabel = opt.subjects{iSub};

    printProcessingSubject(iSub, subLabel, opt);

    matlabbatch = [];

    matlabbatch = setBatchRsHRF(matlabbatch, BIDS, opt, subLabel);

    batchName = 'estimate_hrf';

    saveAndRunWorkflow(matlabbatch, batchName, opt, subLabel);

  end

end
