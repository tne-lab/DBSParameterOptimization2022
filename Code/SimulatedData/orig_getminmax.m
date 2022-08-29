function [minmax,maxmax,mn1,mn2] = getminmax(subNumber)
    load('ybyc.mat');
    compiledData = [subject,blockStim];
    cd = [responseTimes,interference];
    ind = find(string(compiledData(:,2))==({'None'}));
    compiledData = compiledData(ind,:);
    Alldat = cd(ind,:);
    indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber)}));
	Yc = Alldat(indfin,:);
Y = sortrows(Yc,2);
% minmax = max(Yc(Yc(:,2)==0,1));
% maxmax = max(Yc(Yc(:,2)==1,1));
rel = 1;rel1 = 1;
minmax = sortrows(Yc(Yc(:,2)==0,1));
mn1 = mean(minmax(1:rel1));
minmax=mean(minmax(end-rel:end-1));
maxmax = sortrows(Yc(Yc(:,2)==1,1));
mn2 = mean(maxmax(1:rel1));
maxmax=mean(maxmax(end-rel:end-1));
% if (minmax > maxmax)
%     minmax = 2.5*mean(Yc(:,2)==0);
% end
end

