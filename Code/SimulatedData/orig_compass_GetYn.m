function [Yn,YP,EYn,XPos,SPos]=orig_compass_GetYn(Cut_Time,Uk,In,Param,XPos0,SPos0,minmax,maxmax,mn1,mn2)
[MCk,MDk] = compass_Tk(In,Param);
Ck = Param.Ck;
Dk = Param.Dk.*MDk;
Vk = 8;
S = Param.S;
Ak = Param.Ak;
% Ak(1,1) = Ak(1,1)-0.0001;
% Ak(2,2) = Ak(2,2)-0.0911;
% Ak = Param.Ak-0.0001;
Bk = Param.Bk;
Wk =[0.0067,0;0,0.000112];%Param.Wk;
xM = Param.xM;
XPre = Ak * XPos0 + Bk * Uk';
SPre = Ak * SPos0* Ak' + Wk;
CTk     = (Ck.*MCk{1})*xM;
DTk     = Dk;
EYn  =  exp(CTk * XPre + DTk * In');
%ys = S:0.01:max(S+CTk*[1.25 0.25],EYn+5*EYn*EYn/Vk);
GT = 0.0855*randn(1,1);
if(In(:,2)==0)
    ys = S+0.15+GT:0.01:minmax;
else
    ys =S+0.15+GT:0.01:maxmax;
end
Pa  = gampdf(ys,EYn*Vk,1/Vk);
CPa = cumsum(Pa);
CPa = CPa / sum(Pa);
[~,ui] = min(abs(rand-CPa));
Yn = ys(ui);
Yk      = Yn;
Yp      = exp(CTk * XPre + DTk * In');
% XPre = XPos0;
% SPre = SPos0;
SPos =(SPre^-1 + (Vk*(Yk/Yp))*(CTk')*CTk)^-1;
XPos =XPre- SPos * Vk * CTk'* (1-Yk/Yp);
%% Update prediction
temp    = CTk * XPos + DTk * In';
YP      = exp(temp) * exp(0.5* CTk * SPos * CTk');
SP      = exp(2*temp) * exp(2* CTk * SPos * CTk') - YP*YP;
YP      =YP;
%Yn = EYn;
end