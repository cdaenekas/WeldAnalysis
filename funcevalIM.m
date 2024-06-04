function results = funcevalIM(profile,settings)    %Nahtparameterauswertung
   
    results.method = 'IM';

    % further settings
    radius_min= 0.01;
    radius_max= 10;
    radius_delta=0.01;

    delta_x_notch = 2;
    
    % curvature
    [~,curvature] = funcderivation(profile,settings.smoothparam);

    % location of weld toe
	DP_toe = find(curvature(:,2)>=max(curvature(:,2)*0.9),1)+1;

    DP_toe_start = DP_toe-find(flipud(abs(profile(1:DP_toe,1)-profile(DP_toe,1)))>=delta_x_notch,1)+1;
    DP_toe_end = DP_toe+find(abs(profile(DP_toe:end,1)-profile(DP_toe,1))>=delta_x_notch,1)+1;
    

    % correction of inclination
        %[~,m,b] = regression(profile(1:DP_toe_start,1),profile(1:DP_toe_start,2),'one');
        m= 0;
        %b = 5;
        
        av=[1;m];                           % directional vector regression line
        av_ortho=[-av(2,1);av(1,1)];        % orthogonal vector regression line
        av_ortho_norm=av_ortho/(sqrt(av(1,1)^2+av(2,1)^2)); %normalized vectors (length = 1)

    local_y = profile(:,1)*sind(atand(m))+profile(:,2)*cosd(atand(m));

    % Loop over all data points to be analysed as possible start points (SP_all)
    bestQ   = 1000;        % high inital value for quotient

    for DP_SP = DP_toe_start:DP_toe_end
        SP_x = profile(DP_SP,1);
        SP_y = profile(DP_SP,2);
        for rad = radius_min:radius_delta:radius_max
            % centre point coordinates
            MP_x= SP_x+av_ortho_norm(1,1)*rad;
            MP_y= SP_y+av_ortho_norm(2,1)*rad;
            
            % determination endpoint DP_EP
            MPp_x = profile(DP_SP+1:size(profile,1),1);
            MPp_y = profile(DP_SP+1:size(profile,1),2);
            DP_EP = DP_SP+find((MPp_x-MP_x).^2+(MPp_y-MP_y).^2<=rad^2+0.01,1,'last')-1;
            
            if local_y(DP_EP)>=local_y(DP_SP)+min(0.1,settings.crit1*rad)

                % max distance between profile and circle
                delta_ri=zeros(DP_EP-DP_SP-1,1);
                for w = DP_SP+1:DP_EP-1
                    MPq_x=profile(w,1);
                    MPq_y=profile(w,2);
                    delta_ri(w-DP_SP,1) = sqrt((sqrt((MPq_x-MP_x)^2+(MPq_y-MP_y)^2)-rad)^2);   % abs values
                end

                % count distances larger than criterium
                count_larger=size(find(delta_ri(:,1)>=settings.crit2),1);

                if count_larger == 0
                    sum_delta=sum(delta_ri(:,1));
                    n_DP=size(delta_ri,1);
                    Qk = sum_delta/(n_DP^2);

                    if n_DP >= settings.crit3 % check criterium 3
                
                        if Qk < bestQ % check if quotient is lower than previous value
                            bestQ = Qk;

                            % saving results
                                % weld toe radius
                                results.radius = rad;
    
                                % coordinates of circle center, staring and end point
                                results.MP = [MP_x MP_y];
                                results.SP = profile(DP_SP,:);
                                results.EP = profile(DP_EP,:);
    
                                % max dist
                                results.maxdist = max(delta_ri);

                                % data point numbers
                                results.DP_SP = DP_SP;
                                results.DP_EP = DP_EP;
                        end
                    end % end if cond crit3 n_DP
                end % end if cond crit2 max dist
            end % end if cond crit1 EP
        end % end loop rad
    end % end loop DP_SP

end % end function