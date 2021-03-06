function printProcessingRun(groupName, iSub, subID, iSes, iRun)
  %
  % (C) Copyright 2019 CPP_SPM developers

  fprintf(1, ...
          [ ...
           '  PROCESSING GROUP: %s' ...
           'SUBJECT No.: %i ' ...
           'SUBJECT ID : %s ' ...
           'SESSION: %i ' ...
           'RUN:  %i \n'], ...
          groupName, iSub, subID, iSes, iRun);

end
