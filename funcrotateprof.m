function profile_new = funcrotateprof(profile,regr)
    
    % rotational angle
    rot_angle = -atand(regr(1));
    

    profile_new = profile;
    profile_new(:,1) = profile(:,1)*cosd(rot_angle)-profile(:,2)*sind(rot_angle);
    profile_new(:,2) = profile(:,1)*sind(rot_angle)+profile(:,2)*cosd(rot_angle)-regr(2);


    if false
        close all
        figure
        plot(profile(:,1),profile(:,2))
        hold on
        plot(profile_new(:,1),profile_new(:,2))
        yline(0)
        axis equal
    end


end