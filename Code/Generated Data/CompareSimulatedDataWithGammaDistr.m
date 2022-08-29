clearvars -except iter inhere
%{
Compare simulated data and actual data
methods:
1) Simulated from actual data model
-- This has minimum noise and the simulated data
is close to the actual data
2) Simulated data from actual model but with noise
-- This should be different from the actual data
3) Using different Vk values
4) Different Wk values but limited by the range as
described in Grid search method

# Things to be displayed here
1. Mean simulated data and simulated data
2. Actual data
3. Mean simulated distinct data and simulated data
4. Mean Vk simulated data and simulated data

Portion 1 includes
a) data simulations using above methods
b) then plots using boundedline
%}

% Subjects
% clear;%"MG104";"MG102";"MG105";"MG95";"MG96";"MG99"
%
bins=10;
subNumber = ["MG105"];%;"MG96";"MG99";"MG102";"MG104";"MG105";];
subNumber2 = ["S1"];%"S2";"S3";"S4";"S5";"S6"];
includeNone = 1;
load('ybyc.mat');
figure(2);
hold on
for kr = 1:length(subNumber)
    compiledData = [subject,blockStim];
    indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(kr))}));
    k =histfit(responseTimes(indfin,1),bins,'gamma');
    xlim([0 2]);
    allactual_a(kr,:) = k(2).XData;
    allactual_b(kr,:) = (k(2).YData);
end
% Data simulations options
sim = 2;
number_of_data = 1000; % simulation included
% subsection 1: Creating similar data
% Simulation data
clearvars b_same a_same a_diff b_diff
figure(5);hold on
load('ybyc.mat');
data_fold = ["temp"];
for fld = ["\Different\"]
    for subN = 1: length(subNumber)
        clearvars htest htestp
        compiledData = [subject,blockStim];
        indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(subN))}));
        for j = 1:length(data_fold)
            for i = 1:number_of_data
                disp(strcat(num2str(i),subNumber(subN),"SDUall.mat"))
                load(strcat("D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Simulated\",subNumber(subN),"\",fld,num2str(i),subNumber(subN),"SDUall.mat"));
                a = fitdist(SDUall.yRT_SDU','gamma');
                cdfForActualData = gampdf(min(SDUall.yRT_SDU):0.1:max(SDUall.yRT_SDU),a.ParameterValues(1),a.ParameterValues(2));
                b = fitdist(gamrnd(a.ParameterValues(1),a.ParameterValues(2),length(SDUall.yRT_SDU),1),'gamma');
                cdfForfakeData= gampdf(min(SDUall.yRT_SDU):0.1:max(SDUall.yRT_SDU),b.ParameterValues(1),b.ParameterValues(2));
                [htest_fsim(i),htestp_fsim(i),sta_fsim(i)] = ...
                    kstest2(cdfForActualData,cdfForfakeData);
            end
            dat.(subNumber(subN)).(data_fold(j)).ktesth_sim = htest_fsim;
            dat.(subNumber(subN)).(data_fold(j)).ktestp_sim = htestp_fsim;
            dat.(subNumber(subN)).(data_fold(j)).actualparam = fitdist(responseTimes(indfin,1),'gamma');
        end
        if fld== "\same\"
            dats = dat;
        else
            datf = dat;
        end
    end
end
