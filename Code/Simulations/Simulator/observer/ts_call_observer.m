function [bookV,disV] = ts_call_observer(bookV,disV,vL)
trial = bookV.trial;
if trial ~=1
    [bookV.measured(trial),...
        bookV.xpos_gen{trial},...
        bookV.spos_gen{trial},...
        bookV.xpos_sen{trial},...
        bookV.spos_sen{trial},...
        bookV.Gen_YRT_value(trial),bookV.din,bookV.duk,bookV.measured_Yp(trial)] = ...
        ...
        cm_observer_generator(vL.input_to_model(bookV.armselected,:),...
        vL.snr,bookV.Bk,...
        vL.RDU.Param_RDU,...
        bookV.xpos_gen{trial-1},...
        bookV.spos_gen{trial-1},...
        vL.SensorModel,...
        bookV.xpos_sen{trial-1},...
        bookV.spos_sen{trial-1},...
        bookV.din,...
        bookV.duk,vL.minmax,vL.maxmax,trial);
    %     if(trial > vL.divisor)
    %         disV.mean_arms(bookV.armselected,1) = sum(bookV.measured(find(...
    %             bookV.playArmSelected(1,:)==bookV.armselected)))/bookV.playArmSelected_count(bookV.armselected,1);
    %     end
    if  mod(trial,vL.divisor)==0
        if (vL.divisor <11)
            bookV.mn_pt_selection(trial/vL.divisor,:) = [bookV.measured(bookV.CurrentBlockStart+ ...
                floor(vL.divisor*0.75):trial),bookV.armselected];
        else
            bookV.mn_pt_selection(trial/vL.divisor,:) = [bookV.measured(bookV.CurrentBlockStart+ ...
                floor(6):trial),bookV.armselected];
        end
%         %disp(trial);
%         [~,cl] = size(bookV.mn_pt_selection);
%         k = sortrows(bookV.mn_pt_selection(:,:),cl);
%         df = [mean(k(:,1:end-1),2),k(:,end)];
%         for i = 1:vL.NArms
%             % taking into account the stablization of alogithm
%             %
%             amdat = df(find(df(:,2)==i));
%             [q1,~] = size(amdat);
%             if(q1 > 1) && (i == 1)
%                 % k2 = mean(amdat(2:end,:),1);
%                 % keeping ensemble uniform
%                 k2 = mean(amdat,1);
%             else
%                 k2 = mean(amdat,1);
%             end
%             if(~isnan(k2))
%                 bookV.mean_arms(1,i) =k2;
%             end
%             % Problem idnetified here incorrect standard deviation
%             % calculated
%             ind=find(bookV.playArmSelected(:)==i);
%             stddt = std(bookV.measured(ind(ind>3)));
%             %stddt = std(bookV.mn_pt_selection(bookV.mn_pt_selection(:,end)==i,1));
%             if stddt ~=0 && ~isnan(stddt)
%                 disV.std_arms(i) = stddt;
%             end
%         end
 [~,cl] = size(bookV.mn_pt_selection);
        k = sortrows(bookV.mn_pt_selection(:,:),cl);
        df = [mean(k(:,1:end-1),2),k(:,end)];
        for i = 1:vL.NArms
            k2 = mean(df(find(df(:,2)==i),1));
            if(~isnan(k2))
            bookV.mean_arms(1,i) =k2;
            end
            stddt = std(bookV.mn_pt_selection(bookV.mn_pt_selection(:,end)==i,1));
            if stddt ~=0 && ~isnan(stddt)
                disV.std_arms(i) = stddt;
            end
        end
    end
end
end