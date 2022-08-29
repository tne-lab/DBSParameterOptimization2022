%%
% close all
algoSet  = ["noalgorithm","greedy","egreedy","UCB","UCBbay"...
    ,"bernoulli","Poisson","Normal","bothNormal"];
divSet   = [1,5:5:25];
trialSet = 600;%[100,250,500,600,700,800,900,1000];
siteSet  = 4;%[2,4,6,8];
for algo_name = algoSet
    ArmNumber_fnd =1;
    for NArms = siteSet
        figure(1)
        plot(divSet,sum(overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,ArmNumber_fnd),2),'-o','LineWidth',2);
        hold on;
        ylabel('Accuracy for 4 Stim sites');
        xlabel('Blocksize')
        %title('Accuracy vs blocksize');
        
    end
end
set(gca,'box','off')
legend(algoSet)
%legend({"BF","UCB1"},'location','northwest');
set(gca,'FontSize',18)
set(gca,'LineWidth',2);
%ylim([0.3 0.8])
set(gca, 'FontName', 'Times');