function [expV] = ts_exp_updates(episodeV,vL,experimentNum)
% expV.convergence(experimentNum,:) = episodeV.convergence1';
% expV.probSelected(experimentNum,:) =episodeV.probSelected1';
% expV.probSelected_al(experimentNum,:) =episodeV.probSelected2';
% expV.Experiments_CumReward(experimentNum,:) = episodeV.Episode_indiv_play_CumReward;
% expV.Experiments_MeanReward(experimentNum,:) = episodeV.Episode_indiv_play_Reward;
% expV.Experiments_CumRegret(experimentNum,:) = episodeV.Episode_indiv_play_Regret;
% expV.Experiments_selections(experimentNum,:) = episodeV.Episode_indiv_play_selections;
expV.episodeV{experimentNum,:} = episodeV;
% expV.Experiments_MeanSelectionCount(experimentNum,:) = mean(episodeV.Episode_indiv_play_action_selection,1);
%expV.Experiments_Mean_action_selection_prob.(vL.distributionTypes(experimentNum)) = episodeV.Episode_indiv_play_action_selection_prob./vL.NumberOfTimesExpRepeated;
end