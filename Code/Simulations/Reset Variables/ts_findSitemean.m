function [lasMean] = ts_findSitemean(bookV,vL,CurrentBlockStart,CurrentBlockEnd)
% CurrentBlockStart is a local variable here
% So that we can calculate previous block mean
% floor 10 signifies for divisor greater than 10
% we can take into account anything above 10 since we observe
% theoretically and empirically the change takes into 
% effect after 4-6 trials
if vL.divisor < 11
lasMean = mean(bookV.measured(CurrentBlockStart+ ...
    floor(vL.divisor*0.75):CurrentBlockEnd));
else 
    % changed from 10 to 7
lasMean = mean(bookV.measured(CurrentBlockStart+ ...
    floor(6):CurrentBlockEnd));
end