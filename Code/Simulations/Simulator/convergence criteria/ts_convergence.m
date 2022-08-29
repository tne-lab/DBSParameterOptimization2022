function [bookV]= ts_convergence(bookV,conV,vL,episode,disV)
% Convergence
trial = bookV.trial;
% if (3*10*vL.divisor == 20000)
%     val = 100;
% else
%     val = 3*10*vL.divisor;
% end
% if vL.divisor  == 100
%     check_val = 100;
% else
%     check_val = val;
% end
if vL.divisor == 1 || vL.divisor == 5
    check_val = 20000;
end
if vL.divisor == 10
    check_val = 20000;
end
if vL.divisor == 15
    check_val = 20000;
end
if vL.divisor == 20
    check_val = 20000;
end
if vL.divisor >= 25
    check_val = 20000;
end
if vL.distributionTypes ~= "noalgorithm"
    if vL.techni == 1
        %     if trial > check_val && sum(isnan(bookV.mean_arms))==0 && (mod(bookV.armselCount,vL.divisor)==0) && sum((bookV.mean_arms)==0)==0
        %         if abs(mean(diff(conV.CumRegret(trial-2*vL.divisor:trial)))) < vL.Stopping && bookV.flg == false
        %             bookV.convergence1 = trial;
        %             bookV.flg = true;
        %         end
        %         if abs(mean(diff(conV.CumplayReward(trial-2*vL.divisor:trial)))) < vL.Stopping && bookV.flg == false
        %             bookV.convergence1 = trial;
        %             bookV.flg = true;
        %         end
        %     end
        
        if trial > check_val && sum(isnan(bookV.mean_arms))==0 && (mod(bookV.armselCount,vL.divisor)==0) && sum((bookV.mean_arms)==0)==0
            %             if(vL.divisor < 15)
            if length(find(bookV.playArmSelected(:,trial-3*vL.divisor:trial) == bookV.playArmSelected(:,trial)))>2*vL.divisor && vL.divisor > 1
                bookV.convergence1 = trial;
                %disp(convergence);
                bookV.flg = true;
            end
            if vL.divisor ==1
            if length(find(bookV.playArmSelected(:,trial-15*vL.divisor:trial) == bookV.playArmSelected(:,trial)))>12*vL.divisor && vL.divisor == 1
                bookV.convergence1 = trial;
                %disp(convergence);
                bookV.flg = true;
            end
            end
            %         if sum((disV.kprecision./sum(disV.kprecision))>0.5) == 1
            %          	bookV.convergence1 = trial;
            %             %disp(convergence);
            %             bookV.flg = true;
            %         end
            %         if sum((bookV.playArmSelected_count./sum(bookV.playArmSelected_count))>0.5) == 1
            %          	bookV.convergence1 = trial;
            %             %disp(convergence);
            %             bookV.flg = true;
            %         end
        end
    end

    if trial == vL.NTrials && bookV.flg == false
        bookV.convergence1 = trial;
    end
end
end