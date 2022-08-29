%{
Author: Sumedh Sopan Nagrale
Created: 29/09/2021
(c) TNEL, umn
Description:
variables:
dst: different distribution which are included in the code
    greedy : selecting the minmum
    egreedy: greedy algorithm with an epsilon prob. of switching the site.
    UCB: upper confidence bond which is minimizing the cost function.
    UCB bayesian: A variant of UCB which assumes the input to have a
    gaussian distribution
    Thompson sampling:
    The reward is assumed to follow
    Bernoulli: The likelihood function is discrete distribution
        Prior: beta distribution
        Posterior: update beta parameters based on the observation
    Poisson:
        Prior: gamma distribution
        Posterior: update parameters
    Normal with known mean:
    The likelihood function is continuous distribution
        hyper parameter: alpha and beta shape and scale.
        Prior: inverse gamma distribution
        Posterior: update parameter
    Normal with known precision(tau)
        Causal TS (C-TS): https://arxiv.org/pdf/1910.04938.pdf page 4
        hyper parameter: mean, precision^-1
    FVTS:
        The distribution is normal. The mean for this normal distribution
        is generated from a normal distribution.
    MTS or unknown MSD:
        The distribution is assumed to be generated from the normal
        distribution, with mean u which is generated from a normal distribution
        and precision t, This precision is generated from a gamma distribution
test:
divisor: Blocksize
model: Number of stimulation sites for the experiments

%}
function [dat1] = cm_ts_main()%subj1,subj)
addpath 'C:\Users\Tnel Neuropixels\Desktop\Sep 2020\COMPASS-master\COMPASS_StateSpaceToolbox'
tic
% disp(subj);
% load(strcat(subj1,"RDU.mat"))
% load(strcat(subj,"SDUall.mat"));
% load(strcat(subj,"SDMall.mat"));
% SDMall.Param_SDMall.S = 0.35;
data1 =[];
% all algorithm
% ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]%
% performing simulations for
vL = struct;
for NTrials = 600%[100,250,500,600,700,800,900,1000]
    
    for dst = ["noalgorithm","UCB"]%,"UCB"]%"greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]
        %["UCBbay","bernoulli","Poisson","Normal","bothNormal"]
        % test is for the selection of Bk values, which one to select for test
        for test = 1
            %disp(test);
            cnt2 =1;
            cnt =1;
            % divisor for change the arm selection
            for divisor = 15
                % model is the number of arms in bk
                for model = 2:2:8
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
                    disp(strcat(dst,'-',num2str(divisor),'-',num2str(model),'-Started'));
                    % initialization
                    [vL] = cm_ts_setupdata(vL);
                    [expV] = ts_function_ensemble(vL);
                    %[data1,mnConv,probofCorrectSelection,probofCorrectSelection_al] = ts_datafetcher(expV,vL,correct,model,data1);
                    [data1] = ts_datafetcher(expV,vL,correct,model,data1);
                    %                 conv3(cnt,cnt2) = mnConv;
                    %                 prb(cnt,cnt2) = probofCorrectSelection;
                    %                 prb2(cnt,cnt2) = probofCorrectSelection_al;
                    %disp(strcat(num2str(divisor),'-',num2str(model),'-Finished'));
                    cnt = cnt+1;
                end
                cnt = 1;
                cnt2 = cnt2 +1;
                dat1.(strcat("dist_",dst,num2str(divisor))).data = data1;
                save(strcat('D:\Sumedh\Projects\Methods for psychiatric DBS programming\DataA\Ensemble method\',dst,num2str(model),'4days.mat'),'dat1','-v7.3');
                dat1 = [];
                data1 = [];
            end
            %         seq{test,:} = prb;
            %         seq_al{test,:} = prb2;
            %         seqcon{test,:} = conv3;
            %datacon{test,:} = data1;
        end
        %     dat1.(strcat("dist_",dst)).data = data1;
        %     save(strcat('D:\800\','800_',dst,'.mat'),'dat1','-v7.3');
        %     dat1 = [];
        %     dat1.(strcat("dist_",dst)).seq = seq;
        %     dat1.(strcat("dist_",dst)).seq_al = seq_al;
        %     dat1.(strcat("dist_",dst)).seqcon = seqcon;
    end
end
k = toc;
end