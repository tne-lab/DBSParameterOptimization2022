function [bookV] = ts_tracking_plot(vL,bookV,doPlot)
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
figure;
subplot(3,1,1)
plot(bookV.Gen_YRT_value,"LineWidth",1);
hold on
plot(bookV.measured,"LineWidth",1.5);

Arm = 1;
for i =1:vL.divisor:c
    hold on
%     num = num2str(mod(Arm,vL.NArms));
     num = num2str(bookV.playArmSelected(1,i));
%     if(num=="0")
%         num = num2str(vL.NArms);
%     end
%     if(num=="2")
%         num = strcat(num,' No-Stim');
%     end
%     if(num=="4")
%         num = strcat(num,' optimal Stim');
%     end
    xline(i,'--',{strcat('Arm# ',num)});
%     Arm = Arm+1;
end
legend("Generator Y","predicted Y");
%title("Problem with initial Generator and sensor reaction time tracking",'FontSize',20);
title("",'FontSize',20);
xlabel("Trial",'FontSize',20);
ylabel("Reaction time",'FontSize',20);
subplot(3,1,[2 3])
plot(bookV.xbaseline_gen,"LineWidth",1);
hold on;
plot(bookV.xbaseline_sen,"LineWidth",1.5);
plot(bookV.xconflict_gen,"LineWidth",1);
plot(bookV.xconflict_sen,"LineWidth",1.5);
Arm = 1;
for i =1:vL.divisor:c
    hold on
    num = num2str(bookV.playArmSelected(1,i));
%     if(num=="0")
%         num = num2str(vL.NArms);
%     end
%     if(num=="2")
%         num = strcat(num,' No-Stim');
%     end
%     if(num=="4")
%         num = strcat(num,' optimal Stim');
%     end
    xline(i,'--',{strcat('Arm# ',num)});
%     Arm = Arm+1;
end
legend("xbaselineGen","xbaselineSen","xconflictGen","xconflictSen");
%title("Comparison between generated xPos Y (generator func) and Y measured
%xPos from Sensor (compass filtering)");
%title("Problem with initial Generator and Sensor states tracking",'FontSize',20);
xlabel("Trial",'FontSize',20);
ylabel("States",'FontSize',20);
% figure() plot(playArmSelected,'*')
ylim([-8 3]);
end
end