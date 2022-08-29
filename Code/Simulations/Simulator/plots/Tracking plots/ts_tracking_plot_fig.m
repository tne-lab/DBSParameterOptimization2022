function [bookV] = ts_tracking_plot_fig(vL,bookV,doPlot,divi)
[~,c] = size(bookV.measured);
for i=1:length(bookV.xpos_gen)
    temp= bookV.xpos_gen{i};
    bookV.xbaseline_gen(i)=temp(1);
    bookV.xconflict_gen(i) = temp(2,1);
    
    temp= bookV.xpos_sen{i};
    bookV.xbaseline_sen(i)= temp(1);
    bookV.xconflict_sen(i) = temp(2,1);
end

if(doPlot == 1)
f = figure(5);
%subplot(2,2,1);
%f.Position = [1000 100 600 500];
plot(bookV.Gen_YRT_value,'r',"LineWidth",2);
hold on
plot(bookV.measured_Yp,'color','b',"LineWidth",2);

fnt = 20;

legend("Generator","Sensor",'location','northeast');
legend('boxoff')
ylim([0 2])
xlim([0 divi])
%title("Problem with initial Generator and sensor reaction time tracking",'FontSize',20);
%title("Reaction time",'FontSize',fnt);
ylabel("Reaction time (sec)",'FontSize',fnt);

set(gca,'box','off');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Trial number",'FontSize',fnt);
set(gca,'linewidth',2);
saveas(gca,strcat('track','.jpg'))

f =figure;
%f.Position = [1000 100 600 500];
%subplot(2,2,2);
colororder({'k','[.25 .25 .52]'}) ;%,
yyaxis left
h2 = boxplot([bookV.Gen_YRT_value' bookV.measured_Yp' nan(divi,2) ],'Widths',0.5,  'FactorGap',0.5,'Colors','k');
set(h2,{'linew'},{2});
% title('Congruent and incongruent trials');
legend("Generator","Sensor",'location','northeast');
legend('boxoff')
set(gca, 'FontName', 'Times');
set(gca,'box','off');
set(gca,'FontSize',20);
set(gca,'linewidth',2);
ylabel('Reaction time (sec)','FontSize',fnt);
ylim([0 2])
yyaxis right
h1 = boxplot([nan(divi,2) (bookV.xbaseline_gen-mean(bookV.xbaseline_gen))' (bookV.xbaseline_sen-mean(bookV.xbaseline_sen))' ],'Labels',{'Gen','Sen','Gen','Sen'},'Widths',0.5,  'FactorGap',0.5, 'color', [.25 .25 .52]);
set(h1,{'linew'},{2});
% title('Congruent and incongruent trials');
set(gca, 'FontName', 'Times');
set(gca,'box','off');
set(gca,'FontSize',20);
set(gca,'linewidth',2);
ylabel('x_{baseline} (a.u.)','FontSize',fnt);
ylim([-1 1])
saveas(gca,strcat('boxSenGen','.jpg'))

%% 
f =figure
%f.Position = [1000 100 600 500];
%subplot(2,2,3);
plot((bookV.xbaseline_gen-mean(bookV.xbaseline_gen)),'r',"LineWidth",2);
hold on
plot((bookV.xbaseline_sen-mean(bookV.xbaseline_sen)),'b',"LineWidth",2);
set(gca,'box','off');
%title("Baseline cognitive state",'FontSize',fnt);
ylabel("x_{baseline} (a.u.)",'FontSize',fnt);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Trial number",'FontSize',fnt);
legend("Generator","Sensor",'location','northeast');
legend('boxoff')
set(gca,'linewidth',2)
ylim([-1 1])
xlim([0 divi])
saveas(gca,strcat('xbaseline','.jpg'))
%%
%subplot(2,2,4)
f =figure
%f.Position = [1000 100 600 500];
plot((bookV.xconflict_gen-mean(bookV.xconflict_gen)),'r',"LineWidth",2);
hold on
plot((bookV.xconflict_sen-mean(bookV.xconflict_sen)),'b',"LineWidth",2);
set(gca,'box','off');
%title("Conflict cognitive state",'FontSize',fnt);
ylabel("x_{conflict} (a.u.)",'FontSize',fnt);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt)
xlabel("Trial number",'FontSize',fnt);
set(gca,'linewidth',2)
legend("Generator","Sensor",'location','northeast');
legend('boxoff')
ylim([-1 1])
xlim([0 divi])
saveas(gca,strcat('xconflict','.jpg'))
% sgt = sgtitle('Sensor-generator behavior tracking');
% % sgt = sgtitle('Sensor tracking generator''s behaviour and cognitive states');
% sgt.FontSize = fnt;
% sgt.FontWeight = 'bold';
% sgt.FontName = 'Times';
end
end