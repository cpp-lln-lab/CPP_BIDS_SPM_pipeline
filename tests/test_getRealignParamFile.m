function test_suite = test_getRealignParamFile %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_getRealignParamFileBasic()

    subID = '01';
    funcFWHM = 6;
    iSes = 1;
    iRun = 1;

    opt.taskName = 'vislocalizer';
    opt.derivativesDir = fullfile(fileparts(mfilename('fullpath')), 'dummyData');
    opt.groups = {''};
    opt.subjects = {'01'};

    [~, opt, BIDS] = getData(opt);

    boldFileName = getBoldFilenameForFFX(BIDS, opt, subID, funcFWHM, iSes, iRun);
    realignParamFile = getRealignParamFile(opt, boldFileName, funcFWHM);

    expectedFileName = fullfile(fileparts(mfilename('fullpath')), ...
                                'dummyData', 'derivatives', 'SPM12_CPPL', 'sub-01', ...
                                'ses-01', 'func', ...
                                'rp_sub-01_ses-01_task-vislocalizer_bold.txt');

    assertEqual(expectedFileName, realignParamFile);

end

function test_getRealignParamFileNativeSpace()

    subID = '01';
    funcFWHM = 6;
    iSes = 1;
    iRun = 1;

    opt.taskName = 'vislocalizer';
    opt.derivativesDir = fullfile(fileparts(mfilename('fullpath')), 'dummyData');
    opt.groups = {''};
    opt.subjects = {'01'};
    opt.space = 'T1w';

    [~, opt, BIDS] = getData(opt);

    boldFileName = getBoldFilenameForFFX(BIDS, opt, subID, funcFWHM, iSes, iRun);
    realignParamFile = getRealignParamFile(opt, boldFileName, funcFWHM);

    expectedFileName = fullfile(fileparts(mfilename('fullpath')), ...
                                'dummyData', 'derivatives', 'SPM12_CPPL', 'sub-01', ...
                                'ses-01', 'func', ...
                                'rp_sub-01_ses-01_task-vislocalizer_bold.txt');

    assertEqual(expectedFileName, realignParamFile);

end

function test_getRealignParamFileError()

    subID = '01';
    goodFuncFWHM = 6;
    badFuncFWHM = 8;
    iSes = 1;
    iRun = 1;

    opt.taskName = 'vislocalizer';
    opt.derivativesDir = fullfile(fileparts(mfilename('fullpath')), 'dummyData');
    opt.groups = {''};
    opt.subjects = {'01'};
    opt.space = 'T1w';

    [~, opt, BIDS] = getData(opt);

    boldFileName = getBoldFilenameForFFX(BIDS, opt, subID, goodFuncFWHM, iSes, iRun);

    assertExceptionThrown( ...
                          @()getRealignParamFile(opt, boldFileName, badFuncFWHM), ...
                          'getRealignParamFile:nonExistentFile');

end
