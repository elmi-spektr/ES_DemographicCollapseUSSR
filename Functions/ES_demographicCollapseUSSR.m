function L = ES_demographicCollapseUSSR(varargin)
% This function carries out demographic analysis of Eastern and Western
% Blocs with respect to the collapse of the USSR.
% 
% Data it uses is obtained from the World Bank Open Data (see:
% https://data.worldbank.org/)
% 
% Written by: Artoghrul Alishbayli for Elmi Spektr (2021)
%
% Note: This set of functions use scripts written by Bernhard Englitz
% see: https://bitbucket.org/benglitz/controller-dnp/ 

% Input the path as ES_demographicCollapseUSSR('Path', 'PATHTO_COLLAPSEUSSR')



% DEFAULT PARAMETERS
P = parsePairs(varargin);
checkField(P,'Path',[]); % Path of the CollapseUSSR package
checkField(P,'Region','Eastern'); % Can also be 'Western'
checkField(P,'Exclude', []); %{'Uzbekistan','Tajikistan','Azerbaijan','Turkmenistan','Kyrgyz Republic'}); % Exclude some countries from the analysis
checkField(P,'Plot',0); % Plot the time series
checkField(P,'Normalize','Divisive'); % Can also be 'Subtractive'

if isempty(P.Path)
  error('Please indicate where the package is located.');
else
  % Add the necessary directories to path
  cPath = P.Path;
  addpath(cPath);
  addpath([cPath,filesep,'Data']);
  addpath([cPath,filesep,'Functions']);
  addpath([cPath,filesep,'Functions',filesep,'Dependencies']);
  addpath([cPath,filesep,'Results']);
end
cd(P.Path);

% Load the file from Data folder
Filename = [P.Path, filesep,'Data',filesep,'Demographics_',P.Region,'Bloc.xls'];
T = readtable(Filename);
T = removevars(T,{'CountryCode','IndicatorName','IndicatorCode'});
Variables =  T.Properties.VariableNames;
Variables = Variables(contains(Variables,'x'));

% Extract years 
for iV = 1:length(Variables)
 Year(iV) =str2num(Variables{iV}(2:end));
end

% Extract country names
CountryNames = [T.CountryName];

% Restructure the data
T = removevars(T,'CountryName');
R = table2array(T);

% The year of collapse
cInd = find(Year==1991);

if ~isempty(P.Exclude)
  RemInd = ismember(CountryNames,P.Exclude);
  CountryNames(RemInd) = [];
  R(RemInd,:) = [];
end


  % Loop through the countries and plot the individually
  for iC = 1:length(CountryNames)
    switch P.Normalize
      case 'Divisive'
            Norm2Beginning(iC,:) = R(iC,:) / R(iC,cInd); % divisive normalization relative to year 1991
      case 'Subtractive'
            Norm2Beginning(iC,:) = R(iC,:) - R(iC,cInd); % divisive normalization relative to year 1991
    end
  end
  
  
  % Prepare the output
  L.Norm2Beginning = Norm2Beginning;
  L.Year = Year;
  L.CountryNames = CountryNames;
  L.Region = P.Region;

  if P.Plot
    ES_plotDemographicCollapseUSSR(L,'Region',P.Region);
  end
 
