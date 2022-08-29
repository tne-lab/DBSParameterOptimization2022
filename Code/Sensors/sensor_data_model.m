function [RDU] = sensor_data_model(t2, num, savedat,loc,locGen)
subNumber = ["MG104","MG102","MG105","MG95","MG96","MG99"]';
singleSubject = 1;
% loc = "D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Sensor";
%
for sub = num
    load(strcat(locGen,'\',subNumber(sub),'\Different\',num2str(num),subNumber(sub),'SDUall.mat'));
    interference = SDUall.interference_SDU;
    yRT = SDUall.yRT_SDU;
    Yc = yRT';
    ind = 1:length(yRT);
    nU = 12;
    % setup
    [N,~] = size(Yc);
    Yb = zeros(N,1);
    obs_valid = ones(N,1);
    nIn = 3;
    In = ones(N,nIn);
    In(:,1) = 1;
    In(:,2) = SDUall.interference_SDU;
    Iter = 25;
    flg = 1;
    while(flg == 1)
        Param = compass_create_state_space(2,nU,nIn,[],eye(2,2),[1 2],[0 0],[],[]);
        xmin = 0.0156 + 0.07;
        xmax = 0.0884 + 0.07;
        n1baseline = xmin + (xmax - xmin)*sum(rand(1,1),2)/1 + 0.05;
        % more or less normal correlation value decreases either side
        xmin = 0.00008 + 0.07;
        xmax = 0.0110  + 0.07;
        n1conflict = xmin + (xmax - xmin)*sum(rand(1,1),2)/1 + 0.05;
        Param.Wk = [n1baseline,0;0,n1conflict];
        Param.Ak = [0.9999,0;0,0.9999];
        Param = compass_set_learning_param(Param,Iter,0,0,1,1,1,0,1,2,1);
        [XSmt,SSmt,Param,rXPos,rSPos,ML,EYn,EYb,rYn,rYb]= compass_em([2 0],[],In,[],Yc,[],Param,obs_valid);
        if abs(ML{Iter}.Total-ML{Iter-1}.Total)/ML{Iter-1}.Total > 0.001
            Iter = Iter+ 100;
            flg = 1;
        else
            %Iter = 100;
            flg = 0;
        end
    end
    S0_Modelplots;
    SDMall.rSPos_SDMall= rSPos;
    SDMall.rXPos_SDMall= rXPos;
    SDMall.Xconflict_SDMall = trialz;
    SDMall.Xbase_SDMall = xm;
    SDMall.Param_SDMall = Param;
    if(singleSubject == 1)
        close all;
        save(strcat(loc,"/",subNumber(sub),'/',num2str(t2),subNumber(sub),'SDMall.mat'),'SDMall');
        clearvars -except loc locGen RDU SDUall sub SDMall subject subNumber singleSubject interference blockStim StimAny
    else
        
        save(strcat(subNumber(sub),'NoneSDMall.mat'),'SDMall');
    end
end
end