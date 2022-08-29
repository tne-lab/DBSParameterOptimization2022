function [minmax,maxmax] = cm_getminmax(subNumber)
subNumber = ["MG95";"MG96";"MG99";"MG102";"MG104";"MG105";];
i = randi([1 length(subNumber)]);
load('ybyc.mat');
compiledData = [subject,blockStim];
cd = [responseTimes,interference];
ind = find(string(compiledData(:,2))==({'None'}));
compiledData = compiledData(ind,:);
Alldat = cd(ind,:);
indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(i))}));
Yc = Alldat(indfin,:);
Y = sortrows(Yc,2);
minmax = max(Yc(Yc(:,2)==0,1));
maxmax = max(Yc(Yc(:,2)==1,1));
end

