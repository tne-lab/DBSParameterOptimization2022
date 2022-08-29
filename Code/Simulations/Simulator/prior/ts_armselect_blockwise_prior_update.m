function [bookV] = ts_armselect_blockwise_prior_update(bookV,vL,disV,exp_distribution_type)
% arm selection
% if true: change of site/arm, block ended
crit = vL.NArms * vL.divisor + 1+1;
if(mod(bookV.armselCount,vL.divisor)==0)
    bookV.CurrentBlockStart = bookV.trial;
    if bookV.trial < crit
        sampled_vals = bookV.mean_arms;
        % needs a logic to keep on switching arms rather than mean
    elseif exp_distribution_type == "bernoulli"
        for i = 1:length(disV.e_alpha)
            sampled_vals(i,1) = betarnd(disV.e_alpha(i), disV.e_beta(i));
        end
    elseif  exp_distribution_type == "Poisson"
        for i = 1:length(disV.e_alpha)
            sampled_vals(i,1)  = gamrnd(disV.e_alpha(i), 1./disV.e_beta(i));
        end
    elseif  exp_distribution_type == "Normal"
        sampled_vals = gamrnd(disV.e_alpha, 1./disV.e_beta);
    elseif  exp_distribution_type == "bothNormal"
        % note the variables are switched but is uniform throughout
        % kvar should be at kmean place and vice vera, it's consistent
        sampled_vals = normrnd(disV.kvar, 1./(1+disV.kmean));
    elseif exp_distribution_type == "FVTS"
        sampledtheta = normrnd(disV.umean, 1./sqrt(disV.tprecision));
        sampled_vals = normrnd(sampledtheta, sqrt(disV.vVariance));
    elseif exp_distribution_type == "MTS"
        sampledprecision = gamrnd(disV.e_alpha,disV.e_beta);
        sampledtheta = normrnd(disV.umean, 1./sqrt(disV.kprecision.*sampledprecision));
        sampleSD = 1./sqrt(sampledprecision);
        sampled_vals = normrnd(sampledtheta, sampleSD);
    elseif exp_distribution_type == "egreedy" || exp_distribution_type == "greedy"
        p = rand();
        if (vL.epsilon_values(vL.greedyNum) ~= 0 &&  p < vL.epsilon_values(vL.greedyNum))
            atem = randi([1, vL.NArms], [1, 1]);
            sampled_vals = ones(1,vL.NArms);
            sampled_vals(1,atem) = 0;
        else
            sampled_vals = bookV.mean_arms;
        end
    % elseif exp_distribution_type == "noalgorithm"
    %     sampled_vals = bookV.mean_arms;
    %     a = 1; % no sample values here required
    elseif exp_distribution_type == "UCB" || exp_distribution_type == "UCBbay"
        a2samp = 0;
        for a1ind = 1:vL.NArms
            if vL.greedyNum== 1
                a2samp(a1ind) = bookV.mean_arms(a1ind)-1*(sqrt(2*log(bookV.trial)/bookV.playArmSelected_count(a1ind)));
            elseif vL.greedyNum == 2
              % a2samp(a1ind) = bookV.mean_arms(a1ind)-((vL.ucb_values * disV.std_arms(a1ind))/sqrt(bookV.playArmSelected_count(a1ind)/vL.divisor));
              % a2samp(a1ind) = bookV.mean_arms(a1ind)-((vL.ucb_values * disV.std_arms(a1ind))/sqrt(bookV.playArmSelected_count(a1ind)));           
              [m,v] = gamstat(disV.e_alpha(a1ind),1./disV.e_beta(a1ind));
              st = sqrt(v);
              a2samp(a1ind) =m-((vL.ucb_values * st)/sqrt(bookV.playArmSelected_count(a1ind)/vL.divisor));           
              
            end
        end
        sampled_vals = a2samp;
    end
    % ########################################################
    % selecting the arms based on the sampled value
    if exp_distribution_type ~= "noalgorithm"
        if bookV.trial < crit
            if bookV.armselected < vL.NArms
                bookV.armselected = bookV.armselected +1;
            else
                bookV.armselected = bookV.armselected +1 -vL.NArms;
            end
        else
            [~,bookV.armselected] = min(sampled_vals);
        end
    else
        %bookV.armselected = randi([1 vL.NArms]);
        % [~,bookV.armselected] = min(sampled_vals);
        if bookV.armselected < vL.NArms
            bookV.armselected = bookV.armselected +1;
        else
            bookV.armselected = bookV.armselected +1 -vL.NArms;
        end
    end
    bookV.armselCount = bookV.armselCount+1;
else
    % selecting the same site until the block is done
    bookV.armselected = bookV.armselected;
    bookV.armselCount = bookV.armselCount+1;
    if(bookV.trial==1)
        bookV.armselected = 1;
    end
end
end

