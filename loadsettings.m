function settings = loadsettings()

    % plot settings
        settings.plotresult = 'on';
    
    % data processing
        % Settings for removing outliers in profile data
        settings.outliermethod = 'none';        % 'remove' or 'none'
        
        % Settings for filtering of profile data
        settings.filter = 'none';               % 'Smoothing Spline', 'Moving Average and Median', 'none'
        settings.smoothparam = 0.995;           % for filtermethod = 'Smoothing Spline';
        
        % Method for ordering point data
        settings.ordermethod = 'none';          % 'ordered' or 'none'
        settings.orderdistance = 0.05;          % new x distance between points (value in mm)
        settings.interpmethod = 'linear';       % see method of interp1 command
    
    % data evaluation
        % curvature method
        settings.CM.smoothparam = 1;

        % least squares method
        settings.LSM.smoothparam = 1;
        settings.LSM.factor = 0.3;

        % iteration method
        settings.IM.smoothparam = 1;
        settings.IM.crit1 = 0.01;   % end point, factor of weld toe radius
        settings.IM.crit2 = 0.02;   % max distance between profile and circle
        settings.IM.crit3 = 3;      % data points between starting and end point

        % angle methods
        settings.Angle.smoothparam = 1;
        settings.Angle.smoothlen   = 0.2;
end