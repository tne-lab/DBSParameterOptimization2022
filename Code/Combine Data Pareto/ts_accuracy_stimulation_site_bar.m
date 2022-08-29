%%
% close all
algoSet  = ["noalgorithm","greedy","egreedy","UCB","UCBbay"...
    ,"bernoulli","Poisson","Normal","bothNormal"];
divSet   = 15;
trialSet = 600;%[100,250,500,600,700,800,900,1000];
siteSet  = [2,4,6,8];
cnt2 = 0;
for algo_name = algoSet
    ArmNumber_fnd =1;
    cnt = 0;
    cnt2 = cnt2+1;
    for NArms = siteSet
        figure(1)
        cnt = cnt+1;
        data(cnt2,cnt) = sum((overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,ArmNumber_fnd)),2);
        hold on;
        ylabel('Accuracy for 4 Stim sites');
        xlabel('Blocksize')
        %title('Accuracy vs blocksize');
        
    end
end
bar(siteSet,data)
set(gca,'box','off')
legend(algoSet)
%legend({"BF","UCB1"},'location','northwest');
set(gca,'FontSize',18)
set(gca,'LineWidth',2);
%ylim([0.3 0.8])
set(gca, 'FontName', 'Times');