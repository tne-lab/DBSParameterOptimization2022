%%
% close all
algoSet  = ["noalgorithm","greedy","egreedy","UCB","UCBbay"...
    ,"bernoulli","Poisson","Normal","bothNormal"];
divisor   = 15;%[1,5:5:25];
wkSet = 1:1:11;
trialSet = 600;
siteSet  = 4 ;
alcnt = 0;NArms= 4;
for algo_name = algoSet
    plot(wkSet,sum(overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,1:2),2),'-o','LineWidth',2);
    hold on
end

hold on;
ylabel('Accuracy for blocksize 15');
xlabel('SNR');
set(gca,'box','off')
legend(algoSet)
%legend({"BF","UCB1"},'location','northwest');
set(gca,'FontSize',14)
set(gca,'LineWidth',2);
xticks(wkSet)
xticklabels({"16.67","13.33","10","6.667","3.333","1.667","1.333","1","0.667","0.3333","0.1667"});
xtickangle(45)
xlim([1 11])
set(gca, 'FontName', 'Times');