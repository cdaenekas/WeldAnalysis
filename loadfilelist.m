function list = loadfilelist(method)
    if strcmp(method,'all')
        mainpath = 'path\to\scandata';
        list = dir(fullfile(mainpath,'**','*.xyz'));
    elseif strcmp(method,'allnew')
        mainpath = 'path\to';
        
        listing_results = dir(fullfile(mainpath,'results','**/*.mat'));
        listing_data = dir(fullfile(mainpath,'scandata','**/*.xyz'));
        
        datafiles = {listing_data.name};
        resultfiles = {listing_results.name};
        
        datafiles = cellfun(@(x) strrep(x,'.xyz',''),datafiles,'UniformOutput',false);
        resultfiles = cellfun(@(x) strrep(x,'.mat',''),resultfiles,'UniformOutput',false);
        
        rows = ismember(datafiles,resultfiles)==0;
        
        list = listing_data(rows,:);
    elseif strcmp(method,'test')
        mainpath = 'path\to\testdata';
        list = dir(fullfile(mainpath,'**','*.xyz'));
    end
end