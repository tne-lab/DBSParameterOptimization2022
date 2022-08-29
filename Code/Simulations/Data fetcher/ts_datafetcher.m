%function [data1,mnConv,probofCorrectSelection,probofCorrectSelection_al] = ts_datafetcher(expV,vL,correct,model,data1)
function [data1] = ts_datafetcher(expV,vL,correct,model,data1)
% combineData = [expV.Experiments_MeanReward];
% combineCumData = [expV.Experiments_CumReward];
% combineBarData = [expV.Experiments_MeanSelectionCount]';
% convergence = [expV.convergence];
% playselection = [expV.Experiments_selections];
% ps = [expV.probSelected];
% ps1 = [expV.probSelected_al];
% r = vL.NArms;
% for k1 = 1:1
%     B = unique(ps(k1,:));
%     Ncount(k1,:) = histc(ps(k1,:), [1:r]);
% end
% for k2 = 1:1
%     B2 = unique(ps1(k2,:));
%     Ncount2(k2,:) = histc(ps1(k2,:), [1:r]);
% end
% mnConv =mean(convergence,2);
% probofCorrectSelection = Ncount(:,correct)/vL.NumberOfTimesExpRepeated;
% probofCorrectSelection_al = Ncount2(:,correct)/vL.NumberOfTimesExpRepeated;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).convergence = convergence;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).correct = correct;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).PS = ps;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).PS_al = ps1;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).combineData = combineData;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).combineCumData = combineCumData;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).combineBarData = combineBarData;
% data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).playselection = playselection;
data1.(strcat('test',num2str(vL.test))).(strcat('divisor',num2str(vL.divisor))).(strcat('model',num2str(model))).expV = expV;
end

