function results = funcevalCM(profile,settings)    %Nahtparameterauswertung
    
    results.method = 'CM';
    
    % Localization
    [gradient_smooth,~] = funcderivation(profile,settings.smoothparam);
    DP_notch = funcnotchlocalization(profile,gradient_smooth);

    % gradient and curvature
    [gradient,curvature] = funcderivation(profile,1);
    profile = profile(2:end-1,:);   % profile shorter than curvature and gradient
   
    % radius as reciprocal value of maximum curvature
    results.radius = 1/max(curvature(DP_notch,2));

    if false
        plot(profile(:,1),profile(:,2))
        hold on
        %plot(gradient(:,1),gradient(:,2))
        plot(curvature(:,1),curvature(:,2))
        plot(curvature_smooth(:,1),curvature_smooth(:,2))
    end
    
    % normalized normal vector at weld toe
    results.DP_toe = find(curvature(:,2)==max(curvature(DP_notch,2)),1);
    normalv = [-gradient(results.DP_toe,2) 1];
    normalv = normalv/(sqrt(normalv(1)^2+normalv(2)^2));

    % weld toe and circle centre coordinates    
    results.SP = [profile(results.DP_toe,1) profile(results.DP_toe,2)];
    results.MP = results.SP+normalv*results.radius;

    % max distance between profile and circle
    DP_MP_dist = sqrt(sum((results.MP-profile).^2,2));
    dp_start = find(DP_MP_dist<=results.radius,1);
    dp_end = find(DP_MP_dist<=results.radius,1,'last');
    results.maxdist = max(abs(DP_MP_dist(dp_start:dp_end)-results.radius));
    if isempty(results.maxdist)
        results.maxdist = NaN;
    end

end