%%
% list of files for evaluation
list = loadfilelist('all');

% load settings for data procession
settings = loadsettings;



%%

for loop_nr = 1:length(list)
    % import data
    data = importdata(fullfile(list(loop_nr).folder,list(loop_nr).name));

    y_cuts = unique(data(:,2));

    VarNames = {'y','radius_CM','radius_LSM','radius_IM','angle_MAX','angle_END_LSM','angle_END_IM',...
                'inclination','depth','x_SP_CM','x_SP_LSM','x_SP_IM','x_angle_DP','y_max'};
    
    alldata = NaN(length(y_cuts),length(VarNames),2);

    for cut_nr = 1:length(y_cuts)                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% parfor                                
        cut = data(data(:,2)==y_cuts(cut_nr),[1 3]);

        % data procession
        cut = funcremoveoutlier(cut,settings);
        cut = funcfilterprofile(cut,settings);
        cut = funcprofilesorting(cut,settings);

        DP_maxy = find(cut(:,2) == max(cut(:,2)),1);
        
        close all

        for notch = 1:2
            
            if notch == 1
                profile = cut(1:DP_maxy,:);
            elseif notch == 2
                profile = cut(DP_maxy:end,:);
                profile = flipud(profile);
            end

            if length(profile)>300 % needs modification
                % determination and correction of inclination
                regr    = funcgetinclination(profile);
                profile = funcrotateprof(profile,regr);

                profile = profile(profile(:,2)<1.7,:);
                
                % radius evaluation
                try
                    results_radius_CM = funcevalCM(profile,settings.CM);
                catch 
                    results_radius_CM.radius = NaN;
                    results_radius_CM.SP = [NaN NaN];
                end
                try
                    results_radius_LSM = funcevalLSM(profile,settings.LSM);
                catch
                    results_radius_LSM.radius = NaN;
                    results_radius_LSM.SP = [NaN NaN];
                end
                try
                    results_radius_IM  = funcevalIM(profile,settings.IM);                
                catch
                    results_radius_IM.radius = NaN;
                    results_radius_IM.SP = [NaN NaN];
                end
                % angle evaluation
                angle_MAX = funcevalangle('MAX',profile,settings.Angle,[]);
                try
                    angle_END_LSM = funcevalangle('END',profile,settings.Angle,results_radius_LSM);
                catch 
                    angle_END_LSM.angle = NaN;
                    angle_END_LSM.DP = NaN;
                    angle_END_LSM.sign = NaN;
                end
                try
                    angle_END_IM = funcevalangle('END',profile,settings.Angle,results_radius_IM);
                catch 
                    angle_END_IM.angle = NaN;
                    angle_END_IM.DP = NaN;
                    angle_END_IM.sign = NaN;
                end
    
                % determination of undercut
                depth = min(profile(:,2));

                % save results in table
                try
                    alldata(cut_nr,:,notch) = [y_cuts(cut_nr) results_radius_CM.radius,...
                            results_radius_LSM.radius results_radius_IM.radius,...
                            angle_MAX.angle angle_END_LSM.angle angle_END_IM.angle,...
                            regr(1)    depth results_radius_CM.SP(1)   results_radius_LSM.SP(1) results_radius_IM.SP(1),...
                            profile(angle_MAX.DP,1)  max(profile(:,2))];
                catch 

                end

                settings.plotresult = 'on';
                
                
                % plot figure
                if strcmp(settings.plotresult,'on')
                    funcfigresult(profile,{results_radius_CM results_radius_LSM results_radius_IM },{angle_MAX})
                end
            end

        end % end loop notch
    end % end loop cuts
    
    alldata = transfertotable(alldata,VarNames);

    b_weld = mean(alldata{2}.x_SP_LSM(~isoutlier(alldata{2}.x_SP_LSM)),'omitnan')-...
             mean(alldata{1}.x_SP_LSM(~isoutlier(alldata{1}.x_SP_LSM)),'omitnan');

    h_weld = mean([mean(alldata{1}.y_max(~isoutlier(alldata{1}.y_max)),'omitnan'),...
                   mean(alldata{2}.y_max(~isoutlier(alldata{2}.y_max)),'omitnan')]);

    path = strrep(list(loop_nr).folder,'1_Aufbereitete_Daten','2c_Ergebnisse_MATLAB_neu');
    file = strrep(list(loop_nr).name,'txt','mat');
    
    %save locally first
    %save(file,"alldata","results","b_weld","h_weld")
    save(file,"alldata","b_weld","h_weld")
    
    % than try to move to server
    try
        if ~exist(path)
            mkdir(path)
        end
        movefile(file,path)
    catch
        warning(['couldnt move ' file])
    end
    
end % end loop files

%%

function results = loademptyresultstable(rows,VarNames)
    
    data = NaN(rows,length(VarNames));
    results = array2table(data,'VariableNames',VarNames);

end

function results = resultsomitoutlier(data)

    results = loademptyresultstable(height(data),{'radius','angle','undercut'});

    results.radius = data.radius;
    results.radius(isoutlier(data.x_EP)) = NaN;

    results.angle = data.angle;
    results.angle(isoutlier(data.x_angle_DP)) = NaN;

    results.undercut = data.undercut;


end

function alldata_new = transfertotable(alldata,Varnames)
    
    alldata_new{1} = array2table(alldata(:,:,1),"VariableNames",Varnames);
    alldata_new{2} = array2table(alldata(:,:,2),"VariableNames",Varnames);

end