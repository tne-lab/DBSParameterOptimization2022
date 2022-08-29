%%
% close all
algoSet  = ["noalgorithm","greedy","egreedy","UCB","UCBbay"...
    ,"bernoulli","Poisson","Normal","bothNormal"];
divSet   = 15;
trialSet = 600;%[100,250,500,600,700,800,900,1000];
siteSet  = [2,4,6,8];
for NArms = siteSet
           cnt2 = 0;
    for  ArmNumber_fnd =1: NArms
 
        cnt = 0;
        cnt2 = cnt2+1;
        for algo_name = algoSet
            cnt = cnt+1;
            data(cnt2,cnt) = sum((overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,ArmNumber_fnd)),2);
            hold on;
        end
    end
    subplot(2,2,NArms/2);
    bar(data','stacked');
    xticklabels(algoSet);
    xtickangle(45)
    ylim([0 1])
    set(gca,'box','off')
% legend(algoSet)
%legend({"BF","UCB1"},'location','northwest');
set(gca,'FontSize',14)
set(gca,'LineWidth',2);

set(gca, 'FontName', 'Times');
end
