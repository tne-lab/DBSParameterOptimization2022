data1 = dat1.dist_noalgorithm1000.data;
for g = [1000]
cnt = 1;MM = 20;
for k = 2
for i = 1:1000
    bookV = data1.test1.(strcat('divisor',num2str(g))).(strcat('model',num2str(k))).expV.episodeV{1, 1}.bookV{i, 1};
    rmsval(i,cnt) = (sqrt(nanmean((bookV.Gen_YRT_value(MM:end)-bookV.measured_Yp(MM:end)).^2)))./(max(bookV.measured(MM:end))-min(bookV.measured(MM:end)));
    bgen = bookV.xbaseline_gen(MM:end)-nanmean(bookV.xbaseline_gen(MM:end));
    bsen = bookV.xbaseline_sen(MM:end)-nanmean(bookV.xbaseline_sen(MM:end));
   	xgen = bookV.xconflict_gen(MM:end)-nanmean(bookV.xconflict_gen(MM:end));
    xsen = bookV.xconflict_sen(MM:end)-nanmean(bookV.xconflict_sen(MM:end));
    rmsval_base(i,cnt) = (sqrt(nanmean((bgen-bsen).^2)))./(max(bsen)-min(bsen));
    rmsval_conflict(i,cnt) = (sqrt(nanmean((xgen-xsen).^2)))./(max(xsen)-min(xsen));
end
cnt = cnt +1;
end
end



[nanmean(rmsval(:));nanmean(rmsval_base(:));nanmean(rmsval_conflict(:))]'
[median(rmsval(:));median(rmsval_base(:));median(rmsval_conflict(:))]'