%% Normalised using range with matlab function normalize
ran = 40;
subNumber = ["MG95","MG96","MG99","MG102","MG104","MG105"]';
subname = ["S1","S2","S3","S4","S5","S6"];
% loc = [3,4,5,8,9,10]';
loc = [3,6]';
T = [];
% remember
% https://www.mathworks.com/matlabcentral/answers/402941-do-matlabs-3d-plots-swap-axes
% meshgrid: X and Y are transposed for Z.
% so if xlabel is xconflict and ylabel is xbaseline
% an alternative is ndgrid does not do this
% make sure to labels id ndgrid is being used
txt = "Log";
%f= figure;
fnt = 24;
r = 2; c = 3;p1 = 1;
f = figure
for it = 1:6
    
    clearvars -except subNumber it T ran txt f fnt r c p1 loc subname
    load(strcat("C:\Users\Tnel Neuropixels\Desktop\First paper Sumedh\figure 3\newsim\5",subNumber(it),'Log_DEV_C.mat'));
    X = 1:ran;%1./(sqrt(2).^(1:ran));
    Y = 1:ran;%1./(sqrt(2).^(1:ran));
    [X,Y] = meshgrid(X,Y);
    Z = cell2mat(DEV_C(1:ran,1:ran));
    Z(find(Z>0)) = 0;
    %Z = normalize(Z,'range');
    % accumulate
    if it == 1
        T = Z;
    else
        T = T + Z;
    end
    if(it == 1 || it ==2)
         h= subplot(r,c,loc(p1))
        
        %surf(X,Y,Z);
        contourf(X,Y,Z)
        
        view(2)
        cbh = colorbar();
        %     colormap('jet');
        
        set(gca, 'FontName', 'Times');
    drawrectangle('Position',[5.29 5 4 5.1],'InteractionsAllowed','none',...
    'EdgeColor','w','LineWidth',2);

    hold on        
    plot(6.5,10,'or','LineWidth',2)
        title(strcat(subname(p1),' model deviance'),'FontSize',fnt,'FontWeight','Normal');p1 = p1+1;
        %         xlabel('scale_{x_{conflict}}');
        %         ylabel('scale_{x_{baseline}}');
        xlabel('scale_2');
        ylabel('scale_1');
        shading interp;
        %shading flat;
        xlim([1 ran]);
        ylim([1 ran]);%caxis([0 0.35])
        set(gca, 'FontName', 'Times');
        %set(gca,'box','off');
        set(gca,'FontSize',fnt);
        %f.Position = [1000 100 600 500];
        %set(gca,'linewidth',2);
        %saveas(gca,strcat(subname(p1-1),'.jpg'))
    end
end
%% Averaged data plot
%f =figure(8)
subplot(r,c,[1 2 4 5])
T = T./it; % averaged
%surf(X,Y,T);
contourf(X,Y,T)

view(2);
cbh = colorbar();
set(gca, 'FontName', 'Times');
title(strcat(" Models mean deviance for log grid search"),'FontSize',fnt,'FontWeight','Normal');
xlabel('scale_2');
ylabel('scale_1');
%xlabel('scale_{x_{conflict}}');
%ylabel('scale_{x_{baseline}}');
%shading interp;
%shading flat;
%grid off
xlim([1 ran]);
ylim([1 ran]);%caxis([0 0.35])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fnt);
    drawrectangle('Position',[5.29 5 4 5.1],'InteractionsAllowed','none',...
    'EdgeColor','w','LineWidth',2);
hold on        
plot(6.5,10,'or','LineWidth',2)
%set(gca,'position',[0.07 0.07 0.92 0.88]);
f.Position = [100 000 1800 1000];
f.PaperOrientation = 'landscape';
f.PaperType = 'A4';
%saveas(gca,strcat('Averaged','.jpg'))
