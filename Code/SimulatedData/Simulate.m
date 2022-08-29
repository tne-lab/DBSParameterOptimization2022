clear
%{
Compare simulated data and actual data
methods:
1) Simulated from actual data model
-- This has minimum noise and the simulated data
is close to the actual data
2) Simulated data from actual model but with noise
-- This should be different from the actual data
3) Using different Vk values
4) Different Wk values but limited by the range as
described in Grid search method

# Things to be displayed here
1. Mean simulated data and simulated data
2. Actual data
3. Mean simulated distinct data and simulated data
4. Mean Vk simulated data and simulated data

Portion 1 includes
a) data simulations using above methods
b) then plots using boundedline
%}

% Subjects
clear;%"MG104";"MG102";"MG105";"MG95";"MG96";"MG99"
%
bins=10;
subNumber = ["MG95";];%"MG96";"MG99";"MG102";"MG104";"MG105";];
subNumber2 = ["S1";];%"S2";"S3";"S4";"S5";"S6"];
% subNumber = ["MG102";];
% subNumber2 = ["S5";];

includeNone = 1;

figure(2)
hold on
for kr = 1:length(subNumber)
      load('ybyc.mat');
    compiledData = [subject,blockStim];
    cd = [responseTimes,interference];
    ind = find(string(compiledData(:,2))==({'None'}));
    compiledData = compiledData(ind,:);
    Alldat = cd(ind,:);
    indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(kr))}));
	Yc = Alldat(indfin,:);
    k =histfit(Yc(:,1),bins,'gamma');
    xlim([0 2]);
    allactual_a(kr,:) = k(2).XData;
    allactual_b(kr,:) = (k(2).YData);
