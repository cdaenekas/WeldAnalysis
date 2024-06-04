
function profile_filtered = funcfilterprofile(profile,settings)

    if strcmp(settings.filter,'Smoothing Spline')
        profile_filtered = profile;
        [f,~,~]= fit(profile(:,1),profile(:,2),'smoothingspline','SmoothingParam',settings.smoothparam);
        profile_filtered(:,2) = feval(f,profile_filtered(:,1));        
    elseif strcmp(settings.filter,'Moving Average')
        profile_filtered = profile;
        profile_filtered(:,2) = movmean(profile(:,2),settings.smoothparam);
    elseif strcmp(settings.filter,'Median')
        profile_filtered = profile;
        profile_filtered(:,2) = medfilt1(profile(:,2),settings.smoothparam,'truncate');
    elseif strcmp(settings.filter,'Moving Average + Median')
        profile_filtered = profile;
        if length(smoothparam)~=2
            error('A vector as Smoothparameter is required for this filtermethod ')
        end
        profile_filtered(:,2) = movmean(profile(:,2),settings.smoothparam(1));
        profile_filtered(:,2) = medfilt1(profile_filtered(:,2),settings.smoothparam(2),'truncate');
    elseif strcmp(settings.filter,'Median + Moving Average')
        profile_filtered = profile;
        if length(settings.smoothparam)~=2
            error('A vector as Smoothparameter is required for this filtermethod ')
        end
        profile_filtered(:,2) = medfilt1(profile(:,2),settings.smoothparam(1),'truncate');
        profile_filtered(:,2) = movmean(profile_filtered(:,2),settings.smoothparam(1));  
    elseif strcmp(settings.filter,'none')
        profile_filtered = profile;
    else
        error('Unknown filtermethod');
    end
end