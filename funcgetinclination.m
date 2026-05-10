function regr = funcgetinclination(profile)
    
    DP_start = 50;

    [gradient,curvature] = funcderivation(profile,0.5);
    
    % area with curvature almost zero
    DP_curv = DP_start+find(abs(curvature(DP_start:end,2))>=0.02,1);

    % value of gradient in this area
    mean_grad = mean(gradient(1:DP_curv,2));

    % extending area that has equal gradient value
    grad_max = mean_grad+abs(mean_grad);
    grad_min = mean_grad-abs(mean_grad);
    DP_grad = DP_curv+find(or(gradient(DP_curv:end,2)<=grad_min,gradient(DP_curv:end,2)>=grad_max),1);

    if DP_grad <= 10
        error('regression might fail')
    end

    % regression in that area
    regr = polyfit(profile(1:DP_grad,1),profile(1:DP_grad,2),1);

    if false
        close all
        plot(profile(:,1),profile(:,2))
        hold on
        plot(gradient(:,1),gradient(:,2))
        plot(curvature(:,1),curvature(:,2))
        plot(profile(DP_curv,1),profile(DP_curv,2),'x')
        plot(profile(DP_grad,1),profile(DP_grad,2),'x')
        axis equal
    end

end