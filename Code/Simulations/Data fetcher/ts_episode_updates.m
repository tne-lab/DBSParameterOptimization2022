function [episodeV] = ts_episode_updates(bookV,conV,disV,episode,episodeV,vL)
% episodeV.Episode_indiv_play_action_selection(episode,:) = bookV.playArmSelected_count;
% episodeV.Episode_indiv_play_Reward{episode,:} = conV.playReward;
% episodeV.Episode_indiv_play_Regret{episode,:} = conV.CumRegret;
% episodeV.Episode_indiv_play_CumReward{episode,:} = conV.CumplayReward;
% episodeV.Episode_indiv_play_selections{episode,:} = bookV.playArmSelected;
[~,episodeV.probSelected1(episode)] = min(bookV.mean_arms);
[~,episodeV.probSelected2(episode)] = max(disV.kprecision);
[~,episodeV.probSelected3(episode)] = max(disV.kvar);
[~,episodeV.probSelected4(episode)] = max(bookV.playArmSelected_count);
episodeV.convergence1(episode) = bookV.convergence1;
tem = sortrows([bookV.Bk;1:vL.NArms]');
episodeV.accuracy(episode,:)=(episodeV.probSelected1(episode) == tem(1:vL.NArms,3))';
% episodeV.bookV{episode,:}=bookV;
% episodeV.conV{episode,:}=conV;
% episodeV.disV{episode,:}=disV;
episodeV.sensormodel{episode,:}=vL.SenName;
episodeV.generatormodel{episode,:}=vL.GenName;
% episodeV.episodeV{episode,:}=episodeV;
end