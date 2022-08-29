function [disV] = ts_posteriorupdates(bookV,disV,vL,experimentNum)
% posterior
exp_distribution_type = vL.distributionTypes(experimentNum);
trial = bookV.trial;
armselected = bookV.armselected;

if mod(trial,vL.divisor)==0 && trial > 2
    if(bookV.CurrentBlockStart - vL.divisor)>0
        % Keeping a track of how many times which arms are selected and
        % improved the reaction time is decreasing
        % A: current B: previous
        % tf_findSitemean provides mean for a selected site
        A = ts_findSitemean(bookV,vL,bookV.CurrentBlockStart,(bookV.CurrentBlockStart+vL.divisor-1));
        if(bookV.armselected == bookV.mn_pt_selection(end-1,end))
            k = 1:vL.NArms;
            kd = [bookV.mean_arms;k];
            kd = kd(:,find(kd(1,:)~=0));
            % selecting a minimum value except the current value
            % if its producing the minimum value since we are comparing the
            % mean reaction of previous values
            B = min(kd(1,find(kd(2,:)~=bookV.mn_pt_selection(end-1,end))));
            if ~isempty(B)
                if(isnan(B) || sum(B==0)==1)
                    B = ts_findSitemean(bookV,vL,bookV.CurrentBlockStart- vL.divisor,(bookV.CurrentBlockStart-1));
                end
            end
        else
            B = ts_findSitemean(bookV,vL,bookV.CurrentBlockStart- vL.divisor,(bookV.CurrentBlockStart-1));
        end
        if A <= B
            disV.nkprecision = disV.kprecision(bookV.armselected) + 1;
            disV.kprecision(bookV.armselected) = disV.nkprecision;
        end
        if exp_distribution_type == "UCBbay"
            if trial > 1
            if A >= B
                disV.e_alpha(armselected)=disV.e_alpha(armselected) + 0.5;
                %https://arxiv.org/pdf/1910.04938.pdf
            else
                %disV.e_beta(armselected)=disV.e_beta(armselected)+ (bookV.measured(trial)-mean(bookV.measured(1:trial)))^2/2;
                %k5 = bookV.mn_pt_selection(bookV.mn_pt_selection(:,end)==bookV.armselected,1:end-1);k5 = mean(k5(:));
                k5 = bookV.mn_pt_selection(2:end,end-1);
                k5 = mean(k5(:));
                disV.e_beta(armselected)=disV.e_beta(armselected)+ ((A-k5))^2/2;
            end
            end
        elseif exp_distribution_type == "bernoulli"
            if A >= B
                disV.e_alpha(armselected)=disV.e_alpha(armselected) + 1;
            else
                disV.e_beta(armselected)=disV.e_beta(armselected)+  1;
            end
        elseif exp_distribution_type == "Poisson"
            if A >= B
                disV.e_alpha(armselected)=disV.e_alpha(armselected) + abs(A-B)*10;% abs(fix(A)-(A));%bookV.measured(trial);
            else
                disV.e_beta(armselected)=disV.e_beta(armselected)+ 1;
            end
        elseif exp_distribution_type == "Normal"
            if A >= B
                disV.e_alpha(armselected)=disV.e_alpha(armselected) + 0.5;
                %https://arxiv.org/pdf/1910.04938.pdf
            else
                %disV.e_beta(armselected)=disV.e_beta(armselected)+ (bookV.measured(trial)-mean(bookV.measured(1:trial)))^2/2;
                %k5 = bookV.mn_pt_selection(bookV.mn_pt_selection(:,end)==bookV.armselected,1:end-1);k5 = mean(k5(:));
                k5 = bookV.mn_pt_selection(:,end-1);
                k5 = mean(k5(:));
                disV.e_beta(armselected)=disV.e_beta(armselected)+ ((A-k5))^2/2;
            end
        elseif exp_distribution_type == "bothNormal"
            if A >= B
                disV.kvar(armselected)=(disV.kvar(armselected)*disV.kmean(armselected)+ abs(A))/(disV.kmean(armselected)+1);%abs(bookV.measured(trial)))/(disV.kmean(armselected)+1);
                %https://arxiv.org/pdf/1910.04938.pdf
            else
                disV.kmean(armselected)=disV.kmean(armselected) + 1;
                
            end
        elseif exp_distribution_type == "FVTS"
            if A >= B
                temn = (disV.umean(armselected)/disV.tprecision(armselected)^2) + (A./disV.vVariance^2);
                temd = (1./disV.tprecision(armselected)^2)+(1/disV.vVariance^2);
                numean = temn./temd;
                disV.umean(armselected) = numean;
            else
                temr = (1./disV.tprecision(armselected)^2)+(1/disV.vVariance^2);
                ntprecision = 1./sqrt(temr);
                disV.tprecision(armselected) = ntprecision;
                nkprecision = disV.kprecision(armselected) + 1;
                disV.kprecision(armselected) = nkprecision;
            end
        elseif exp_distribution_type == "MTS"
            if A >= B
                numean = (disV.kprecision(armselected)*disV.umean(armselected)+1*(A))/(disV.kprecision(armselected)+1);
                disV.umean(armselected) = numean;
                ne_alpha = disV.e_alpha(armselected)+ 1/2;
                disV.e_alpha(armselected) = ne_alpha;
            else
                xb = bookV.mean_arms(1,armselected);
                
                tem = 0.5*(sum(A-xb).^2) ;
                tem2 = (1.*disV.kprecision(armselected).*(xb-disV.umean(armselected)).^2)./(2*(1+disV.kprecision(armselected)));
                ne_beta = (disV.e_beta.^-1 + tem + tem2).^-1;
                
                disV.e_beta(armselected) = ne_beta(armselected);
                nkprecision = disV.kprecision(armselected) + 1;
                disV.kprecision(armselected) = nkprecision;
            end
        end
    end
end
end