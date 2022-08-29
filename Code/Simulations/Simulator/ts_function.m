function  [expV] = ts_function(vL)
for experimentNum = 1:length(vL.distributionTypes)
    episodeV = struct;
    for episode = 1:vL.NumberOfTimesExpRepeated
        % reset variables
        % setting it for each experiment or sitting
        [disV,conV,bookV,vL] = ts_reset_variables(vL,episode);
        for trial = 1:vL.NTrials
            bookV.trial= trial;
            [bookV] = ts_armselect_blockwise_prior_update(bookV,vL,disV,vL.distributionTypes(experimentNum));
            [bookV] = ts_armcount(bookV);
            [bookV,disV] = ts_call_observer(bookV,disV,vL);
            [disV] = ts_posteriorupdates(bookV,disV,vL,experimentNum);
            [conV] = ts_regretnreward(conV,bookV);
            [bookV] = ts_convergence(bookV,conV,vL,episode,disV);
            if(bookV.flg == true)
                break;
            end
        end
	[bookV] = ts_tracking_plot(vL,bookV,0);
%     [bookV] = ts_tracking_plot_fig(vL,bookV,1,150);
    % ts_boxplot_sengen(bookV);
    % ts_steady_state(vL,bookV);
    %figure(1);
    %steadystateResponse
    %hist(bookV.Gen_YRT_value)
%     a23(episode) = diff(bookV.mean_arms);
    %plot(bookV.playArmSelected,'*')
    [episodeV] = ts_episode_updates(bookV,conV,disV,episode,episodeV,vL);
    close all;
    end
    [expV] = ts_exp_updates(episodeV,vL,experimentNum);
end
end