function [minmax,maxmax] = getminmax(subNumber)
load('ybyc.mat');
subNumber = ["MG99";"MG96";"MG99";"MG102";"MG104";"MG105";];
op = randi([1 6],1,1);
compiledData = [subject,blockStim];
cd = [responseTimes,interference];
ind = find(string(compiledData(:,2))==({'None'}));
compiledData = compiledData(ind,:);
Alldat = cd(ind,:);
indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(op))}));
Yc = Alldat(indfin,:);
Y = sortrows(Yc,2);
minmax = max(Yc(Yc(:,2)==0,1));
maxmax = max(Yc(Yc(:,2)==1,1));
end

