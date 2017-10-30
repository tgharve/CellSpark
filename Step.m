function [Vs] = Step(V,HT,tt,step,Istim)
global Ko Cao Nao Vc Vsr Bufc Kbufc Bufsr Kbufsr taufca taug Vmaxup Kup R F T RTONF CAPACITANCE ...
    Gkr pKNa type Gto GKs GK1 GNa GbNa KmK KmNa knak GCaL GbCa knaca KmNai KmCa ksat n GpCa KpCa GpK ...
    currents kT


inverseVcF2=1/(2*Vc*F);
inverseVcF=1./(Vc*F);
Kupsquare=Kup*Kup;
BufcKbufc=Bufc*Kbufc;
Kbufcsquare=Kbufc*Kbufc;
Kbufc2=2*Kbufc;
BufsrKbufsr=Bufsr*Kbufsr;
Kbufsrsquare=Kbufsr*Kbufsr;
Kbufsr2=2*Kbufsr;
exptaufca=exp(-HT./taufca);
exptaug=exp(-HT./taug);


sm = V.M;
sh = V.H;
sj = V.J;
sxr1 = V.Xr1;
sxr2 = V.Xr2;
sxs = V.Xs;
ss = V.S;
sr = V.R;
sd = V.D;
sf = V.F;
sfca = V.FCa;
sg = V.G;
svolt = V.Volt;
svolt2 = V.Volt2;
Cai = V.Cai;
CaSR = V.CaSR;
Nai = V.Nai;
Ki = V.Ki;
sItot = V.Itot;

%Needed to compute currents
Ek=RTONF*(log((Ko/Ki)));
Ena=RTONF*(log((Nao/Nai)));
Eks=RTONF*(log((Ko+pKNa*Nao)/(Ki+pKNa*Nai)));
Eca=0.5*RTONF*(log((Cao/Cai)));
Ak1=0.1/(1.+exp(0.06*(svolt-Ek-200)));
Bk1=(3.*exp(0.0002*(svolt-Ek+100))+exp(0.1*(svolt-Ek-10)))/(1.+exp(-0.5*(svolt-Ek)));
rec_iK1=Ak1/(Ak1+Bk1);
rec_iNaK=(1./(1.+0.1245*exp(-0.1*svolt*F/(R*T))+0.0353*exp(-svolt*F/(R*T))));
rec_ipK=1./(1.+exp((25-svolt)/5.98));


%Compute currents
INa=GNa*sm*sm*sm*sh*sj*(svolt-Ena);
ICaL=GCaL*sd*sf*sfca*4*svolt*(F*F/(R*T))*(exp(2*svolt*F/(R*T))*Cai-0.341*Cao)/(exp(2*svolt*F/(R*T))-1.);
Ito=Gto*sr*ss*(svolt-Ek);
IKr=Gkr*sqrt(Ko/5.4)*sxr1*sxr2*(svolt-Ek);
IKs=GKs*sxs*sxs*(svolt-Eks);
IK1=GK1*rec_iK1*(svolt-Ek);
INaCa=knaca*(1./(KmNai*KmNai*KmNai+Nao*Nao*Nao))*(1./(KmCa+Cao))*(1./(1+ksat*exp((n-1)*svolt*F/(R*T))))*(exp(n*svolt*F/(R*T))*Nai*Nai*Nai*Cao-exp((n-1)*svolt*F/(R*T))*Nao*Nao*Nao*Cai*2.5);
INaK=knak*(Ko/(Ko+KmK))*(Nai/(Nai+KmNa))*rec_iNaK;
IpCa=GpCa*Cai/(KpCa+Cai);
IpK=GpK*rec_ipK*(svolt-Ek);
IbNa=GbNa*(svolt-Ena);
IbCa=GbCa*(svolt-Eca);

%Determine total current
sItot = IKr+IKs+IK1+Ito+INa+IbNa+ICaL+IbCa+INaK+INaCa+IpCa+IpK+Istim;

