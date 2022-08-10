function graphfighandle = graphRebinnedData(boxData, totalBins)
%GRAPHREBINNEDDATA Summary of this function goes here
%   Makes a plot of the average beambreak/dispense values in each bin
%   period, (ex. hour 0 of ALL days, hour 2 of ALL days... hour 23 of ALL
%   days) and includes error bars
fields = fieldnames(boxData.Bin1);
time = 1:totalBins;
  for i = 1:size(fields,1) - 3  %to do : name these figs according to BBID, datatype, etc. Graph everything on one graph w/different colors and legend by default
    hold on 
    data = [];
    errArray = [];
    for j = 1:size(time, 2)
        query = sprintf('Bin%i',j);
        dataPoint = boxData.averages(i);
        err = std(boxData(j).(query).(fields{i})); %I IN AVERAGES SAME ORDER AS IN FIELDS???????
        data = [data; dataPoint];
        errArray = [errArray; err];
    end
    plot(time, smooth(data), 'r-');
    errorbar(time, data, errArray, 'b.');
    hold off
  end
%SAVE GRAPHS WITHIN FUNCTION W/ PHO CODE
end

