function DP_notch = funcnotchlocalization(profile,gradient)

    y_weld = 0.3;
    delta_x_toe = 1;
    
    
    DP_end = find(profile(:,2)>=y_weld,1);

    DP_turn = DP_end-find(gradient(DP_end:-1:1,2)<=0,1);
	
    %DP_start = find((profile(DP_turn,1)-delta_x_toe)<profile(:,1),1);
    DP_start = DP_turn+1-find(abs(profile(DP_turn:-1:1,1)-profile(DP_turn,1))>=delta_x_toe,1);

    DP_notch = (DP_start:DP_end);

    if false
        figure
        plot(profile(:,1),profile(:,2))
        hold on
        plot(gradient(:,1),gradient(:,2))

        xline(profile(DP_end,1))
        xline(profile(DP_turn,1))
        xline(profile(DP_start,1))
        yline(0)
    end
end