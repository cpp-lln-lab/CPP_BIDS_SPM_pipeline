% (C) Copyright 2021 CPP_SPM developers

function test_suite = test_bidsSmoothing %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_bidsSmoothingBasic()

  FWHM = 6;

  opt = setOptions('MoAE-preproc');

  opt.pipeline.type = 'preproc';
  opt.pipeline.name = 'cpp_spm-preproc';

  opt = checkOptions(opt);

  bidsSmoothing(FWHM, opt);

end