end
% Data simulations options
sim = 2;
loc = "D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Simulated\";
number_of_data = 1000; % simulation included
ploc = 'D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Generator\';
% subsection 1: Creating similar data
%% simulations
for sub_it = 1:length(subNumber)
    
    load('ybyc.mat');
    compiledData = [subject,blockStim];
    cd = [responseTimes,interference];
    ind = find(string(compiledData(:,2))==({'None'}));
    compiledData = compiledData(ind,:);
    Alldat = cd(ind,:);
    indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(sub_it))}));
	Yc = Alldat(indfin,:);
    trials = 1000;%length(Yc);
    for rep =1:number_of_data
        % randomly generated interference
        modOf = 0;
        % 
        rndsub = randi([1 125],1,1);
        load(strcat(ploc,subNumber(sub_it),'\',strcat(num2str(rndsub)),subNumber(sub_it),"RDU.mat"));
        % obtain maximum for both interference = 0 and 1
        if sim ==1
            [minmax,maxmax,mn1,mn2] = ...
                orig_getminmax(subNumber(sub_it));
        elseif  sim == 2|| sim == 3
            [minmax,maxmax] = ...
                getminmax(subNumber(sub_it));
%             if sim == 2
%                 % adding additional noise
%                 RDU.Param_RDU.Vk = RDU.Param_RDU.Vk+randn*0.5;
%             end
        end
        
        % COMPASS toolkit
        DISTR = [2 0];
        Cut_Time =RDU.Param_RDU.S + 0.001;
        Uk= [0 0 0 0 0 0 0 0 0 0 0 0];
        In = ones(1,3);
        val = 0;
        for i = 1:trials
            if i==1
                if sim == 2
                    % initial condition
                    XPos0 = RDU.rXPos_RDU{end,end};
                    SPos0 = RDU.rSPos_RDU{end,end};
                    %RDU.Param_RDU.Dk = RDU.Param_RDU.Dk.*rand(1,1);
                    %RDU.Param_RDU.X0 = RDU.Param_RDU.X0 .* randn(1,1);
                else
                    XPos0 = [0.61815109391019;0.54755655279990];
                    SPos0 = [0.952105634636214,-0.610690211289162;...
                        -0.610690211289162,0.0561343082900841];
                end
            else
                XPos0 = XPos{i-1};
                SPos0 = SPos{i-1};
            end
            % interfernce logic
            if(mod(i,modOf)==0)
                val = ~val;
            end
            if(modOf>0)
                In(:,2) = val;
            else
                In(:,2) = randi([0, 1], [1, 1]);
            end
            interfernce(i)=In(:,2);
            % obtain the reaction
            if sim == 1
                [tYn_sample_sum(i),YP(i),EYn(i),XPos{i},SPos{i}]=...
                    orig_compass_GetYn(Cut_Time,Uk,In,RDU.Param_RDU,XPos0,SPos0,...
                    minmax,maxmax,mn1,mn2);
            else
                [tYn_sample_sum(i),YP(i),EYn(i),XPos{i},SPos{i}]=...
                    compass_GetYn(Cut_Time,Uk,In,RDU.Param_RDU,XPos0,SPos0,...
                    minmax,maxmax);
            end
        end
        % obtain the baseline and conflict
        for i=1:length(tYn_sample_sum)
            temp=XPos{i};
            xbaseline(i)=temp(1);
            xconflict(i) = temp(2,1);
            
            temp=SPos{i};
            xbasevariance(i)=temp(1,1);
            xconflictvariance(i) = temp(2,2);
        end
        % stats
%         D = [interfernce(1:trials);
%             tYn_sample_sum(1:trials)];
%         D = D';
%         E = sortrows(D,1);
%         k = find(E(:,1)==1);
%         [median(E(1:k(1)-1,2)),mean(E(1:k(1)-1,2)),max(E(1:k(1)-1,2)),min(E(1:k(1)-1,2))]
%         [median(E(k(1):end,2)),mean(E(k(1):end,2)),max(E(k(1):end,2)),min(E(k(1):end,2))]
%         
        % model
        SDUall.Xbase_SDU = xbaseline;
        SDUall.Xconflict_SDU = xconflict;
        SDUall.yRT_SDU = tYn_sample_sum;
        SDUall.interference_SDU = interfernce;
        SDUall.randinputs = Uk;
        SDUall.EYn = EYn;
        SDUall.YP = YP;
        if(includeNone == 1)
            if sim == 2
                save(strcat(loc,subNumber(sub_it),"/Different/",num2str(rep),subNumber(sub_it),'SDUall.mat'),'SDUall');
            else
                save(strcat(loc,subNumber(sub_it),"/Same/",num2str(rep),subNumber(sub_it),'SDUall.mat'),'SDUall');
            end
            clearvars -except loc ploc bins subNumber2 number_of_data allactual_a allactual_b rep recordlocation sim trials EYn sub_it subNumber includeNone
            %tYn_sample_sum interfernce YP SDUall
        else
            % save another one
        end
    end
end
%% Simulation data
clearvars b_same a_same a_diff b_diff
figure(5);hold on 
xlim([0 2]);
load('ybyc.mat');
data_fold = ["temp"];
for subN = 1: length(subNumber)
    clearvars htest htestp 
       compiledData = [subject,blockStim];
    cd = [responseTimes,interference];
    ind = find(string(compiledData(:,2))==({'None'}));
    compiledData = compiledData(ind,:);
    Alldat = cd(ind,:);
    indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(subN))}));
	Yc = Alldat(indfin,:);
    for j = 1:length(data_fold)
        for i = 1:number_of_data
            fld = "\Different\";
            disp(strcat(num2str(i),subNumber(subN),"SDUall.mat"))
            if sim ==2
                load(strcat(loc,subNumber(subN),"\Different\",num2str(i),subNumber(subN),"SDUall.mat"));
            else
                load(strcat(loc,subNumber(subN),"\Same\",num2str(i),subNumber(subN),"SDUall.mat"));
            end
            k =histfit(SDUall.yRT_SDU,bins,'gamma');xlim([0 2]);
            a_same(i,:) = k(2).XData;
            bdame(i,:) = (k(2).YData);
            b_same(i,:) = (k(2).YData);
%             figure(7);hold on;
%             plot(bdame(i,:));
%             figure(9);hold on;
%             plot(b_same(i,:));hold off;
            figure(1)
            pd(i) = fitdist(SDUall.yRT_SDU','gamma');
            ad(i,:) = pd(1, i).ParameterValues;
            [htest(i),htestp(i),sta(i)] = ...
                kstest2(SDUall.yRT_SDU,Yc(:,1));
        end
        dat.(subNumber(subN)).(data_fold(j)).x = a_same;
        dat.(subNumber(subN)).(data_fold(j)).y = b_same;
        dat.(subNumber(subN)).(data_fold(j)).fitdist = pd;
        dat.(subNumber(subN)).(data_fold(j)).param = ad;
        dat.(subNumber(subN)).(data_fold(j)).ktesth = htest;
        dat.(subNumber(subN)).(data_fold(j)).ktestp = htestp;
        dat.(subNumber(subN)).(data_fold(j)).actualparam = fitdist(responseTimes(indfin,1),'gamma');
    end
    if fld== "\same\"
        dats = dat;
    else
        datf = dat;
    end
%     sum(dat.(subNumber(subN)).temp.ktesth)
end

%% all data
fnt = 18;
col = ['r','g','b','c','y','m'];
tr = 0.2*ones(6,1);%[0.15,0.15,0.15,0.15,0.15,0.15];
figure(12);hold on;set(0, 'DefaultLineLineWidth', 2);
se = 1;legend();lng =[];
for kt = 1:length(subNumber)
    
    subN = kt;j=1;
    %lng = [lng;subNumber2(subN)];se = se+1;
    hold on;grid off; xlim([0 2]);
    if kt >0
        % subplot(2,2,4);hold on;
        % ad1 = dat.(subNumber(subN)).(data_fold(j)).y;
        % ad1 = ad1./(sum(sum(ad1)));
        % dat.(subNumber(subN)).(data_fold(j)).y = ad1;
        % dat.(subNumber(subN)).(data_fold(j)).y = (dat.(subNumber(subN)).(data_fold(j)).y)./(sum(dat.(subNumber(subN)).(data_fold(j)).y));
        if fld == "\same\"
            [hl,hp] = boundedline(mean(dats.(subNumber(subN)).(data_fold(j)).x),median(dats.(subNumber(subN)).(data_fold(j)).y),std(dat.(subNumber(subN)).(data_fold(j)).y),strcat('-','r'),'transparency', tr(subN),'alpha');
        else
            [hll,hpp] = boundedline(mean(datf.(subNumber(subN)).(data_fold(j)).x),median(datf.(subNumber(subN)).(data_fold(j)).y),std(dat.(subNumber(subN)).(data_fold(j)).y),strcat('-','b'),'transparency', tr(subN),'alpha');
        end
        % ho = outlinebounds(hl,hp);
        % set(ho, 'linewidth',0.05);
        %lng = [lng;strcat("Tuned model",subNumber2(subN))];se = se+1;
        %lng = [lng;strcat("Tuned model mean ",subNumber2(subN))];se = se+1;
    end
end
%%
% [hl,hp] = boundedline(mean(dats.(subNumber(subN)).(data_fold(j)).x),median(dats.(subNumber(subN)).(data_fold(j)).y),std(dat.(subNumber(subN)).(data_fold(j)).y),strcat('-','r'),'transparency', tr(subN),'alpha');
[hll,hpp] = boundedline(mean(datf.(subNumber(subN)).(data_fold(j)).x),median(datf.(subNumber(subN)).(data_fold(j)).y),std(dat.(subNumber(subN)).(data_fold(j)).y),strcat('-','b'),'transparency', tr(subN),'alpha');
hold on
ac = plot(allactual_a(kt,:),allactual_b(kt,:),'k','LineWidth',2);
legend([ac hl hll],{'S1 behavior','S1 simulation','S1 simulation'})
%legend("Not tuned model S1", "Not Tuned model mean S1","Tuned model S1","Tuned model mean S1", "Actual S1")
title("");
% legend('mean SD','SD','mean MD','MD','Actual data')
set(gca, 'FontName', 'Times');
set(gca,'box','off');
xlim([0.25 2.5]);
ylim([0 0.027]);
%a_same = get(gca,'XTickLabel');
%set(gca,'XTickLabel',a_same,'FontName','Times','fontsize',fnt);
xlabel('Reaction time (sec)','FontSize',fnt);
ylabel('Density','FontSize',fnt);
set(gca,'linewidth',2);set(0, 'DefaultLineLineWidth', 1);

% title('Congruent and incongruent trials');
set(gca, 'FontName', 'Times');
set(gca,'box','off');
set(gca,'FontSize',18);
set(gca,'linewidth',2);

% legend({'Model fit to S1 without data cleaning',''});
%%
sum(dat.MG95.temp.ktesth)
sum(dat.MG96.temp.ktesth)
sum(dat.MG102.temp.ktesth)
sum(dat.MG104.temp.ktesth)
sum(dat.MG105.temp.ktesth)
%%
load('C:\Users\Tnel Neuropixels\Desktop\First paper Sumedh\figure 1\temp\same\13MG95SDUall.mat')
intloc = find(SDUall.interference_SDU == 1); % incongruent
intnoloc = find(SDUall.interference_SDU == 0); % congruent
intstr(intloc) = "incongruent";
intstr(intnoloc) = "congruent";
fnt = 18;
h = boxplot(SDUall.yRT_SDU,intstr,'Widths',0.4,'factorgap', 2);
set(h,{'linew'},{2});
% title('Congruent and incongruent trials');
set(gca, 'FontName', 'Times');
set(gca,'box','off');
set(gca,'FontSize',18);
set(gca,'linewidth',2);
ylabel('Reaction time (sec)','FontSize',fnt);
ylim([0 2]);