%update concentrations
Caisquare=Cai*Cai;
CaSRsquare=CaSR*CaSR;
CaCurrent=-(ICaL+IbCa+IpCa-2*INaCa)*inverseVcF2*CAPACITANCE;
A=0.016464*CaSRsquare/(0.0625+CaSRsquare)+0.008232;
Irel=A*sd*sg;
Ileak=0.00008*(CaSR-Cai);
SERCA=Vmaxup/(1.+(Kupsquare/Caisquare));
CaSRCurrent=SERCA-Irel-Ileak;
CaCSQN=Bufsr*CaSR/(CaSR+Kbufsr);
dCaSR=HT*(Vc/Vsr)*CaSRCurrent;
bjsr=Bufsr-CaCSQN-dCaSR-CaSR+Kbufsr;
cjsr=Kbufsr*(CaCSQN+dCaSR+CaSR);
CaSR=(sqrt(bjsr*bjsr+4*cjsr)-bjsr)/2;
CaBuf=Bufc*Cai/(Cai+Kbufc);
dCai=HT*(CaCurrent-CaSRCurrent);
bc=Bufc-CaBuf-dCai-Cai+Kbufc;
cc=Kbufc*(CaBuf+dCai+Cai);
Cai=(sqrt(bc*bc+4*cc)-bc)/2;

dNai=-(INa+IbNa+3*INaK+3*INaCa)*inverseVcF*CAPACITANCE;
Nai=Nai+HT*dNai;

dKi=-(Istim+IK1+Ito+IKr+IKs-2*INaK+IpK)*inverseVcF*CAPACITANCE;
Ki=Ki+HT*dKi;

if mod(step,10)==0
    currents = [currents; tt, IKr, IKs, IK1, Ito, INa, IbNa, INaK, ICaL, IbCa, INaCa, Irel];
end
    
%compute steady state values and time constants 
AM=1./(1.+exp((-60.-svolt)/5.));
BM=0.1/(1.+exp((svolt+35.)/5.))+0.10/(1.+exp((svolt-50.)/200.));
TAU_M=(1/kT)*AM*BM;
M_INF=1./((1.+exp((-56.86-svolt)/9.03))*(1.+exp((-56.86-svolt)/9.03)));
if (svolt>=-40.)
    
    AH_1=0.;
    BH_1=(0.77/(0.13*(1.+exp(-(svolt+10.66)/11.1))));
    TAU_H= kT/((AH_1+BH_1));
    
else
    
    AH_2=(0.057*exp(-(svolt+80.)/6.8));
    BH_2=(2.7*exp(0.079*svolt)+(3.1e5)*exp(0.3485*svolt));
    TAU_H=kT/((AH_2+BH_2));
end

H_INF=1./((1.+exp((svolt+71.55)/7.43))*(1.+exp((svolt+71.55)/7.43)));

if(svolt>=-40.)
    
AJ_1=0.;
BJ_1=(0.6*exp((0.057)*svolt)/(1.+exp(-0.1*(svolt+32.))));
TAU_J= kT/((AJ_1+BJ_1));

else
    
    AJ_2=(((-2.5428e4)*exp(0.2444*svolt)-(6.948e-6)*exp(-0.04391*svolt))*(svolt+37.78))/(1.+exp(0.311*(svolt+79.23)));
    BJ_2=(0.02424*exp(-0.01052*svolt)/(1.+exp(-0.1378*(svolt+40.14))));
    TAU_J= kT/((AJ_2+BJ_2));
end

J_INF=H_INF;

Xr1_INF=1./(1.+exp((-26.-svolt)/7.));
axr1=450./(1.+exp((-45.-svolt)/10.));
bxr1=6./(1.+exp((svolt-(-30.))/11.5));
TAU_Xr1=(1/kT)*axr1*bxr1;
Xr2_INF=1./(1.+exp((svolt-(-88.))/24.));
axr2=3./(1.+exp((-60.-svolt)/20.));
bxr2=1.12/(1.+exp((svolt-60.)/20.));
TAU_Xr2=(1/kT)*axr2*bxr2;

Xs_INF=1./(1.+exp((-5.-svolt)/14.));
Axs=1100./(sqrt(1.+exp((-10.-svolt)/6)));
Bxs=1./(1.+exp((svolt-60.)/20.));
TAU_Xs=(1/kT)*Axs*Bxs;
    
