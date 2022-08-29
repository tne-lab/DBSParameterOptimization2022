
% plot

figure(1)
for i=1:Iter
    ml(i)=ML{i}.Total;
end
plot(ml,'LineWidth',2);
ylabel('ML')
xlabel('Iter');

figure(2)
K  = length(Yc);
xm = zeros(K,1);
xb = zeros(K,1);
trialz = zeros(K,1);
trialy = zeros(K,1);
for i=1:K
    temp=XSmt{i};xm(i)=temp(1);trialz(i) = temp(2,1);
    temp=SSmt{i};xb(i)=temp(1,1);trialy(i) = temp(2,2);
end
compass_plot_bound(1,(1:K),xm,(xm-2*sqrt(xb))',(xm+2*sqrt(xb))');
ylabel('forward-backward x_{base}');
xlabel('Trial');
axis tight
grid minor

figure(3)
compass_plot_bound(1,(1:K),trialz,(trialz-2*sqrt(trialy))',(trialz+2*sqrt(trialy))');
ylabel('forward-backward x_{conflict}');
xlabel('Trial');
axis tight
grid minor

figure(4)
K  = length(Yc);
xm = zeros(K,1);
xb = zeros(K,1);
for i=1:K
    temp=rXPos{i};xm(i)=temp(1);trialz(i) = temp(2,1);
    temp=rSPos{i};xb(i)=temp(1,1);trialy(i) = temp(2,2);
end

compass_plot_bound(1,(1:K),xm,(xm-2*sqrt(xb))',(xm+2*sqrt(xb))');
ylabel('forward x_k');
xlabel('Trial');
axis tight
grid minor

figure(5)
compass_plot_bound(1,(1:K),trialz,(trialz-2*sqrt(trialy))',(trialz+2*sqrt(trialy))');
ylabel('forward x_{conflict}');
xlabel('Trial');
axis tight
grid minor