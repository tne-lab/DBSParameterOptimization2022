% data = [xbaseline_gen; xbaseline_sen;xconflict_gen; xconflict_sen];
% plotfor = ["gen xbaseline","sen xbaseline","gen conflict","sen conflict"];
alg = 2;
blocks = 25;
totalTrials = 1000;
siteNum = 2;
if (alg == 1)
    data = [bookV.Gen_YRT_value;bookV.measured_Yp];
else
    data = [bookV.xbaseline_gen-mean(bookV.xbaseline_gen);bookV.xbaseline_sen-mean(bookV.xbaseline_sen)];
end
[r,~] = size(data);

%%
r = 2;
p =1;
term = 1;
fnt =20;
col = ['r','b'];
count = 1;
for j = 1:size(data)
    % data 1 : generator
    % data 2 : sensor
    con = 1;
    site2 = [];
    site1 = [];
    for i = 1:blocks:totalTrials
        if(mod(con,siteNum)==0)
            site2 = [site2;data(j,i:i+blocks-1)];
        else
            site1 = [site1;data(j,i:i+blocks-1)];
        end
        con =con+1;
    end
    
    figure(p)
    if (count == 1)
        [h1,hp] = boundedline(1:1:blocks,mean(site2(:,:)),std(site2(:,:)),col(term),'alpha');
        set(h1, 'LineWidth', 2, 'color', col(term));
    else
        [h2,hp] = boundedline(1:1:blocks,mean(site2(:,:)),std(site2(:,:)),col(term),'alpha');
        set(h2, 'LineWidth', 2, 'color', col(term));
    end
    
    xlabel('Trials','FontSize',fnt);
    if alg == 1
        ylabel("Reaction time (sec)",'FontSize',fnt);
    else
        ylabel("x_{baseline} (a.u.)",'FontSize',fnt);
    end
    set(gca,'linewidth',2);
    
    
    p = p+1;
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
    xlabel("Trial number",'FontSize',fnt);
    set(gca,'XTickLabelMode','auto');
    set(gca,'linewidth',2)
    ylim([-1 1])
    figure(p)
    %    subplot(2,1,p)
    if (count == 1)
        [h3,hp] = boundedline(1:1:blocks,mean(site1(:,:)),std(site1(:,:)),col(term),'alpha');
        set(h3, 'LineWidth', 2, 'color', col(term));
    else
        [h4,hp] = boundedline(1:1:blocks,mean(site1(:,:)),std(site1(:,:)),col(term),'alpha');
        set(h4, 'LineWidth', 2, 'color', col(term));
    end
    xlabel('Trials');
    if alg == 1
        ylabel("Reaction time (sec)",'FontSize',fnt);
    else
        ylabel("x_{baseline} (a.u.)",'FontSize',fnt);
    end
    set(gca,'linewidth',2);
    p =1;
    term = term +1;
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
    xlabel("Trial number",'FontSize',fnt);
    set(gca,'XTickLabelMode','auto')
    set(gca,'linewidth',2);
    count = count +1;
end
figure(1);
legend([h1 h2],{'Generator','Sensor'},'Location','southeast')
legend('boxoff');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Trial number",'FontSize',fnt);
set(gca,'linewidth',2);ylim([-1 1])
if alg == 1
    saveas(gca,strcat('RToptimal','.jpg'));
else
    saveas(gca,strcat('baselineoptimal','.jpg'));
end

figure(2);
legend([h3 h4],{'Generator','Sensor'})
legend('boxoff')
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Trial number",'FontSize',fnt);
set(gca,'linewidth',2);ylim([-1 1])
if alg == 1
    saveas(gca,strcat('RTnonoptimal','.jpg'));
else
    saveas(gca,strcat('baselinenonoptimal','.jpg'));
end
f = figure(p);
set(gca,'box','off');
%f.Position = [200 200 250+100 175+125];

