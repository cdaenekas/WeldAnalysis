
function profile_new = funcremoveoutlier(profile,settings)
    if strcmp(settings.outliermethod,'remove')
        [newcoord,TF] = rmoutliers(profile(:,2),'movmedian',1,'SamplePoints',profile(:,1));
        profile_new(:,1) = profile(~TF,1);
        profile_new(:,2) = newcoord;
    elseif strcmp(settings.outliermethod,'none')
        profile_new = profile;
    else
        error('Unknown removemode');
    end
end