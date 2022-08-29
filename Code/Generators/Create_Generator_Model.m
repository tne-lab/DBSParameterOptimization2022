% create Rawdata
function Create_Generator_Model()
addpath 'C:\Users\Tnel Neuropixels\Desktop\Sep 2020\COMPASS-master\COMPASS_StateSpaceToolbox'
loc = "D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Generator models\Generator\"
for i = 1:6
    for k = 1:175
        actual_data_model(k,i,1,loc);
    end
end
end