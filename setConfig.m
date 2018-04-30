function setConfig(varargin)

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
    % first element in opt.('blockname') is propertyname second is value
    % opt.blocknames){k}{1} and opt.blocknames{k}{2}
     set_param([basepath opt.blocknames],opt.(opt.blocknames){1}{1},opt.(opt.blocknames{1}){1}{2});
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
    error('Simulink blocknames notdefined in config. Please provide the correct config file')
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

return; 
end 

