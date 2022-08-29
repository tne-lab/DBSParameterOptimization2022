% dat1 = ans;
clearvars -except currentAccuracyA
algo = ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]

%algo = ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli"]%,"Poisson"]%,"Normal","bothNormal"];
%algo = ["noalgorithm","greedy"];
for algo_name = algo
for divisor = [1,5:5:25]
    tic;bat = load(strcat('D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Effect of Block-wise vs. trial-wise stimulation\',algo_name,num2str(divisor),'.mat'));toc
    if divisor == 1
        dat = bat;
    end
    dat1.(strcat("dist_",algo_name)).data.test1.(strcat("divisor",num2str(divisor))) = bat.dat1.(strcat("dist_",algo_name,num2str(divisor))).data.test1.(strcat("divisor",num2str(divisor)));
end
end
%%
%load(strcat('500_',algo_name,'.mat'))
ArmNumber_fnd = 1;
for NArms = 4%[2,4,6,8]
    atotal = 0;
    %algo =  ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]
    %dat1 = load('1000_1000_longSimulation_1.mat',strcat("ans.dist_",algo));
    for algo_name = algo
        % reset divisorCount so that we get 1 5 10 15 20 25
        divisorCount = 0;
        for divisor = [1,5:5:25]
            divisorCount = divisorCount + 1;
            % algo -> divisor -> details
            algo_details = dat1.(strcat("dist_",algo_name)).data.test1.(strcat("divisor",num2str(divisor))).(strcat('model',num2str(NArms))).expV.episodeV{1,1};
            alg_convergence = algo_details.convergence1;
            alg_arm_mean = algo_details.probSelected1;
            alg_arm_kprecision = algo_details.probSelected2;
            [NumIteration,~] = size(algo_details.bookV);
            for iterNum = 1: NumIteration
                % finding Bk and sorting it to find the optimal arm
                optim_arms{iterNum,1} = sortrows([algo_details.bookV{iterNum,1}.Bk;1:NArms]');
                % find accuracy for the Nth optimal arm here all
                for armNumber = 1:NArms
                    arm = alg_arm_kprecision(1,iterNum);
%                     arm = algo_details.bookV{1,1}.playArmSelected(end,end);
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
end
% currentAccuracyA = [currentAccuracyA;currentAccuracy];
%%
% close all
icount = 1;i =1;
%algo = ["noalgorithm","greedy","egreedy","UCB","UCBbay","bernoulli","Poisson","Normal","bothNormal"]
for algo_name = algo
    % plot
    %load(strcat('D:\500\extractedData\',algo_name,'.mat'));
    ArmNumber_fnd = 1;
    % algo = ["Normal"];
    for NArms = 4
        figure(1)
        subplot(3,1,1);
        %for algo_name = algo
        plot([1,5:5:25],sum(overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(:,1:ArmNumber_fnd),2),'-o','LineWidth',2);
        hold on;
        %ylim([0 1]);
        ylabel('Accuracy');
        title('Accuracy vs blocksize');
        %end
       % plot(1/NArms,'s','LineWidth',3);
        %
        subplot(3,1,2);
        %for algo_name = algo
        plot([1,5:5:25],sum(overall.(strcat('Site',num2str(NArms))).(algo_name).convergence(:,1:ArmNumber_fnd),2)/ArmNumber_fnd,'-o','LineWidth',2);
        hold on;
        ylim([0 1000]);
        ylabel('convergence');
        title('convergence vs blocksize ');
        %end
        subplot(3,1,3);
        %for algo_name = algo
        plot(sum(overall.(strcat('Site',num2str(NArms))).(algo_name).convergence(3,1:ArmNumber_fnd),2)/ArmNumber_fnd,sum(overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(3,1:ArmNumber_fnd),2),'o','LineWidth',2);
        hold on;
        %ylim([0 1]);
        xlim([0 1000]);
        ylabel('convergence');
        %end
        title('pareto plot');
        legend(algo)
        %sgtitle(strcat("Number of Arms ",num2str(NArms)," Bk [",num2str(optim_arms{1,1}(:,1)'),"]"))
        %
        figure(2)
        divisor = [1,5:5:25];
        for divisorcount = 1:6
            subplot(2,3,divisorcount);
            %for algo_name = algo
            plot(sum(overall.(strcat('Site',num2str(NArms))).(algo_name).convergence(divisorcount,1:ArmNumber_fnd),2)/ArmNumber_fnd,sum(overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(divisorcount,1:ArmNumber_fnd),2),'o','LineWidth',2);
            hold on;
            ylim([0 1]);
            ylabel('convergence');
            xlim([0 1000])
            %end
            title(num2str(divisor(divisorcount)));
        end
        %sgtitle(strcat("Number of Arms ",num2str(NArms)," Bk [",num2str(optim_arms{1,1}(:,1)'),"]"))
        legend(algo)
        % bar plots
        figure(3)
        bpcombined = [];xdata = [];bpcombined2=[];
        bpcombined3 = [];
        bpcombined4 = [];
        bpcombined5 = [];bpcombined6 = [];
        %for algo_name = algo
        subplot(3,3,icount);
        barh([1,5:5:25],overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy,'stacked');
        bpcombined = [bpcombined; overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(1,:)];
        bpcombined2 = [bpcombined2; overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(2,:)];
        bpcombined3 = [bpcombined3; overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(3,:)];
        bpcombined4 = [bpcombined4; overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(4,:)];
        bpcombined5 = [bpcombined5; overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(5,:)];
        bpcombined6 = [bpcombined6; overall.(strcat('Site',num2str(NArms))).(algo_name).accuracy(6,:)];

        xdata = [xdata;algo_name];
        xlabel('Accuracy');xlim([0 1]);
        ylabel('blocksize')
        title(algo_name)
        icount = icount+1;
        set(gca,'box','off')
        set(gca,'FontSize',18)
        set(gca,'LineWidth',2)
        set(gca, 'FontName', 'Times')
        %end
        %
        m.en1(i,:) = bpcombined;
        m.en2(i,:) = bpcombined2;
        m.en3(i,:) = bpcombined3;
        m.en4(i,:) = bpcombined4;
        m.en5(i,:) = bpcombined5;
        m.en6(i,:) = bpcombined6;
        figure(4)
        subplot(3,3,i); i = i +1;
        bar(bpcombined,'stacked');xticklabels(xdata)
        set(gca,'box','off')
        set(gca,'FontSize',18)
        set(gca,'LineWidth',2);
        %ylim([0 0.8])
        set(gca, 'FontName', 'Times');
    end
end
%%
for k = 1:6
figure(5)
subplot(2,1,k);
barh(m.(strcat("en",num2str(k))),'stacked');yticklabels(["BF","greedy","egreedy","UCB","UCBbay","TS-bernoulli","TS-Poisson","TS-Normal","TS-bothNormal"]);
xline([max(max(m.(strcat("en",num2str(k)))))],'-m',"LineWidth",2)
xline([max(min(m.(strcat("en",num2str(k)))))],"LineWidth",2)
%set(gca,'box','off')
set(gca,'FontSize',18)
set(gca,'LineWidth',2);xlim([0 1]);
%ylim([0 0.8])
set(gca, 'FontName', 'Times');
end