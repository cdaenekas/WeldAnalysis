function profile_new = funcprofilesorting(profile,settings)
    if strcmp(settings.ordermethod,'ordered')
        xdelta = settings.orderdistance;
        xmin = ceil(min(profile(:,1)));
        xmax = floor(max(profile(:,1)));
	
	    [~,ia,~] = unique(profile(:,1));
	    profile = profile(ia,:);
        xq = xmin:xdelta:xmax;
        vq = interp1(profile(:,1),profile(:,2),xq,settings.interpmethod);

        profile_new = zeros(length(xq),2);
        profile_new(:,1) = xq';
        profile_new(:,2) = vq';
        %plot(profile(:,1),profile(:,2),profile_new(:,1),profile_new(:,2),':.');
    elseif strcmp(settings.ordermethod,'none')
        profile_new = profile;
    else
        error('Unknown ordermethod');
    end  
end