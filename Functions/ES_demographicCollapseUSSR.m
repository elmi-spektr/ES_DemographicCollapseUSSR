function ES_demographicCollapseUSSR(varargin)
% This function carries out demographic analysis of Eastern and Western
% Blocs after the collapse of the USSR.
% 
% Data it uses is obtained from the World Bank Open Data (see:
% https://data.worldbank.org/)
% 
% Written by: Artoghrul Alishbayli for Elmi Spektr (2021)
%
% Note: This set of functions use scripts written by Bernhard Englitz
% see: https://bitbucket.org/benglitz/controller-dnp/ 

P = parsePairs(varargin);
checkField(P,'Path',[]); % Path of the CollapseUSSR package
checkField(P,'Region','Eastern'); % Can also be 'Western'
checkField(P,'Exclude', {'Uzbekistan','Tajikistan','Azerbaijan','Turkmenistan','Kyrgyz Republic'}); % Exclude some countries from the analysis
checkField(P,'Plot',1); % Plot the time series
checkField(P,'Normalize','Divisive'); % Can also be 'Subtractive'


if isempty(P.Path)
  error('Please indicate where the package is located.');
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

if P.Plot
  figure(121231); clf;
  % Loop through the countries and plot the individually
  for iC = 1:length(CountryNames)
    switch P.Normalize
      case 'Divisive'
            Norm2Beginning(iC,:) = R(iC,:) / R(iC,cInd); % divisive normalization relative to year 1991
      case 'Subtractive'
            Norm2Beginning(iC,:) = R(iC,:) - R(iC,cInd); % divisive normalization relative to year 1991
    end
    
    pl(iC) = plot(Year,Norm2Beginning(iC,:)); hold on
    pl(iC).DataTipTemplate.DataTipRows(1).Label = 'Year';
    pl(iC).DataTipTemplate.DataTipRows(2).Label = 'Population';
    row = dataTipTextRow('Country',repmat(CountryNames(iC),length(Norm2Beginning(iC,:)),1));
    pl(iC).DataTipTemplate.DataTipRows(end+1) = row;
    maxVal(iC) = max(Norm2Beginning(iC,:));
    minVal(iC) = min(Norm2Beginning(iC,:));
    text(Year(end) +1, Norm2Beginning(iC,end),CountryNames{iC});
  end
  
  % Add labels and other informative elements to the figure
  xlabel('Years');
  ylabel('Population (normalized to the level at 1991)');
  cInd = Year==1991;
  yMax = max(maxVal);
  yMin = min(minVal);
  line([Year(cInd),Year(cInd)],[yMin,yMax],'Color','r')
  text(Year(cInd)+1,yMax,'Fall of the Soviet Union');
  line(Year,ones(length(Year),1),'Color','r','LineWidth',2);
  title([P.Region,' Europe - Before and After the Fall of the USSR']);
  
  % Estimate the average and plot
  Average = mean(Norm2Beginning,1);
  plot(Year,Average,'k','LineWidth',2);
  
end