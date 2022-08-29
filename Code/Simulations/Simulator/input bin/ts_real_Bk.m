function [Bk] = ts_real_Bk(vL)
% Bk
model = vL.model;
%Vk = vL.RDU.Param_RDU.Vk/100;
BK1 = 0.15*ones(1,model);
%temp = randperm(length(BK1)-1,ceil(0.1*length(BK1)));
switch vL.test
    case 1 % dispersed values
        if model == 2
            BK1(1) =  -0.04; BK1(model) = -0.01;
            %BK1(1) =  -0.05; BK1(model) = 0.05;
            %BK1(1) =  0.25; BK1(model) = -0.25;
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
        if model == 4
            BK1=[0,-0.005,-0.01,-0.04];
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
        if model == 6
            BK1=[0,-0.005,-0.01,-0.020,-0.040,-0.07];
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
        if model == 8
            BK1=[0,-0.005,-0.01,-0.020,-0.030,-0.04,-0.07,-0.031];
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
    case 2 % local minima clutter
        if model == 2
            %BK1(1) = -0.075; BK1(model) = -0.02;
            BK1(1) =  -0.1; BK1(model) = 0;
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
        if model == 4
            BK1=[0,-0.005,-0.01,-0.04];
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
        if model == 6
            BK1=[0,-0.005,-0.01,-0.020,-0.040,-0.07];
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
        if model == 8
            BK1=[0,-0.005,-0.01,-0.020,-0.030,-0.040,-0.035,-0.07];
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
    case 3
    	if model == 2
          	BK1(1) =  0; BK1(model) = -0.05;
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
    case 4
        if model == 2
           	BK1(1) =  0; BK1(model) = -0.03;
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
    case 5
        if model == 2
           	BK1(1) =  0; BK1(model) = -0.02;
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
    case 6
        if model == 2
             BK1(1) =  0; BK1(model) = -0.01;
            Bk = [BK1*1;BK1*0.1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
    case 7
      	if model == 2
            BK1(1) = 0; BK1(model) = 0;
            Bk = [BK1;BK1];
            Bk =  Bk(:,randperm(length(Bk)));
        end
end
end

