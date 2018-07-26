function setConfig(varargin)
% Config parser for ASCII based files for simulink 

%   Author: Tigran Mkhoyan
%   Delft University of Technology, 2018

delimiter = [];
filename = [];
setOptargs;

cpaths = regexp(basepath,'/','split');

basepath = cpaths{1};

opt = readConfig(filename,'structnamefieldfillelemn', '__'); 

 %get_param(gcb,'DialogParameters')

%
if isfield(opt,'blocknames')
if ischar(opt.blocknames)
    %TODO: fix issue with only one field is fixed test to see if works!
    % first element in opt.('blockname') is propertyname second is value
    % opt.blocknames){k}{1} and opt.blocknames{k}{2}
     %set_param([basepath opt.blocknames],opt.(opt.blocknames){1}{1},opt.(opt.blocknames{1}){1}{2}); % previous code removed indexing check if works
     set_param([basepath,'/', opt.blocknames],opt.(opt.blocknames){1}{1},opt.(opt.blocknames){1}{2});
else
    blockfieldnames = regexprep(opt.blocknames,'/',delimiter); %check if bloknames contain / recplace by '--' to access the struct fieldnames stored by readConfig
    blockpaths = strcat('/',regexprep(opt.blocknames,delimiter,'/')); % default delimiter is '__'
    for k=1:numel(opt.blocknames)
        for m = 1:numel(opt.(blockfieldnames{k}))
            try
                if strcmpi(opt.(blockfieldnames{k}){m}{2},'false')
                    opt.(blockfieldnames{k}){m}{2} = 0;
                elseif strcmpi(opt.(blockfieldnames{k}){m}{2},'true')
                    opt.(blockfieldnames{k}){m}{2} = 1;
                end
                set_param([basepath blockpaths{k}],opt.(blockfieldnames{k}){m}{1},opt.(blockfieldnames{k}){m}{2});
            catch
                %warnstr = sprintf('Parameter not set. Block ''%s'' does not have a parameter named ''%s''', blockpaths{k}, opt.(blockfieldnames{k}){m}{1});
                warning('Parameter value ''%s'' not set. Block ''%s'' does not have a parameter named ''%s''', opt.(blockfieldnames{k}){m}{2},  blockpaths{k}, opt.(blockfieldnames{k}){m}{1});
            end
        end
    end
end

else 
    error('Simulink blocknames not defined in config. Please provide the correct config file')
end


   function setOptargs
        numvarargs  = length(varargin);
        
        % set defaults for optional inputs
        if numvarargs > 1
            error('functions:randRange:TooManyInputs', ...
                'requires atmost 3 optional input');
        end
        cpaths = regexp(gcb(),'/','split'); cpaths = cpaths{1};
        
        optargs = {'config/config.txt', cpaths,'__'};
        %optargs{1:numvarargs} = varargin;
        [optargs{1:numvarargs}] = varargin{:};
        [filename, basepath,delimiter] = optargs{:};
        if isempty(filename)
            filename = 'config/config.txt';
        end
   end

disp('Done.')
return; 
end 



% a simple config parser for Simulink
% This parser allows setting block properties (dialogparameters) via text based file. This simulink parser is based on my previous submission tmkhoyan/configPars​er that can be used for matlab scripts.
% --> https://nl.mathworks.com/matlabcentral/fileexchange/66611-tmkhoyan-configparser
% The parser allows setting nested blocks as well as properties of masked blocks. This can be convenient in the case when several you need to run multiple simulations with the same diagram but multiple settings, settings each block by hand can become quite cumbersome.
% Example usage is provided in the example simulink file. Steps are as follows:
% Basic usage:
% 1. provide the settings in the 'config.txt' file
% 2. drag and drop the block setConfig in your simulink diagram. The settings are parsed when the diagram is initialized.
% 
% Preliminary steps:
% 1. make sure setConfig function is on your matlab path and you have the newest version of readConfig (check submission tmkhoyan/configPars​er). Use addpath(folder/to.setConfig) followed by savepath to have permanent access to the function. Best practice is to link the path to github folder
% 2. Make sure to know the dialogparamater variable names (not dialog promt names). These can be queried by getConfigParams.
% 3. Keep the same structure as exampl config.txt . Make sure to provide a list of blocknames to be set in the setting variable {blocknames} and the settings for each block.
% 4. Use '/' for nested blocks
% 
% How to query the dialogparameter names:
% Make sure that you active window is the current simulink block diagram. (simply select any block inside your simulink file). getConfigParams will then generate the structure of nested blocks and blocknames and provide you with the table containing the blocks. You can then access the block properties and find the appropriate dialogparameter variable by indexing the structure dialogParam{index}. getConfigParams can query to desired nested depth (e.g. to query 3 levels deep use getConfigParams(3). If the input depth is higher than maximum depth getConfigParams will retain the maximum depth of the diagram). Example:
% 
% In the example file, to query dialogparameters of 'step' block. First do s = getConfigParams. Search in the table for step[index] and its corresponding index. s.dialogParam{index} gives: -->
% Time: [1×1 struct] --> corresponds to prompt 'Step time'
% Before: [1×1 struct] --> corresponds to prompt 'initial value'
% After: [1×1 struct] --> corresponds to prompt 'Final value'
% SampleTime: [1×1 struct]
% VectorParams1D: [1×1 struct]
% ZeroCross: [1×1 struct]
% ----
% Now parameters can be set using dialogparameter names (order is irrelevant):
% {step}
% Before = 0
% After = 1
% Time = 0


