function results = funcevalCM(profile,settings)    %Nahtparameterauswertung
    
    results.method = 'CM';

    % gradient and curvature
    [gradient,curvature] = funcderivation(profile,settings.smoothparam);
    profile = profile(2:end-1,:);   % profile shorter than curvature and gradient
    
    % radius as reciprocal value of maximum curvature
    results.radius = 1/max(curvature(:,2));
    
    % normalized normal vector at weld toe
    results.DP_toe = find(curvature(:,2)==max(curvature(:,2)),1);
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