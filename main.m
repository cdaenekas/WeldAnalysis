
%%
% list of files for evaluation
list = dir(fullfile('examples','artificial butt welds','*.asc'));

% load settings for data procession
settings = loadsettings;

% empty table for results
allresults = NaN(length(list),6);

for loop_nr = 1:length(list)
    % import data
    data = importdata(fullfile(list(loop_nr).folder,list(loop_nr).name)); 
    
    % create profile variable 
    profile = data.data(:,1:2);
    profile = profile*10;           % conversion from cm to mm
    profile = flipud(profile);      % flip of matrix: data points from base material ending on weld seam

    % data procession
    profile = funcremoveoutlier(profile,settings);
    profile = funcfilterprofile(profile,settings);
    profile = funcprofilesorting(profile,settings);

    % radius evaluation
    results_CM  = funcevalCM(profile,settings.CM);
    results_LSM = funcevalLSM(profile,settings.LSM);
    results_IM  = funcevalIM(profile,settings.IM);

    % angle evaluation
    angle_MAX = funcevalangle('MAX',profile,settings.Angle,[]);
    angle_END_LSM = funcevalangle('END',profile,settings.Angle,results_LSM);
    angle_END_IM = funcevalangle('END',profile,settings.Angle,results_IM);

    % save results in table
    allresults(loop_nr,[1 2 3]) = [results_CM.radius results_LSM.radius results_IM.radius];
    allresults(loop_nr,[4 5 6]) = [angle_MAX.angle angle_END_LSM.angle angle_END_IM.angle];
    
    % plot figure
    if strcmp(settings.plotresult,'on')
        funcfigresult(profile,{results_CM results_LSM results_IM},{angle_MAX angle_END_LSM angle_END_IM})
    end
end