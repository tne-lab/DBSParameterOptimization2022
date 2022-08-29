function [ObserverYn,xpos_gen,spos_gen,xpos_sen,spos_sen,Gen_YRT_value,din,duk,Ysense] = cm_observer_generator(inp,snr,Bk,GeneratorModel,xpos_gen,spos_gen,SensorModel,xpos_sen,spos_sen,din,duk,minmax,maxmax,trial)
%trial setup
c1k(:,1) = GeneratorModel.Ck(1,1) .* ones(1,1);
if trial > 10
c1k(:,2) = randi([0, 1], [1, 1]);
else
    c1k(:,2) = 0;
end
In(:,1) = 1;
In(:,2) = c1k(:,2);
In(:,3) = 1;
GeneratorModel.Bk = Bk;
Uk = inp;
din = [din;In];
duk = [duk;Uk];
DISTR = [2 0];

% ------------------- Generator/Imitator model
[Gen_YRT_value,~,~,xpos_gen,spos_gen]=compass_GetYn(GeneratorModel.S + 0.001,Uk,In,GeneratorModel,xpos_gen,spos_gen,minmax,maxmax);
% ------------------- Sensor/Observer model
%SensorModel
SensorModel.Param_SDMall.Bk = Bk*0;
[xpos_sen,spos_sen,Ysense,~,~]=compass_filtering_up(DISTR,[],In,[],(Gen_YRT_value),[],SensorModel.Param_SDMall,1,xpos_sen,spos_sen);
ObserverYn =xpos_sen(1,1);
if sum(isnan(xpos_sen))> 0
    disp(xpos_sen)
end
end