function ts_steady_state(vL,bookV)
% data = [xbaseline_gen; xbaseline_sen;xconflict_gen; xconflict_sen];
% plotfor = ["gen xbaseline","sen xbaseline","gen conflict","sen conflict"];
data = [bookV.Gen_YRT_value;bookV.measured];
plotfor = ["gen RT","sen RT"];

[r,~] = size(data);
blocks = vL.divisor;
totalTrials = vL.NumberOfTimesExpRepeated;
siteNum = vL.NArms;
p =1;
figure;
for j = 1:size(data)
    
    con = 1;
    site2 = [];
    site1 = [];
    for i = 1:blocks:totalTrials
        if(mod(con,siteNum)==0)
            site2 = [site2;data(j,i:i+blocks-1)];
        else
            site1 = [site1;data(j,i:i+blocks-1)];
        end
        con =con+1;
    end
    figure(1)
    %subplot(r,2,p)
    p = p+1;
    title(strcat(plotfor(j)));
    boundedline(1:1:blocks,mean(site1(:,:)),std(site1(:,:)));
    xlabel('Trials');
    ylabel("Non-optimal");
     %ylabel(strcat(plotfor(j)," Non-optimal"));
    %subplot(r,2,p)
    title(strcat(plotfor(j)));
    figure(2)
    p = p+1;
    boundedline(1:1:blocks,mean(site2(:,:)),std(site2(:,:)),'-k')
    xlabel('Trials');
    %ylabel(strcat(plotfor(j)," optimal"));
    ylabel("optimal");
end
sgtitle ("MG104:-Transient and Steady state, blocks are of 20 trials, repeated 50 times");

end