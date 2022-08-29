%{
Accuracy vs stimulation sites
%}
location = ...
    'D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Effect of number of stimulation sites\number of site test large\';
algoSet  = ["noalgorithm","greedy","egreedy","UCB","UCBbay"...
    ,"bernoulli","Poisson","Normal","bothNormal"];
divSet   = 15;%[1,5:5:25];
trialSet = 600
siteSet  = [2,4,6,8];
% dat      = [];
for k = trialSet
    ArmNumber_fnd = 1;
    for divisor = divSet
        atotal = 0;
        for algo_name = algoSet
            % reset divisorCount so that we get 1 5 10 15 20 25
            divisorCount = 0;
            tic;bat = load(strcat(location,algo_name,num2str(divisor),'.mat'));toc
            dat1.(strcat("dist_",algo_name,num2str(divisor))).data.test1.(strcat("divisor",num2str(divisor))) = bat.dat1.(strcat("dist_",algo_name,num2str(divisor))).data.test1.(strcat("divisor",num2str(divisor)));
            
            for NArms = siteSet
                divisorCount = divisorCount + 1;
                algo_details =  ...
                    dat1.(strcat("dist_",algo_name,num2str(divisor))).data.test1.(strcat("divisor",num2str(divisor))).(strcat('model',num2str(NArms))).expV.episodeV{1,1};
                % algo -> divisor -> details
                alg_convergence = algo_details.convergence1;
                alg_arm_mean = algo_details.probSelected1;
                alg_arm_kprecision = algo_details.probSelected2;
                [NumIteration,~] = size(algo_details.bookV);
                for iterNum = 1: NumIteration
                    % finding Bk and sorting it to find the optimal arm
                    optim_arms{iterNum,1} = sortrows([algo_details.bookV{iterNum,1}.Bk;1:NArms]');
                    % find accuracy for the Nth optimal arm here all
                    for armNumber = 1:NArms
                        arm = alg_arm_mean(1,iterNum);
                        % arm = algo_details.bookV{1,1}.playArmSelected(end,end);
                        flg = (arm == optim_arms{iterNum,1}(armNumber,3));
                        algo_acc_count(iterNum,armNumber) = flg;
                        if flg
                            algo_con_count(iterNum,armNumber) = algo_details.convergence1(1,iterNum);
                        else
                            algo_con_count(iterNum,armNumber) = 0;
                        end
                    end
                end
                overall.(strcat('Site',num2str(NArms))).(algo_name).(strcat("accuracy")) = sum(algo_acc_count,1)./NumIteration;
                overall.(strcat('Site',num2str(NArms))).(algo_name).(strcat("convergence")) = sum(algo_con_count,1)./sum(algo_acc_count,1);
            end
            
        end
    end
end