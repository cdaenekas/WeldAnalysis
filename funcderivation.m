function [gradient,curvature] = funcderivation(profile,smoothparam)
    
    if and(smoothparam<1.0,smoothparam>=0.8)
        settings.smoothparam = smoothparam;
        settings.filter = 'Smoothing Spline';
        profile = funcfilterprofile(profile,settings);
    elseif smoothparam == 1.0
        %profile = profile;
    else
        error('smoothparam must be between 0.8 and 1.0!')
    end

    % first derivative
    diff1 = zeros(length(profile)-1,2);
    diff1(:,1) = profile(1:end-1,1)+diff(profile(:,1))/2;
    diff1(:,2) = diff(profile(:,2))./diff(profile(:,1));

    % second derivative
    diff2 = zeros(length(profile)-2,2); 
    diff2(:,1) = diff1(1:end-1,1)+diff(diff1(:,1))/2;
    diff2(:,2) = diff(diff1(:,2))./diff(diff1(:,1));
    
	% gradient (=first derivative but length as second derivative)
	gradient(:,1) = diff1(1:end-1,1)+diff(diff1(:,1))/2;
	gradient(:,2) = diff1(1:end-1,2)+diff(diff1(:,2))/2;
	
    % curvature
	curvature(:,1) = gradient(:,1);
    curvature(:,2) = diff2(:,2)./((1+gradient(:,2).^2).^(3/2)); 
 
end