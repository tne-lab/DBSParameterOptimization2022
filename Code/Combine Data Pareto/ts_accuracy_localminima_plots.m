%%
% close all
algoSet  = ["noalgorithm","UCB"]%,"greedy","egreedy","UCB","UCBbay"...
    %,"bernoulli","Poisson","Normal","bothNormal"];
divSet   = 15;%[1,5:5:25];
trialSet = 600;%[100,250,500,600,700,800,900,1000];
siteSet  = [2,4,6,8];
cnt = 1;bSet = 1:1:7;
alcnt = 0;NArms= 2;
for algo_name = algoSet
    plot(bSet,overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,1),'-o','LineWidth',2);
    hold on
end

hold on;
ylabel('Accuracy for blocksize 15');
xlabel('Stimulation effect decrease');
set(gca,'box','off')
legend({"BF","UCB1"});
set(gca,'FontSize',18)
set(gca,'LineWidth',2);
xticks(bSet)
xticklabels({"b1","b2","b3","b4","b5","b6","b7"})
xlim([0 7.5])
set(gca, 'FontName', 'Times');