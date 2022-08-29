function [disV,conV,bookV,vL,minmax,maxmax] = ts_reset_variables_wk(vL,episode,gentype)
% new gen and sen
subNumber = ["MG95";"MG96";"MG99";"MG102";"MG104";"MG105";];
j = randi([1 length(subNumber)]);
st = floor(episode/167) + 1;
RDU.Param_RDU.Wk = zeros(2,2);
%add logic here for equal distribution of wk
i = randi([1 25]);
%st = randi([1 length(subNumber)]);
loc = gentype;
% randomly set the sensor and generator models
if i == 0
    load("RDU.mat");
    vL.GenName = "RDU.mat";
else
    %disp(strcat(num2str(i),subNumber(st),"RDU.mat"));
    load(strcat(loc,subNumber(st),"\",num2str(i),subNumber(st),"RDU.mat"));
    vL.GenName = strcat(num2str(i),subNumber(st),"RDU.mat");
end
sid = randi([1 175]);
loc2 = "D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Sensor models\Sensor\";
%load("D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Sensor\Hand Design\SDMall.mat");
load(strcat(loc2,subNumber(j),"\",num2str(sid),subNumber(j),"SDMall.mat"))
vL.SenName =strcat(num2str(sid),subNumber(j),"SDMall.mat");
%load(strcat(subNumber(j),"SDMall.mat"));
%vL.SenName = strcat(subNumber(j),"SDMall.mat");
SDMall.Param_SDMall.S = 0.1;
% SDMall.Param_SDMall.Vk = 15;
% SDMall.Param_SDMall.Wk =[0.0500000000000000,0;0,0.050000000000000];
vL.RDU = RDU;
if RDU.Param_RDU.S < 0.1
    disp((strcat(loc,subNumber(st),"\",num2str(i),subNumber(st),"RDU.mat")));
end
%SDMall.Param_SDMall.Wk = [0.500000000000000,0;0,0.100000000000000];%[SDMall.Param_SDMall.Wk(1,1)*1000,0;0,SDMall.Param_SDMall.Wk(2,2)*100];
%SDMall.Param_SDMall.Wk = [sqrt(SDMall.Param_SDMall.Wk(1,1)),0;0,sqrt(SDMall.Param_SDMall.Wk(2,2))];
%SDMall.Param_SDMall.Wk = Param.Wk = [0.1250,0;0,0.0312];%[(SDMall.Param_SDMall.Wk(1,1)),0;0,(SDMall.Param_SDMall.Wk(2,2))];
%SDMall.Param_SDMall.Vk = 10.2546;
vL.SensorModel = SDMall;

vL.xpos_gen= {ones(vL.NTrials,1)};
vL.spos_gen = {ones(vL.NTrials,1)};
vL.xpos_gen{1} = cell2mat(RDU.rXPos_RDU(1,1)) + rand(1)*randi(2);%[-4.21815109391019;0.134755655279990];
vL.spos_gen{1} = cell2mat( RDU.rSPos_RDU(end,end))+ rand(1)*randi(2);%[0.0252105634636214,-0.0110690211289162;-0.0110690211289162,0.0231343082900841];

vL.xpos_sen = {ones(vL.NTrials,1)};
vL.spos_sen = {ones(vL.NTrials,1)};
vL.xpos_sen{1} = [-SDMall.Param_SDMall.Dk(3);0];%[-4.61639687149457;1.126131283807861];
vL.spos_sen{1} = [0.01,-0.004;-0.004,0.01];%[0.00921758855960999,-0.00469075082896592;-0.00469075082896592,0.0119803996640449];

% Distribution variables
disV.kprecision = 1.* ones(vL.NArms, 1);
% does not work otherwise
%disV.e_alpha = 0*ones(vL.NArms, 1);
%disV.e_beta = 0*ones(vL.NArms, 1);
disV.e_alpha = 1*ones(vL.NArms, 1);
disV.e_beta = 1*ones(vL.NArms, 1);
disV.kvar = zeros(vL.NArms, 1);
disV.kmean = zeros(vL.NArms, 1);
disV.mean_arms = 0.2*ones(vL.NArms,1);
disV.std_arms = 100*ones(vL.NArms,1);
% TS-FVTS
disV.tprecision =inf.* ones(vL.NArms, 1);
disV.umean = 1.*ones(vL.NArms, 1);
disV.vVariance = 0.1250;
% Convergence variables
conV.CumRegret = 0;
conV.CumplayReward = 0;
conV.playReward = zeros(vL.NTrials,1);

% Sensor and Generator values, and input matrix
bookV.measured(1) = -10;
bookV.Gen_YRT_value(1) = 1.3;
bookV.measured_Yp(1) = 1.2;
bookV.Bk = ts_real_Bk(vL);
% bookV.mean_arms = 0.*ones(1, vL.NArms);% Normal needs 0 other may still work
bookV.mean_arms = -100.*ones(1, vL.NArms);
% flg to identify if the
bookV.flg = false;
% block switch variable
bookV.armsel = 0;
% site selection records and probability
bookV.armselected = 0;
bookV.armselCount = 0;
bookV.playArmSelected = 0;
bookV.playArmSelected_count = zeros(vL.NArms,1);
% input matrix reset every single iteration
bookV.k1 =1;
bookV.convergence1=0;
bookV.din = [0 0 0];
bookV.duk = zeros(1,vL.NArms);

% not needed to be reset just for keeping the code together
bookV.xpos_gen= vL.xpos_gen;
bookV.spos_gen= vL.spos_gen;
bookV.xpos_sen = vL.xpos_sen;
bookV.spos_sen= vL.spos_sen;

[vL.minmax,vL.maxmax] = cm_getminmax();
end