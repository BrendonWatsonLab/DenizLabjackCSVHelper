function [finalData] = rebin(labjackData, datesArray, totalBins)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%GOAL: PRODUCE A TABLE WITH 24 ROWS FOR EACH BBID, EACH ROW CONTAINING AVERAGE HOURLY
%CONSUMPTION ACROSS ALL DAYS IN LAST COL
for j = 1:size(labjackData,2)
        BBIDdata = labjackData(j).binnedData;
    for i = 1:totalBins
        averages = [];
        %makes array of all dates with this hour
        datesNew = datesArray + hours(i - 1);
        %initializes hourlyVal as empty timetable
        hourlyVal = timetable(datesNew');
        fields = fieldnames(BBIDdata);
        for k = 2:size(fields,1) - 3 %just to get named fields
            label = char(fields(k));
            hourlyVal.(label) = zeros(size(datesNew,2),1);
        end
        %grabs ALL dates with data for this specific hour, replaces matching
        %rows with this data, leaving a complete timetable with 0s in missing time slots
        hourlyVal(ismember(hourlyVal.Time, BBIDdata(ismember(BBIDdata.time, datesNew', 'rows'),:).time),:) = table2timetable(BBIDdata(ismember(BBIDdata.time, datesNew', 'rows'),:));
        %^^ probably the most confusing line of code I have ever written in my
        %life, need to review this in debugger to make sure I got it right
        %last row of each column is averages by hour
        for k = 2:size(fields,1) - 3 %just to get named fields
            label = char(fields(k));
            average = mean(hourlyVal.(label));
            averages = [averages; average]; %To do: save averages under proper field names
        end
        fieldname = sprintf("Bin%d", i);
        hourlyData.(fieldname) = hourlyVal;
        hourlyData.averages = averages;
    end
    %fieldname = sprintf("BB%d", j);
    finalData(j) = hourlyData;
    %now make averages across BBIDs
end
end

