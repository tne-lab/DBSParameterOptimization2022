%%
% close all
algoSet  = ["noalgorithm","UCB"];%,"greedy","egreedy","UCB","UCBbay"...
    %,"bernoulli","Poisson","Normal","bothNormal"];
divSet   = 15;%[1,5:5:25];
trialSet = 600;%[100,250,500,600,700,800,900,1000];
siteSet  = [2,4,6,8];
lmin = [1,1,1,1];
cnt = 1;
alcnt = 0;
for algo_name = algoSet
    alcnt =  alcnt  +1 ;
    cnt = 1;
    for NArms = siteSet
        wrk(alcnt ,cnt) =sum( overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,1:lmin(cnt)) , 2);
        cnt = cnt + 1;
    end
end
plot(siteSet,wrk,'-o','LineWidth',2);
hold on;
ylabel('Accuracy');
xlabel('Stimulation sites');
set(gca,'box','off')
%legend({"BF","UCB1"});
legend(algoSet);
set(gca,'FontSize',18)
set(gca,'LineWidth',2);
%ylim([0.22 0.9])
xlim([1 9])
set(gca, 'FontName', 'Times');