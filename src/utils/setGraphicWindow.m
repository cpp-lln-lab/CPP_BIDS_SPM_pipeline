% (C) Copyright 2019 CPP BIDS SPM-pipeline developers

function [interactiveWindow, graphWindow, cmdLine] = setGraphicWindow()

  interactiveWindow = [];
  graphWindow = [];
  cmdLine = true;

  if ~spm('CmdLine') && ~isOctave

    try
      [interactiveWindow, graphWindow, cmdLine] = spm('FnUIsetup');
    catch
      warning('Could not open a graphic window. No figure will be created.');
    end

  else

    msg = [
           'Could not open a graphic window. Possible reasons:\n', ...
           ' - running SPM from the matlab command line only,\n' ...
           ' - running under octave.'];
    warning(sprintf(msg));

  end

end
