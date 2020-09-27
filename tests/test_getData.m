function test_suite = test_getData %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_getDataBasic()
    % Small test to ensure that getData returns what we asked for

    opt.dataDir = fullfile(fileparts(mfilename('fullpath')), 'dummyData', 'derivatives');
    opt.taskName = 'vismotion';
    opt.zeropad = 2;

    %% Get all groups all subjects
    opt.groups = {''};
    opt.subjects = {[]};

    [group] = getData(opt);

    assert(isequal(group(1).name, ''));
    assert(isequal(group.numSub, 11));
    assert(isequal(group.subNumber, ...
        { ...
        '01' '02' ...
        'blind01'  'blind02'  ...
        'cat01'  'cat02'  ...
        'cont01'  'cont02' 'cont03' ...
        'ctrl01'  'ctrl02'}));

    %% Get some subjects of some groups
    opt.groups = {'cont', 'cat'};
    opt.subjects = {[1 3], 2};

    [group] = getData(opt);

    assert(isequal(group(1).name, 'cont'));
    assert(isequal(group(1).numSub, 2));
    assert(isequal(group(1).subNumber, {'cont01' 'cont03'}));
    assert(isequal(group(2).name, 'cat'));
    assert(isequal(group(2).numSub, 1));
    assert(isequal(group(2).subNumber, {'cat02'}));

    %% Get all subjects of some groups
    opt.groups = {'cont', 'cat'};
    opt.subjects = {[], []};

    [group] = getData(opt);

    assert(isequal(group(1).name, 'cont'));
    assert(isequal(group(1).numSub, 3));
    assert(isequal(group(1).subNumber, {'cont01' 'cont02' 'cont03'}));
    assert(isequal(group(2).name, 'cat'));
    assert(isequal(group(2).numSub, 2));
    assert(isequal(group(2).subNumber, {'cat01' 'cat02'}));

    %% Get some specified subjects
    opt.groups = {''};
    opt.subjects = {'01', 'cont01', 'cat02', 'ctrl02', 'blind01'};

    [group] = getData(opt);

    assert(isequal(group(1).name, ''));
    assert(isequal(group(1).numSub, 5));
    assert(isequal(group(1).subNumber, {'01', 'cont01', 'cat02', 'ctrl02', 'blind01'}));

    %% Only get anat metadata
    opt.groups = {''};

    opt.subjects = {'01'};

    [~, opt] = getData(opt, [], 'T1w');

    assert(isequal(opt.metadata.RepetitionTime, 2.3));

end
