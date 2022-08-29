% create Rawdata
function GenerateWk_Model()
addpath 'C:\Users\Tnel Neuropixels\Desktop\Sep 2020\COMPASS-master\COMPASS_StateSpaceToolbox'
wk = [0.5,0.4,0.3,0.2,0.1,0.05,0.04,0.03,0.02,0.01,0.005];
for i = 4
    for m1 = 11
        for k = 1:25
            ModellingWithWk(k,i,1,strcat("D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Generator models\Generator Wk\","wk",num2str(m1),"\"),wk(m1));
        end
    end
end
end