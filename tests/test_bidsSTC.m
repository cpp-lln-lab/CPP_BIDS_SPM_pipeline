% (C) Copyright 2021 CPP_SPM developers

function test_suite = test_bidsSTC %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_bidsSpatialSTCBasic()

  opt = setOptions('MoAE');

  bidsCopyInputFolder(opt, true());

  opt.pipeline.type = 'preproc';

  bidsSTC(opt);

end
