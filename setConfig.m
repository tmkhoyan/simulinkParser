function setConfig(varargin)

setOptargs;

cpaths = regexp(basepath,'/','split');

basepath = cpaths{1};

opt = readConfig(filename); %#ok<SHVAI>

 %get_param(gcb,'DialogParameters')

%
if isfield(opt,'blocknames')
if ischar(opt.blocknames)
    % first element in opt.('blockname') is propertyname second is value
    % opt.blocknames){k}{1} and opt.blocknames{k}{2}
     set_param([basepath opt.blocknames],opt.(opt.blocknames){1}{1},opt.(opt.blocknames{1}){1}{2});
else
    blockpaths = strcat('/',regexprep(opt.blocknames,'_','/'));
    for k=1:numel(opt.blocknames)
        for m = 1:numel(opt.(opt.blocknames{k}))
            try
                if strcmpi(opt.(opt.blocknames{k}){m}{2},'false')
                    opt.(opt.blocknames{k}){m}{2} = 0;
                elseif strcmpi(opt.(opt.blocknames{k}){m}{2},'true')
                    opt.(opt.blocknames{k}){m}{2} = 1;
                end
                
                set_param([basepath blockpaths{k}],opt.(opt.blocknames{k}){m}{1},opt.(opt.blocknames{k}){m}{2});
            catch
                %warnstr = sprintf('Parameter not set. Block ''%s'' does not have a parameter named ''%s''', blockpaths{k}, opt.(opt.blocknames{k}){m}{1});
                warning('Parameter value ''%s'' not set. Block ''%s'' does not have a parameter named ''%s''', opt.(opt.blocknames{k}){m}{2},  blockpaths{k}, opt.(opt.blocknames{k}){m}{1});
            end
        end
    end
end

else 
    error('Simulink blocknames notdefined in config. Please provide the correct config file')
end



   function setOptargs
        numvarargs  = length(varargin);
        
        % set defaults for optional inputs
        if numvarargs > 1
            error('functions:randRange:TooManyInputs', ...
                'requires atmost 2 optional input');
        end
        cpaths = regexp(gcb(),'/','split'); cpaths = cpaths{1};
        
        optargs = {'config/config.txt', cpaths};
        %optargs{1:numvarargs} = varargin;
        [optargs{1:numvarargs}] = varargin{:};
        [filename, basepath] = optargs{:};
        if isempty(filename)
            filename = 'config/config.txt';
        end
   end

return; 
end 

