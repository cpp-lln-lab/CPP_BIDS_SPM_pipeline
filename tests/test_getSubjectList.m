function test_suite = test_getSubjectList %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getSubjectListNone()

  opt = setOptions();

  opt = checkOptions(opt);

  BIDS = bids.layout(opt.derivativesDir);

  %% Get all groups all subjects
  opt = getSubjectList(BIDS, opt);

  assertEqual(opt.subjects, ...
              {'01' '02' 'blind01' 'blind02' 'ctrl01' 'ctrl02'}');

end

function test_getSubjectListGroup()

  opt = setOptions();

  opt = checkOptions(opt);

  BIDS = bids.layout(opt.derivativesDir);

  %% Get all subjects of a group and a subject from another group
  opt.groups = {'blind'};
  opt.subjects = {'ctrl01'};

  opt = getSubjectList(BIDS, opt);

  % 'sub-02' is defined a blind in the participants.tsv
  assertEqual(opt.subjects, {'02', 'blind01', 'blind02', 'ctrl01'}');

end

function test_getSubjectListBasic()

  opt = setOptions();

  opt = checkOptions(opt);

  BIDS = bids.layout(opt.derivativesDir);

  %% Get some specified subjects
  opt.groups = {''};
  opt.subjects = {'01', '02'; 'ctrl02', 'blind02'};

  opt = getSubjectList(BIDS, opt);

  assertEqual(opt.subjects, {'01', '02', 'blind02', 'ctrl02'}');

end

function test_getSubjectListErrorSubject()

  opt = setOptions();

  opt.subjects = {'03'};

  opt = checkOptions(opt);

  BIDS = bids.layout(opt.derivativesDir);

  assertExceptionThrown( ...
                        @()getSubjectList(BIDS, opt), ...
                        'getSubjectList:noMatchingSubject');

end

function opt = setOptions()
  opt.derivativesDir = fullfile(fileparts(mfilename('fullpath')), ...
                                'dummyData', ...
                                'derivatives', ...
                                'cpp_spm');
  opt.taskName = 'vismotion';
  opt.zeropad = 2;
end