function [conV] = ts_regretnreward(conV,bookV)
% Cummulative regret, reward
trial = bookV.trial;
conV.playReward(trial) = bookV.measured(trial);
conV.CumplayReward(trial) =(sum(bookV.measured(1:trial-1)) + bookV.measured(trial))/(trial+1);
if(trial<3) 
    conV.CumRegret(trial) = bookV.measured(trial); 
else
    conV.CumRegret(trial) = (bookV.measured(trial)- min(bookV.measured(2:trial-1)))/(trial + 1);
end
end