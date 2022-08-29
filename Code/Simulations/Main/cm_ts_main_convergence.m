%{
Author: Sumedh Sopan Nagrale
Created: 29/09/2021
(c) TNEL, umn
%}
function [dat1] = cm_ts_main_convergence()
addpath 'C:\Users\Tnel Neuropixels\Desktop\Sep 2020\COMPASS-master\COMPASS_StateSpaceToolbox'
tic
data1 =[];
% all algorithm
% ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]%
% performing simulations for "noalgorithm","greedy","egreedy","UCB",
vL = struct;
for dst = ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]%
    
    for test = 1
        %["UCBbay","bernoulli","Poisson","Normal","bothNormal"]
        % test is for the selection of Bk values, which one to select for test
        for NTrials = [100,200,300,400,500,600,700,800,900,1000]
            %disp(test);
            cnt2 =1;
            cnt =1;
            % divisor for change the arm selection
            for divisor = 15
                % model is the number of arms in bk
                for model = [2,4,6,8]
                    clearvars -except NTrials snr dat1 dst model data1 seqcon conv3 cnt2 correctAns SDMall RDU divisor cnt prb test seq prb2
                    vL.techni = 1;
                    % adding this for the different convergence testing
                    vL.NTrials = NTrials;
                    vL.divisor = divisor;
                    vL.snr = 1;
                    vL.model = model;
                    % location of correct arm
                    correct = 3;
                    vL.test = test;
                    if dst == "UCB" || dst =="greedy"
                        vL.greedyNum = 1;
                    else
                        vL.greedyNum = 2;
                    end
                    vL.distributionTypes =dst;
                    disp(strcat(dst,'-',num2str(NTrials),'-',num2str(model),'-Started'));
                    % initialization
                    [vL] = cm_ts_setupdata_blocksize(vL);
                    [expV] = ts_function(vL);
                    [data1] = ts_datafetcher(expV,vL,correct,model,data1);
                    cnt = cnt+1;
                end
                cnt = 1;
                cnt2 = cnt2 +1;
                dat1.(strcat("dist_",dst,num2str(NTrials))).data = data1;
                
                %                 dat1 = [];
                %                 data1 = [];
            end
            
            
        end
        
    end
    save(strcat('D:\Sumedh\Projects\Methods for psychiatric DBS programming\DataA\Convergence\Convergence with gen uniformity\Convergence 15 BS\','\Con_',dst,'153BS.mat'),'dat1','-v7.3');
    dat1 = [];
    data1 = [];
end
k = toc;
end