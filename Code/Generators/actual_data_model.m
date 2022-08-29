function [RDU] = actual_data_model(t2, num, savedat,loc)
% 'MG102','MG104','MG105','MG95','MG96','MG99'
% Model Generation
% Generating the model from all patient
% Fetching the average behaviour
subNumber = ["MG104","MG102","MG105","MG95","MG96","MG99"]';
singleSubject = 2;

for sub = num

load('ybyc.mat');
compiledData = [subject,blockStim];
cd = [responseTimes,interference];
ind = find(string(compiledData(:,2))==({'None'}));
compiledData = compiledData(ind,:);
Alldat = cd(ind,:);

if singleSubject == 2
    indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(sub))}));
    Yc = Alldat(indfin,:);
else
    Yd = responseTimes(ind);
    Yv = interference(ind);
    Yc = [Yd,Yv];
end
%%

[N,~] = size(Yc);
Yb = zeros(N,1);%responseCorrect(ind);
obs_valid = ones(N,1); % since none are MAR or censored
Iter = 25;
nIn = 3;
In = ones(N,nIn);
In(:,1) = 1;
In(:,2) = Yc(:,2);
flg = 1;
while(flg == 1)
%[inp,sites] = S6_arrangingInput(blockStim,StimAny,ind);
inp = zeros(2,12);%inp(:,:);
inp(:,:)= 0;
[~,nU] = size(inp);
%nU = 0;
%Param = compass_create_state_space(nX,nU,nIn,nIb,xM,clink,clinkupdate,dlink,dlinkupdate);
Param = compass_create_state_space(2,nU,nIn,[],eye(2,2),[1 2],[0 0],[],[]);
%Param = compass_set_learning_param(Param,Iter,UpdateStateParam,UpdateStateNoise,UpdateStateX0 ...
%    ,UpdateCModelParam,UpdateCModelNoise,UpdateDModelParam,DiagonalA,UpdateMode,UpdateCModelShift);
% A = 0 so that things A & B is not updated, third parameter
Param.Ak = [0.9999,0;0,0.9999];
% UpdateStateNoise 4
noi = (rand(1)*0.15); % for different individuals
% baseline and conflict [0.0055,0.1250] [15,5]
% Param.Wk = [0.0055+(rand(1)*0.15),0;0,0.0055+(rand(1)*0.15)];
% for [7,15]
% Param.X0 = [sx*randn();sx*randn()];
xmin = 0.0039;
xmax = 0.0884;
n1baseline = xmin + (xmax - xmin)*rand;%xmin + (xmax - xmin)*sum(rand(1,1),2)/1; 
% more or less normal correlation value decreases either side
xmin = 0.00008;
xmax = 0.0110;
n1conflict = xmin + (xmax - xmin)*rand;%xmin + (xmax - xmin)*sum(rand(1,1),2)/1; 
% more uncorrelated data
% Param.Wk = [0.0055+(rand(1)*0.001),0;0,0.0055+(rand(1)*0.001)];
Param.Wk = [n1baseline,0;0,n1conflict];
% noi = (rand(1)*0.1); % for different individuals
% Param.Wk = [0.08+noi,0;0,0.06+noi];
if Param.Wk > 0.25
    disp(Param.Wk);
end
% Param.X0 = [-10;-15];
% Param.Wk = [0.125,0;0,0.08];
% Param.Wk = [0.0313,0;0,0.0156];
Param = compass_set_learning_param(Param,Iter,0,0,1,1,1,0,1,2,1);
%[XSmt,SSmt,Param,rXPos,rSPos,ML,EYn,EYb,rYn,rYb]= compass_em([1 0],zeros(N,1),In,[],Yc,[],Param,obs_valid);
[XSmt,SSmt,Param,rXPos,rSPos,ML,EYn,EYb,rYn,rYb]= compass_em([2 0],[],In,[],Yc(:,1),[],Param,obs_valid);
[DEV_C,~]= compass_deviance([2 0],In,[],rYn,rYb,Param,obs_valid,XSmt,SSmt);
if abs(ML{Iter}.Total-ML{Iter-1}.Total)/ML{Iter-1}.Total > 0.001 || Param.S < 0.18
    Iter = Iter+ 100;
    flg = 1;
else
    %Iter = 100;
    flg = 0;
end
end
S0_Modelplots;
RDU.Param_RDU = Param;
if savedat == 1
 RDU.Xbase_RDU = xm;
 RDU.Xconflict_RDU = trialz;
end
RDU.rSPos_RDU = rSPos;
RDU.rXPos_RDU = rXPos;

%RDU.sites = sites;
%% savedat == 1 save it
if savedat == 1
if singleSubject == 1
    save('RDU.mat','RDU');
    clearvars -except RDU subject interference blockStim StimAny In SSmt
else
    save(strcat(loc,'/',subNumber(sub),'/',num2str(t2),subNumber(sub),'RDU.mat'),'RDU');
    close all;
    clc;
end
end

end

end