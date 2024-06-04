function results = funcevalLSM(profile,settings) 
    
    results.method = 'LSM';

    % curvature
    [~,curvature] = funcderivation(profile,settings.smoothparam);
   
    % location of weld toe, starting and end point
    results.DP_toe = find(curvature(:,2)==max(curvature(:,2)),1)+1; %+1 since length diff between profiles and curvature
   
    results.DP_SP = results.DP_toe-(find(flipud(curvature(1:results.DP_toe-2,2))<=curvature(results.DP_toe,2)*settings.factor,1)-1);
    results.DP_EP = results.DP_toe+(find(curvature(results.DP_toe:end,2)<=curvature(results.DP_toe,2)*settings.factor,1)-1);
    
    DP_toe_all = (results.DP_SP:results.DP_EP)';

    % weld toe radius: least squares fit (analytical solution)
    A = ones(length(DP_toe_all),3);
    A(:,2) = profile(DP_toe_all,1);
    A(:,3) = profile(DP_toe_all,2);
    D = profile(DP_toe_all,1).^2+profile(DP_toe_all,2).^2;
    c = mldivide(A,D);

    MP_x = c(2)/2;
    MP_y = c(3)/2;

    results.radius = sqrt(c(1)+MP_x^2+MP_y^2);
    
    % coordinates of circle center, staring and end point
    results.MP = [MP_x MP_y];
    results.SP = profile(results.DP_SP,:);
    results.EP = profile(results.DP_EP,:);

    % max distance between profile and circle
    DP_MP_dist = sqrt(sum((results.MP-profile).^2,2));
    results.maxdist = max(abs(DP_MP_dist(DP_toe_all)-results.radius));

end