switch type
    case 'EPI'
    R_INF=1./(1.+exp((20-svolt)/6.));
    S_INF=1./(1.+exp((svolt+20)/5.));
    TAU_R=(1/kT)*(9.5*exp(-(svolt+40.)*(svolt+40.)/1800.)+0.8);
    TAU_S=(1/kT)*(85.*exp(-(svolt+45.)*(svolt+45.)/320.)+5./(1.+exp((svolt-20.)/5.))+3.);
    case 'ENDO'
    R_INF=1./(1.+exp((20-svolt)/6.));
    S_INF=1./(1.+exp((svolt+28)/5.));
    TAU_R=(1/kT)*(9.5*exp(-(svolt+40.)*(svolt+40.)/1800.)+0.8);
    TAU_S=(1/kT)*(1000.*exp(-(svolt+67)*(svolt+67)/1000.)+8.);
    case 'MCELL'
    R_INF=1./(1.+exp((20-svolt)/6.));
    S_INF=1./(1.+exp((svolt+20)/5.));
    TAU_R=(1/kT)*(9.5*exp(-(svolt+40.)*(svolt+40.)/1800.)+0.8);
    TAU_S=(1/kT)*(85.*exp(-(svolt+45.)*(svolt+45.)/320.)+5./(1.+exp((svolt-20.)/5.))+3.);
end

D_INF=1./(1.+exp((-5-svolt)/7.5));
Ad=1.4/(1.+exp((-35-svolt)/13))+0.25;
Bd=1.4/(1.+exp((svolt+5)/5));
Cd=1./(1.+exp((50-svolt)/20));
TAU_D=(1/kT)*(Ad*Bd+Cd);
F_INF=1./(1.+exp((svolt+20)/7));
TAU_F=(1/kT)*1125*exp(-(svolt+27)*(svolt+27)/300)+80+165/(1.+exp((25-svolt)/10));


FCa_INF=(1./(1.+power((Cai/0.000325),8))+0.1/(1.+exp((Cai-0.0005)/0.0001))+0.20/(1.+exp((Cai-0.00075)/0.0008))+0.23 )/1.46;
if(Cai<0.00035)
    G_INF=1./(1.+power((Cai/0.00035),6));
else
    G_INF=1./(1.+power((Cai/0.00035),16));
end

%Update gates
sm = M_INF-(M_INF-sm)*exp(-HT/TAU_M);
sh = H_INF-(H_INF-sh)*exp(-HT/TAU_H);
sj = J_INF-(J_INF-sj)*exp(-HT/TAU_J);
sxr1 = Xr1_INF-(Xr1_INF-sxr1)*exp(-HT/TAU_Xr1);
sxr2 = Xr2_INF-(Xr2_INF-sxr2)*exp(-HT/TAU_Xr2);
sxs = Xs_INF-(Xs_INF-sxs)*exp(-HT/TAU_Xs);
ss= S_INF-(S_INF-ss)*exp(-HT/TAU_S);
sr= R_INF-(R_INF-sr)*exp(-HT/TAU_R);
sd = D_INF-(D_INF-sd)*exp(-HT/TAU_D);
sf =F_INF-(F_INF-sf)*exp(-HT/TAU_F);
fcaold=sfca;
sfca =FCa_INF-(FCa_INF-sfca)*exptaufca;
if(sfca>fcaold && (svolt)>-37)
    sfca=fcaold;
end
gold=sg;
sg =G_INF-(G_INF-sg)*exptaug;
if(sg>gold && (svolt)>-37)
    sg=gold;
end
%update voltage
svolt= svolt + HT*(-sItot);

Vs.M = sm;
Vs.H = sh;
Vs.J = sj;
Vs.Xr1 = sxr1;
Vs.Xr2 = sxr2;
Vs.Xs = sxs;
Vs.S = ss;
Vs.R = sr;
Vs.D = sd;
Vs.F = sf;
Vs.FCa = sfca;
Vs.G = sg;
Vs.Volt = svolt;
Vs.Volt2 = svolt2;
Vs.Cai = Cai;
Vs.CaSR = CaSR;
Vs.Nai = Nai;
Vs.Ki = Ki;
Vs.Itot = sItot;

end