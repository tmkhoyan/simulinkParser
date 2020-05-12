# simulinkParser
a simple config parser for Simulink. This file was selected as MATLAB Central [Pick of the Week](https://blogs.mathworks.com/pick/2018/05/25/manage-simulink-data-variations-with-simulinkparser/)

## MATLAB CENTRAL 
the file is available as submission 
[![View tmkhoyan/simulinkParser on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://in.mathworks.com/matlabcentral/fileexchange/67142-tmkhoyan-simulinkparser)

## Manual

This parser allows setting block properties (dialogparameters) via text based file. This simulink parser is based on my previous submission tmkhoyan/configParser that can be used for matlab scripts.
--> [tmkhoyan/configParser](https://nl.mathworks.com/matlabcentral/fileexchange/66611-tmkhoyan-configparser)
The parser allows setting nested blocks as well as properties of masked blocks. This can be convenient in the case when you need to run multiple simulations with the same diagram but multiple settings. Settings each block by hand can become quite cumbersome.
Example usage is provided in the example simulink file. Steps are as follows:
Basic usage:
1. provide the settings in the 'config.txt' file
2. drag and drop the block setConfig in your simulink diagram. The settings are parsed when the diagram is initialized.
Preliminary steps:
1. make sure setConfig function is on your matlab path and you have the newest version of readConfig (check submission tmkhoyan/configPars​er). Use addpath(folder/to.setConfig) followed by savepath to have permanent access to the function. Best practice is to link the path to github folder
2. Make sure to know the dialogparamater variable names (not dialog promt names). These can be queried by getConfigParams.
3. Keep the same structure as exampl config.txt . Make sure to provide a list of blocknames to be set in the setting variable {blocknames} and the settings for each block.
4. Use '/' for nested blocks
Usage update 2.1: Constants can now be defined via symbolic operations and used as setting in diagram blocks. The nice thing is that all operations are carried out inside configParser and the simulink blocks only receives the resolved constant. Note that for this functionality you need to use the new version of the provided configParser.

- parsing symbolic variables e.g. c2 = @ c1^2*2 (any expression allowed)
- parsing nested variables e.g. c3 = @ c1*2+10 (Parser evaluates
variables recursively such that nested relationships are allowed irrespective of ordering in the config file

see example diagram *_v21 : --->
```Matlab
//parameters of noise block an now be set with any constants defined in config
{noise}
Cov = @ k1
Ts = @ c1/10+0.0002
//note the recursive relationship in c3 with k1. This parameter is resolved as long as k1 has explicit definition anywhere in th config.
{const}
c1 = 0.01
c2 = @ c1 + 0.045
c3 = @ k1 + 0.012/2

//demonstrates that parameters are passed globally
{const2}
k1 = @ c1*2
k2 = @ c1/2+100
k3 = 11.2
```
How to query the dialogparameter names:
Make sure that you active window is the current simulink block diagram. (simply select any block inside your simulink file). getConfigParams will then generate the structure of nested blocks and blocknames and provide you with the table containing the blocks. You can then access the block properties and find the appropriate dialogparameter variable by indexing the structure dialogParam{index}. getConfigParams can query to desired nested depth (e.g. to query 3 levels deep use getConfigParams(3). If the input depth is higher than maximum depth getConfigParams will retain the maximum depth of the diagram). Example:

In the example file, to query dialogparameters of 'step' block. First do s = getConfigParams. Search in the table for step[index] and its corresponding index. s.dialogParam{index} gives: -->
Time: [1×1 struct] --> corresponds to prompt 'Step time'
Before: [1×1 struct] --> corresponds to prompt 'initial value'
After: [1×1 struct] --> corresponds to prompt 'Final value'
SampleTime: [1×1 struct]
VectorParams1D: [1×1 struct]
ZeroCross: [1×1 struct]
----
Now parameters can be set using dialogparameter names (order is irrelevant):
```Matlab
{step}
Before = 0
After = 1
Time = 0
```

##  References
Please use the following DOI to cite cvyamlParser: 
[![DOI](https://zenodo.org/badge/184505001.svg)](https://zenodo.org/badge/latestdoi/184505001)

## Licence 
Please refer to the licence file for information about code distribution, usage and copy rights. The code is provided under MIT License. 
