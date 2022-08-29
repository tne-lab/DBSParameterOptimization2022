%{
Accuracy vs stimulation sites
%}
location = ...
    'D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Effect of noise wk\';
algoSet  = ["noalgorithm","greedy","egreedy","UCB","UCBbay"...
,"bernoulli","Poisson","Normal","bothNormal"];
divisor   = 15;%[1,5:5:25];
wkSet = 1:1:11;
trialSet = 600;
siteSet  = 4 ;
% dat      = [];
NArms = 4;
for algo_name = algoSet
    divisorCount = 0;
    for b = wkSet  
        divisorCount = divisorCount + 1;
        tic;
        bat = load(strcat(location,algo_name,num2str(b),'.mat'));
        toc;
        dat1.(strcat("dist_",algo_name,num2str(b))).(strcat("bin",num2str(b))) = bat.dat1.(strcat("dist_",algo_name,num2str(divisor))).data.(strcat("test",num2str(1))).(strcat("divisor",num2str(divisor)));
        algo_details = dat1.(strcat("dist_",algo_name,num2str(b))).(strcat("bin",num2str(b))).(strcat('model',num2str(siteSet))).expV.episodeV{1,1};
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
        currentAccuracy(divisorCount,1:NArms) = sum(algo_acc_count,1)./NumIteration;
        currentconverge(divisorCount,1:NArms) = sum(algo_con_count,1)./sum(algo_acc_count,1);
        currentconverge(isnan(currentconverge))=0;
    end
    overall.(strcat('Site',num2str(NArms))).(algo_name).(strcat("accuracy")) = currentAccuracy;
    overall.(strcat('Site',num2str(NArms))).(algo_name).(strcat("convergence")) = currentconverge;
end