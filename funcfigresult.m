function funcfigresult(profile,radiusresults,angleresults)
    
    % settings
    colors = {'b' 'r' 'g'};    
    circlestyles = {'-' '--' '--'};
    linestyles = {'-' '--' '--'};


    % plot
    fig = figure('Units','centimeters','Position',[10 10 8 6]);
    ax = axes;
    
    hold on
    
    % plot circles
    if ~isempty(radiusresults)
        for circle_nr = 1:length(radiusresults)
            a = viscircles(radiusresults{circle_nr}.MP,radiusresults{circle_nr}.radius);
            X = a.Children.XData;
            Y = a.Children.YData;
            delete(a)
            plot(X,Y,'Color',colors{circle_nr},'Linewidth',1,'LineStyle',circlestyles{circle_nr})
            legendentry{circle_nr} = radiusresults{circle_nr}.method;
        end
    end
    
    % plot lines representing weld toe angle
    if ~isempty(angleresults)
        for line_nr = 1:length(angleresults)
            m = tand(-angleresults{line_nr}.angle);
            b = profile(angleresults{line_nr}.DP,2)-m*profile(angleresults{line_nr}.DP,1);

            y_line = [min(profile(:,2))-1 max(profile(:,2))];
            x_line = (y_line-b)./m;
            plot(x_line,y_line,'Color',colors{line_nr},'Linewidth',1,'LineStyle',linestyles{line_nr})
        end
    end
    
    % plot profile 
    plot(profile(:,1),profile(:,2),'-','Color','k','Linewidth',1.0);
    
    % axes properties
    ax.XLabel.String = 'x [mm]';
    ax.YLabel.String = 'y [mm]';
    ax.FontName = 'Arial';
    ax.FontSize = 9;
    ax.Box = 'on';
    ax.Units = 'centimeters';
    ax.XLim = [radiusresults{1}.MP(1)-radiusresults{1}.radius*2 radiusresults{1}.MP(1)+radiusresults{1}.radius*2];
    minY = radiusresults{1}.MP(2)-radiusresults{1}.radius*1.5;
    maxY = minY+ax.Position(4)/ax.Position(3)*diff(ax.XLim);
    ax.YLim = [minY maxY];
    
    % legend
    legend(legendentry)



end