clear
UptillArm = 1;cnt2 = 1;
for days = 3:1:5
    %cnt2 = cnt2 + 1;
    for algo = 1:2
        if algo == 1
            load(strcat("noalgorithm",num2str(8),num2str(days*1000),".mat"));
            g1 =dat1.dist_noalgorithm15.data.test1.divisor15;
        else
            load(strcat("UCB",num2str(8),num2str(days*1000),".mat"));
            g1 =dat1.dist_UCB15.data.test1.divisor15;
        end
        dnt = 1;
        for probsize = 2:2:8
            dt = g1.(strcat("model",num2str(probsize))).expV.episodeV{1,1};
            cnt = 1;
            for i = 0:days:days*1000-days
                ef = i+1:i+days;
                [~,pos(cnt,:)] = max(sum(dt.accuracy(i+1:i+days,:),1));
                cnt = cnt + 1;
            end
            for k = 1:probsize
                df(k) = numel(find(pos==k))/1000;
            end
            dtforplot(dnt,cnt2) = sum(df(1:UptillArm));
            dnt = dnt + 1;
        end
        cnt2 = cnt2 + 1;
        % data(days-2, :) = dtforplot;
    end
end
%% plot 
figure;
styl = [":o",":o","-o","-o","--o","--o"];
colorcode = [0.00 0.45,0.74;0.85 0.33 0.10];
for i = 1:6
    plot([2:2:8],dtforplot(:,i),styl(i),'linew',2 ,'color',colorcode(mod(i+1,2)+1,:));
    hold on;
end
legend({"BF-3","UCB1-3","BF-4","UCB1-4","BF-5","UCB1-5"},"location","southwest");
xticks([2:2:8])
fnt = 18;
xtickangle(45)
set(gca,'box','off');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Problem size",'FontSize',fnt);
ylabel("Accuracy for ensemble method",'FontSize',fnt);
ylim([0.65 1.05]);
xlim([1 9]);
set(gca,'linew',2);