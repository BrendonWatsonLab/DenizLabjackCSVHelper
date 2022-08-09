function statData = postProcess(current_bbIDs, savePath, dataPath, CurrentExpt, CurrentCohort, binningtime, startDate, endDate)
%Collects data from Simeone's R scripts, graphs, and runs selected analyses on them
if ~exist('current_bbIDs','var')
	current_bbIDs = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16'};
    %{'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16'}
end
if ~exist('savepath','var')
    savePath = 'C:\Users\kirca\Desktop\MatLab';
end
if ~exist('dataPath','var')
    dataPath = 'Z:\Arduino-Exp4';
end
if ~exist('CurrentExpt', 'var')
	CurrentExpt = '04';
end
if ~exist('CurrentCohort', 'var')
	CurrentCohort = '01';
end
if ~exist('binningtime','var')
    binningtime = 'hourly';
    binAbbrev = 'HR';
end
if ~exist('startDate','var')
    startDate = datetime('12-May-2022');
end
if ~exist('endDate','var')
    endDate = datetime('06-July-2022');
end
%%Preferences -- USE STR2NUM!!!!! MAKE SURE THEY ARE INTS (INT16)
debug = false;
buildDataFile = false;
analysis = true;
missedDays = 0;
savePath = fullfile(savePath, append('Experiment_',CurrentExpt,'_Cohort_',CurrentCohort,'_Binned_',binningtime));
datesArray = startDate:endDate;
if buildDataFile
    for i = 1:size(current_bbIDs, 2)
        fprintf('Reading files for BB%d.\n', i)
        tempData = [];
        dirName = char(fullfile(dataPath, append('BB',current_bbIDs(i))));
        statData(i).BBID = current_bbIDs(i);
        csvBBID = char(current_bbIDs(i));
        if (str2num(csvBBID) >= 10)
            csvBBID = append('0', csvBBID);
        end
        for j = 1:size(datesArray,2)
            currMonth = int2str(month(datesArray(j)));
            currYear = int2str(year(datesArray(j)));
            currDay = day(datesArray(j));
            if (currDay < 10)
                currDay = append('0', int2str(currDay));
            else
                currDay = int2str(currDay);
            end
            currCSV = fullfile(dirName,char(append('BB', csvBBID, '_digital_FINAL_binned_', binAbbrev, '_', currYear, '_', currMonth,'_', currDay,'.csv')));
            try
                tempData = [tempData; readtable(currCSV)];
                if debug
                    fprintf('Successfully opened file %s.\n', currCSV)
                end
            catch
                missedDays = missedDays + 1;
                fprintf('Could not open file %s. Continuing... \n', currCSV)
            end
        end
        statData(i).binnedData = tempData;
    end
    save(savePath,'statData');
    fprintf('Data compilation complete! File saved to %s.\n', savePath)
    fprintf('Missed Days: %d.', missedDays)
end
%make row with averages??
if analysis
    if ~exist('statData','var')
        load(savePath);
        fprintf('Successfully loaded file %s.\n', savePath)
        for i = 1:size(statData,2)
            hourlyGraphHandle = HourlyGraph(statData, startDate, datesArray, i, debug);
        end
    end
    %ranksum, etc.
end
end
%ask about how to quantify analysis
%tiny format thing-- possible to not have 0 after every BB?  ex. BB15 not
%BB015