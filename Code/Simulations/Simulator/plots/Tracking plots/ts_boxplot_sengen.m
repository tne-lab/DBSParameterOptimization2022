function ts_boxplot_sengen(bookV)
figure;
boxplot([bookV.Gen_YRT_value' bookV.measured'],'Labels',{'gen','sen'});
figure;
boxplot([(bookV.xbaseline_gen-mean(bookV.xbaseline_gen))' (bookV.xbaseline_sen-mean(bookV.xbaseline_sen))'],'Labels',{'gen','sen'});
% figure;
% plot((bookV.xbaseline_gen-mean(bookV.xbaseline_gen)));
% hold on;
% plot((bookV.xbaseline_sen-mean(bookV.xbaseline_sen)));
% legend('gen','sen');
% figure;
% plot((bookV.xconflict_gen-mean(bookV.xconflict_gen)));
% hold on;
% plot((bookV.xconflict_sen-mean(bookV.xconflict_sen)));
% legend('gen','sen');
end