clear;
figure;
UptillArm = 1;
cnt2 = 0;
for ttl = [1000:1000:4000]
    cnt2 = cnt2 + 1;
spac = ttl/1000;
for k1 = 1:2
    clearvars  df 
if k1 == 1
    load(strcat("noalgorithm",num2str(8),num2str(ttl),".mat"));
    if ttl ~= 50000
        g1 =dat1.dist_noalgorithm15.data.test1.divisor15;
    end
else
  	load(strcat("UCB",num2str(8),num2str(ttl),".mat"));
    if ttl~= 50000
        g1 =dat1.dist_UCB15.data.test1.divisor15;
    end
end
dnt = 0;
for ij = 2:2:8
    dnt = dnt + 1;
    dt = g1.(strcat("model",num2str(ij))).expV.episodeV{1,1};
    cnt = 1;
    for i = 0:spac:ttl-spac
        ef = i+1:i+spac;
        [b(cnt,:),a(cnt,:)] = max(sum(dt.accuracy(i+1:i+spac,:),1));
        cnt = cnt + 1;
    end
    
    for k = 1:ij
        df(k) = numel(find(a==k))/1000;
    end
    dtforplot(dnt,cnt2) = sum(df(1:UptillArm));
    %plot(df,'-o',"LineWidth",2);
    %hold on;
    
end
if k1 == 1
   plot([2:2:8],dtforplot,'-o',"LineWidth",2)
else
       plot([2:2:8],dtforplot,'-o',"LineWidth",2)
end

   hold on;
end
end
% ylim([0 1])
xticks([2:2:8])
fnt = 18;
% legend({"BF 3 days","UCB1 3 days","BF 4 days","UCB1 4 days","BF 5 days","UCB1 5 days"});
xtickangle(45)
set(gca,'box','off');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Blocksize",'FontSize',fnt);
ylabel("Accuracy",'FontSize',fnt);