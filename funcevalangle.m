function results = funcevalangle(method,profile,settings,radiusresults)
    [gradient,~] = funcderivation(profile,settings.smoothparam);
    if strcmp(method,'MAX')
        if settings.smoothlen == 0
            results.angle = atand(max(abs(gradient(:,2))));
            results.DP = find(abs(gradient(:,2))==max(abs(gradient(:,2))),1);
            results.sign = sign(gradient(results.DP,2));
        else
            % data point at max gradient
            DP = find(abs(gradient(:,2))==max(abs(gradient(:,2))),1);
            DP_all = DP+1:length(profile);
            DP_nr = find(cumsum(sqrt(diff(profile(DP_all,1)).^2 + diff(profile(DP_all,2)).^2))>=settings.smoothlen,1)-1;

            if isempty(DP_nr) || DP_nr == 0
                DP_nr = 5;
            end
            
            % using moving average with DP_nr corresponding to smoothlength
            results.angle = atand(max(abs(movmean(gradient(:,2),DP_nr))));
            results.DP = DP;
            results.sign = sign(gradient(results.DP,2));
        end

    elseif strcmp(method,'END')
        if settings.smoothlen == 0
            % gradient at DP_EP based on radius evaluation
            results.angle = atand(abs(gradient(radiusresults.DP_EP-1,2)));
            
        else
            DP_all = radiusresults.DP_EP:length(profile);
            DP_nr  = find(cumsum(sqrt(diff(profile(DP_all,1)).^2 + diff(profile(DP_all,2)).^2))>=settings.smoothlen,1)-1;

            DP_all = radiusresults.DP_EP:radiusresults.DP_EP+DP_nr;
        
            p = polyfit(profile(DP_all,1),profile(DP_all,2),1);
            results.angle = abs(atand(p(1)));

        end
        results.DP = radiusresults.DP_EP-1;
        results.sign = sign(gradient(results.DP,2));


    else
        error('method does not exist')
    end 
end