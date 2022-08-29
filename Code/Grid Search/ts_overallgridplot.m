%% Normalised using range with matlab function normalize
close all;
ran = 40;
subNumber = ["MG95","MG96","MG99","MG102","MG104","MG105"]';
subname = ["S1","S2","S3","S4","S5","S6"];
% loc = [3,4,5,8,9,10]';
loc = [3,6]';
T = [];
txt = "Log";
fnt = 24;
f = figure;
X = 1:ran;
Y = 1:ran;
[X,Y] = meshgrid(X,Y);
r = 2; c = 3;p1 = 1;
cnter = 0;
for it = 1:6
    for num = 1:6
        clearvars -except cnter subNumber X Y lgData it T ran txt f fnt r c p1 loc subname num
        load(strcat("C:\Users\Tnel Neuropixels\Desktop\First paper Sumedh\figure 3\newsim\",num2str(num),subNumber(it),'Log_DEV_C.mat'));
        Z = cell2mat(DEV_C(1:ran,1:ran));
        Z(find(Z>0)) = 0;
%         Z = normalize(Z,'scale','iqr');
        % first instance
        if num == 1 && it ==1
            T = Z;
            cnter = cnter +1;
        end
        if num == 1

            lgData = Z;
            if it > 1
                T = Z + T;
                cnter = cnter +1;
            end
        else
            lgData = lgData + Z;
            T = T + Z;
            cnter = cnter +1;
        end
    end
    if(it == 1 || it ==2)
        h= subplot(r,c,loc(p1));
        contourf(X,Y,lgData/6);
        view(2);
        cbh = colorbar();
        set(gca, 'FontName', 'Times');
        title(strcat(subname(p1),' model deviance'),'FontSize',fnt,'FontWeight','Normal');p1 = p1+1;
        %hold on;
        %plot(10,6.5,'*r');
        xlabel('scale_2');
        ylabel('scale_1');
        shading interp;
        %shading flat;
%         xlim([1 ran]);
%         ylim([1 ran]);%caxis([0 0.35])
        set(gca, 'FontName', 'Times');
        %set(gca,'box','off');
        set(gca,'FontSize',fnt);
     	rectangle('Position',[13 7 14 5],'EdgeColor','r','LineWidth',3)
        %f.Position = [1000 100 600 500];
        %set(gca,'linewidth',2);
        %saveas(gca,strcat(subname(p1-1),'.jpg'))
    end
     clearvars lgData    
end
% Averaged data plot
subplot(r,c,[1 2 4 5])
T = T./(it*num);
contourf(X,Y,T)
view(2);
cbh = colorbar();
set(gca, 'FontName', 'Times');
title(strcat(" Models mean deviance for log grid search"),'FontSize',fnt,'FontWeight','Normal');
xlabel('scale_2');
ylabel('scale_1');
xlim([1 ran]);
ylim([1 ran]);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt);
     	rectangle('Position',[13 7 14 5],'EdgeColor','r','LineWidth',3)

%hold on;
%plot(10,6.5,'*r');
f.Position = [100 000 1800 1000];
f.PaperOrientation = 'landscape';
f.PaperType = 'A4';
%saveas(gca,strcat('Averaged','.jpg'))
