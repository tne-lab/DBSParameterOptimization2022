% create Rawdata
function Create_Sensor_Model()
locGen = "D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\Simulated"
addpath 'C:\Users\Tnel Neuropixels\Desktop\Sep 2020\COMPASS-master\COMPASS_StateSpaceToolbox'
for i = 1:6
    for k = 1:175
        sensor_data_model(k,i,1,"D:\Sumedh\Projects\Methods for psychiatric DBS programming\Data\sensor_HigherWk\",locGen);
    end
end
end