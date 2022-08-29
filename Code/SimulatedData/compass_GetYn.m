function [Yn,YP,EYn,XPos,SPos]=compass_GetYn(Cut_Time,Uk,In,Param,XPos0,SPos0,minmax,maxmax)
[MCk,MDk] = compass_Tk(In,Param);
Ck = Param.Ck;
Dk = Param.Dk.*MDk;
Vk = Param.Vk;
S = Param.S;
Ak = Param.Ak;
Bk = Param.Bk;
Wk = Param.Wk;
xM = Param.xM;
XPre = Ak * XPos0 + Bk * Uk';
SPre = Ak * SPos0* Ak' + Wk;
CTk     = (Ck.*MCk{1})*xM;
DTk     = Dk;
% mean from the current positions
EYn  =  exp(CTk * XPre + DTk * In');
% This causes large values
% Mean can vary ys = S:0.01:max(S+CTk*[1.25 0.25],EYn+5*EYn*EYn/Vk);
% For simulation and data matching
GT =  S;
% if GT < 0.3
%     GT = 0.3;% + 0.45*rand(1,1);
% end
% Following is part of data cleaning for S1
% if GT < 0.3997
%     GT = 0.3997;% + 0.45*rand(1,1);
% end
% if(In(:,2)==0)
%     ys = GT:0.001:minmax+0.1*randn(1,1);
% else
%     ys = GT+0.2*rand(1,1):0.001:maxmax+0.1*randn(1,1);
% end
% here we create a range of values that current RT can take
if(In(:,2)==0)
    ys = GT:0.01:minmax;
else
    ys = GT+0.25*rand(1,1):0.01:maxmax; % 0.25 ~250 ms interfernce
end
% we create a gamma distribution with 
% shape parameter using the mean EYn*rate = shape parameter
Pa  = gampdf(ys,EYn*Vk,1/Vk);
CPa = cumsum(Pa);
CPa = CPa / sum(Pa);
[~,ui] = min(abs(rand-CPa));
Yn = ys(ui);
Yk      = Yn;
Yp      = exp(CTk * XPre + DTk * In');
% XPre = XPos0;
% SPre = SPos0;
    warning('') % Clear last warning message
    

    SPos =(SPre^-1 + (Vk*(Yk/Yp))*(CTk')*CTk)^-1;
    [warnMsg, warnId] = lastwarn;
   	if ~isempty(warnMsg)
        disp('404');
    end

XPos =XPre- SPos * Vk * CTk'* (1-Yk/Yp);
%% Update prediction
temp    = CTk * XPos + DTk * In';
YP      = exp(temp) * exp(0.5* CTk * SPos * CTk');
SP      = exp(2*temp) * exp(2* CTk * SPos * CTk') - YP*YP;
YP      =YP;
%Yn = EYn;
end