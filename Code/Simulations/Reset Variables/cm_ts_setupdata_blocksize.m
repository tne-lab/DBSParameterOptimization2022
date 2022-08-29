function [vL] = cm_ts_setupdata_blocksize(vL)

vL.Stopping = 10^-6;
%vL.NTrials = 500;
vL.NumberOfTimesExpRepeated = 1000;
vL.NArms = vL.model;
vL.check_conv = 100;

[inptemp] = eye(vL.NArms,vL.NArms);
input_to_model = [];
for i = 1:vL.NArms
    input_to_model = [input_to_model;inptemp(i,:)];
end
vL.input_to_model = input_to_model;
vL.epsilon_values = [0,0.1];
vL.ucb_values = 1.96;%3.291;
end

