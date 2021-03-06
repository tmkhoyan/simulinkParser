function [s] = getConfigParams(varargin)
% part of Config parser for ASCII based files for simulink

%   Author: Tigran Mkhoyan
%   Delft University of Technology, 2018

basepath = [];
level = [];
saveopt = [];
verbose = [];

setOptargs;

%fix not needed to get the root path
%cpaths = regexp(basepath,'/','split');
%basepath = cpaths{1};

objNamesFull = find_system(basepath, 'LookUnderMasks', 'all');

objNamesFull = objNamesFull(2:end);
objNames = regexprep(objNamesFull,[basepath,'/'],'');
objNames = regexp(objNames,'/','split');

fsize = @(x) cellfun(@sum,cellfun(@size,x,'UniformOutput',0));

levels = fsize(objNames)-1;

maxlevel = max(level,1);  % higher than 1
maxlevel = min(maxlevel,max(levels)); % not larger than maxlevel


dialogParam = cell(numel(objNames),maxlevel);
tbl = dialogParam;
idx = cell(maxlevel,1);

for k=1:maxlevel
    idx{k} = levels>k;  %get logical indexing arrays
end

for m=1:maxlevel
    idx = find(levels==m);
    objbylevel = objNamesFull(levels==m);
    
    for k=1:numel(objbylevel)
        
        dialogParam{idx(k),m} = get_param(objbylevel{k},'Dialogparameters');
        tbl{idx(k),m} =[objNames{idx(k)}{m},'[',num2str(idx(k)),']'];
        %dialogParam entry kept empty
        
    end
end

if(~isempty(tbl))
    dialogParamTbl = cell2table(tbl,'VariableNames',strcat('Level  ',cellstr(num2str((1:maxlevel)'))));
else
    dialogParamTbl = [];
end

if saveopt
    writetable(dialogParamTbl,[basepath,'_levels.txt'],'Delimiter',' ')
end

if(verbose)
    disp(dialogParamTbl)
end

s.dialogParamTbl = dialogParamTbl;
s.dialogParam = dialogParam;
s.objNamesFull = objNamesFull;



    function setOptargs
        numvarargs  = length(varargin);
        
        % set defaults for optional inputs
        if numvarargs > 4
            error('functions:TooManyInputs', ...
                'requires atmost 4 optional input');
        end
        cpaths = regexp(gcb(),'/','split'); cpaths = cpaths{1};
        
        optargs = {1,cpaths,0,0};
        %optargs{1:numvarargs} = varargin;
        [optargs{1:numvarargs}] = varargin{:};
        [level,basepath,saveopt,verbose] = optargs{:};
        
    end

return;
end