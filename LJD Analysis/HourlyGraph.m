function [graphhandle, hourlyData] = HourlyGraph(labjackData, startDate, datesArray, BBID, debug)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%GOAL: PRODUCE A TABLE WITH 24 ROWS FOR EACH BBID, EACH ROW CONTAINING AVERAGE HOURLY
%CONSUMPTION ACROSS ALL DAYS IN LAST COL
BBIDdata = labjackData(BBID).binnedData;
for i = 1:24
    if ~(i == 1)
        startDate = startDate + hours(1);
    end
    hourlyData(i).RegFoodDispense = [];
    hourlyData(i).FatFoodDispense = [];
    hourlyData(i).RegWaterDispense = [];
    hourlyData(i).SucWaterDispense = [];
    hourlyData(i).RegWaterBB = [];
    hourlyData(i).SucWaterBB = [];
    hourlyData(i).RegFoodBB = [];
    hourlyData(i).FatFoodBB = [];
    hourlyData(i).flags = [];
    for j = 1:size(datesArray,2)
        currDate = startDate + days(j-1);
        if debug 
            fprintf("Combining data for %s\n", currDate)
        end
        hourlyVal = BBIDdata(ismember(BBIDdata.time, currDate, 'rows'),:);
        if isempty(hourlyVal)
            RegFoodDispense = 0;
            FatFoodDispense = 0;
            RegWaterDispense = 0;
            SucWaterDispense = 0;
            RegFoodBeambreak = 0;
            FatFoodBeambreak = 0;
            RegWaterBeambreak = 0;
            SucWaterBeambreak = 0;
            flag = 0; %%TO DO: MAKE SYSTEM THAT CONSIDERS FLAGS FOR BAD IDXS WITH NO DATA (ex. when mouse is out of cage)
        else
            RegFoodDispense = str2double(cell2mat(hourlyVal.Regular_Food_Dispense));
            FatFoodDispense = str2double(cell2mat(hourlyVal.Fatty_Food_Dispense));
            RegWaterDispense = str2double(cell2mat(hourlyVal.Regular_Water_Dispense));
            SucWaterDispense = str2double(cell2mat(hourlyVal.Sucrose_Water_Dispense));
            RegFoodBeambreak = str2double(cell2mat(hourlyVal.Regular_Food_Beambreak));
            FatFoodBeambreak = str2double(cell2mat(hourlyVal.Fatty_Food_Beambreak));
            RegWaterBeambreak = str2double(cell2mat(hourlyVal.Regular_Water_Beambreak));
            SucWaterBeambreak = str2double(cell2mat(hourlyVal.Sucrose_Water_Beambreak));
            flag = str2double(cell2mat(hourlyVal.entry_flag));
        end
        hourlyData(i).RegFoodDispense = [hourlyData(i).RegFoodDispense; RegFoodDispense];
        hourlyData(i).FatFoodDispense = [hourlyData(i).FatFoodDispense; FatFoodDispense];
        hourlyData(i).RegWaterDispense = [hourlyData(i).RegWaterDispense; RegWaterDispense];
        hourlyData(i).SucWaterDispense = [hourlyData(i).SucWaterDispense; SucWaterDispense];
        hourlyData(i).RegWaterBB = [hourlyData(i).RegWaterBB; RegWaterBeambreak];
        hourlyData(i).SucWaterBB = [hourlyData(i).SucWaterBB; SucWaterBeambreak];
        hourlyData(i).RegFoodBB = [hourlyData(i).RegFoodBB; RegFoodBeambreak];
        hourlyData(i).FatFoodBB = [hourlyData(i).FatFoodBB; FatFoodBeambreak];
        hourlyData(i).flags = [hourlyData(i).flags; flag];
    end
    hourlyData(i).RegFoodDispense(end + 1) = mean(hourlyData(i).RegFoodDispense);
    hourlyData(i).FatFoodDispense(end + 1) = mean(hourlyData(i).FatFoodDispense);
    hourlyData(i).RegWaterDispense(end + 1) = mean(hourlyData(i).RegWaterDispense);
    hourlyData(i).SucWaterDispense(end + 1) = mean(hourlyData(i).SucWaterDispense);
    hourlyData(i).RegWaterBB(end + 1) = mean(hourlyData(i).RegWaterBB);
    hourlyData(i).SucWaterBB(end + 1) = mean(hourlyData(i).SucWaterBB);
    hourlyData(i).RegFoodBB(end + 1) = mean(hourlyData(i).RegFoodBB);
    hourlyData(i).FatFoodBB(end + 1) = mean(hourlyData(i).FatFoodBB);
end
fields = fieldnames(hourlyData);
for i=1:(size(fields,1) - 1)
    hold on
    data = [];
    errArray = [];
    for j = 1:size(hourlyData,2)
        dataPoint = hourlyData(i).(fields{i})(end);
        err = std(hourlyData(i).(fields{j})(1:end-1));
        data = [data; dataPoint];
        errArray = [errArray; err];
    end
    plot(time, smooth(data), 'r-');
    errorbar(time, data, errArray, 'b.');
end
end

