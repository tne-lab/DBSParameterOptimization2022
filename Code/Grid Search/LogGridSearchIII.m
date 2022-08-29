% 'MG102','MG104','MG105','MG95','MG96','MG99'
% Model Generation
% Generating the model from all patient
% Fetching the average behaviour
tic
addpath 'C:\Users\Tnel Neuropixels\Desktop\Sep 2020\COMPASS-master\COMPASS_StateSpaceToolbox'

clear;
load('ybyc.mat');
for r = 5:6
    num =1;gd = 0;sb = 0;
    subNumber = ["MG102","MG104","MG105","MG95","MG96","MG99"]';
    for ij = 1:6
        gd = 0;
        singleSubject = 2;
        
        compiledData = [subject,blockStim];
        cd = [responseTimes,interference];
        ind = find(string(compiledData(:,2))~=({'N2one'}));
        compiledData = compiledData(ind,:);
        Alldat = cd(ind,:);
        
        if singleSubject == 2
            indfin = find(string(compiledData(:,1))==({convertStringsToChars(subNumber(ij))}));
            Yc = Alldat(indfin,:);
        else
            Yd = responseTimes(ind);
            Yv = interference(ind);
            Yc = [Yd,Yv];
        end
        
        [N,~] = size(Yc);
        Yb = zeros(N,1);%responseCorrect(ind);
        obs_valid = ones(N,1); % since none are MAR or censored
        Iter = 100;
        nIn = 3;
        In = ones(N,nIn);
        In(:,1) = 1;
        In(:,2) = Yc(:,2);
        % The reason here is that we don't know Bk, which is assumed to
        % be zero so Uk won't matter, since Bk * Uk =0
        % Now all the changes are supposed to be learned by
        % Vk and Wk
        %[inp,sites] = S6_arrangingInput(blockStim,StimAny,ind);
        inp = zeros(2,3);%inp(:,:);
        inp(:,:)= 0;
        [~,nU] = size(inp);
        %nU = 0;
        for grid = [1:40]%[1,2,3,3.2,3.4,3.6,3.8,4,4.2,4.4,4.6,4.8,5,5.2,5.4,5.6,5.8]
            gd = gd+1;sb = 0;sub =0;
            while(sub<40)
                %for sub = 1:25%[1,2,3,3.2,3.4,3.6,3.8,4,4.2,4.4,4.6,4.8,5,5.2,5.4,5.6,5.8]
                sub = sub+1;
                sb = sb+1;
                %for grid = 9.9:0.01:10.9
                %clearvars -except DEV_C xex num sub grid
                
                
                
                %Param = compass_create_state_space(nX,nU,nIn,nIb,xM,clink,clinkupdate,dlink,dlinkupdate);
                Param = compass_create_state_space(2,nU,nIn,[],eye(2,2),[1 2],[0 0],[],[]);
                %Param = compass_set_learning_param(Param,Iter,UpdateStateParam,UpdateStateNoise,UpdateStateX0 ...
                %    ,UpdateCModelParam,UpdateCModelNoise,UpdateDModelParam,DiagonalA,UpdateMode,UpdateCModelShift);
                % A = 0 so that things A & B is not updated, third parameter
                Param.Ak = [0.9999,0;0,0.9999];
                % UpdateStateNoise 4
                % 1 == for no change in the intial condition
                if r > 1
                    sx = 1;
                    Param.X0 = [sx*randn();sx*randn()];
                end
                %Param.Wk = [(1/grid),0;0,(1/sub)];
                Param.Wk = [1./(sqrt(2)^(grid)),0;0,1./(sqrt(2)^(sub))];
                %Param.S = min(Yc(:,1));
                Param = compass_set_learning_param(Param,Iter,0,0,1,1,1,0,1,2,1);
                %[XSmt,SSmt,Param,rXPos,rSPos,ML,EYn,EYb,rYn,rYb]= compass_em([1 0],zeros(N,1),In,[],Yc,[],Param,obs_valid);
                try
                    [XSmt,SSmt,Param,rXPos,rSPos,ML,EYn,EYb,rYn,rYb]= compass_em([2 0],[],In,[],Yc(:,1),[],Param,obs_valid);
                    [DEV_C{gd,sb},~]= compass_deviance([2 0],In,[],rYn,rYb,Param,obs_valid,XSmt,SSmt);
                    S{gd,sb} = Param.S;
                    Vk{gd,sb} = Param.Vk;
%                     S0_Modelplots;
                    if isempty(DEV_C{gd,sb}) == 1 || sub == 25
                        disp(sub);
                    end
                    
                    
                    if abs(ML{Iter}.Total-ML{Iter-1}.Total)/ML{Iter-1}.Total > 0.001
                        Iter = Iter+ 100;
                        sub= sub-1;
                        sb =sb-1;
                    else
                        Iter = 100;
                    end
                catch
                    DEV_C{gd,sb}  = 100;
                end
                %xex{sub} = sub;
                %num = num +1;
                
                %S0_Modelplots;
                % RDU.Param_RDU = Param;
                % RDU.Xbase_RDU = xm;
                % RDU.Xconflict_RDU = trialz;
                % RDU.rSPos_RDU = rSPos;
                % RDU.rXPos_RDU = rXPos;
            end
            %Dev{grid} = DEV_C;
        end
        save(strcat('C:\Users\Tnel Neuropixels\Desktop\First paper Sumedh\figure 3\newsim\',num2str(r),subNumber(ij),'Log_DEV_C.mat'),'DEV_C');
        clearvars DEV_C
        disp(ij);
    end
end
t = toc
