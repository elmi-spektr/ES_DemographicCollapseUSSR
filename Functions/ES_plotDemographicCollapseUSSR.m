function  ES_plotDemographicCollapseUSSR(R,varargin)

P = parsePairs(varargin);
checkField(P,'Region','Eastern'); % Can also be 'Western', 'Both'

% Define colors for each region
Color = [1,0,0; 0,0,1]; % Red - Eastern, Blue - Western

for iA = 1:length(R) % loop through each bloc, in case there is more than one
  figure(121231);
  for iC = 1:length(R(iA).CountryNames)
    switch P.Region
      case {'Eastern','Western'} % when plotting individually
        pl(iC,iA) = plot(R(iA).Year,R(iA).Norm2Beginning(iC,:)); hold on
      case 'Both' % when plotting together
        switch R(iA).Region
          case 'Eastern'
            cColor = Color(1,:);
          case 'Western'
            cColor = Color(2,:);
        end
        pl(iC,iA) = plot(R(iA).Year,R(iA).Norm2Beginning(iC,:),'Color',cColor); hold on        
    end
    pl(iC,iA).DataTipTemplate.DataTipRows(1).Label = 'Year';
    pl(iC,iA).DataTipTemplate.DataTipRows(2).Label = 'Population';
    row = dataTipTextRow('Country',repmat(R(iA).CountryNames(iC),length(R(iA).Norm2Beginning(iC,:)),1));
    pl(iC,iA).DataTipTemplate.DataTipRows(end+1) = row;
    maxVal(iC,iA) = max(R(iA).Norm2Beginning(iC,:));
    minVal(iC,iA) = min(R(iA).Norm2Beginning(iC,:));
    text(R(iA).Year(end) +1, R(iA).Norm2Beginning(iC,end),R(iA).CountryNames{iC});
  end
  

  % Estimate the average and plot
  Average = mean(R(iA).Norm2Beginning,1);
  plot(R(iA).Year,Average,'Color',cColor,'LineWidth',3);
  
end
  % Add labels and other informative elements to the figure
  xlabel('Years');
  ylabel('Population (normalized to the level at 1991)');
  cInd = R(1).Year==1991;
  yMax = max(maxVal(:));
  yMin = min(minVal(:));
  line([R(1).Year(cInd),R(1).Year(cInd)],[yMin,yMax],'Color','k','LineWidth',2)
  text(R(1).Year(cInd)+1,yMax,'Fall of the Soviet Union');
  line(R(1).Year,ones(length(R(1).Year),1),'Color','k','LineWidth',2);

  switch P.Region
    case {'Eastern','Western'} % when plotting individually
      title([P.Region,' Europe - Before and After the Fall of the USSR']);
    case 'Both'
      title('Europe - Before and After the Fall of the USSR');
  end

  