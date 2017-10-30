function [Vs] = StepN(V,HT,tt,step,Istim)
global Ko Cao Nao Vc R F T RTONF CAPACITANCE ...
     type GNa GK GL VL ...
    currents kT

sm = V.M;
sh = V.H;
sn = V.N;
svolt = V.Volt;      
svolt2 = V.Volt2;
Cai = V.Cai;
Nai = V.Nai;
Ki = V.Ki;
sItot = V.Itot;

%Needed to compute currents
Ek=RTONF*(log((Ko/Ki)));
Ena=RTONF*(log((Nao/Nai)));


%Compute currents
INa=GNa*sm*sm*sm*sh*(svolt-Ena);
IK=GK*sn*sn*sn*sn*(svolt-Ek);
IL=GL*(svolt-VL);

%Determine total current
sItot = INa + IK + IL + Istim;

%update concentrations
% dNai=-(INa)*inverseVcF*CAPACITANCE;
% Nai=Nai+HT*dNai;
% 
% dKi=-(Istim + IK)*inverseVcF*CAPACITANCE;
% Ki=Ki+HT*dKi;

if mod(step,10)==0
    currents = [currents; tt, INa, IK, IL];
end
    
%compute steady state values and time constants 
VCa = 0.03335*T*(log(Cao/Cai)-12.995);
AM=-0.1*kT*(35+svolt+VCa)/(exp(-0.1*(35*svolt+VCa))-1);
BM=4*exp(-(svolt+VCa+60)/18)*kT;
TAU_M=1/(AM+BM);
M_INF=AM/(AM+BM);
AH=0.07*kT*exp(-0.05*(svolt+VCa+60));
BH=kT/(1+exp(-0.1*(svolt+VCa+30)));
TAU_H=1/(AH+BH);
H_INF=AH/(AH+BH);
AN=kT*(-0.01*(svolt+VCa+50))/(exp(-0.1*(svolt+VCa+50))-1);
BN=kT*0.125*exp(-0.0125*(svolt+VCa+60));
TAU_N=1/(AN+BN);
N_INF=AN/(AN+BN);

%Update gates
%sm = M_INF-(M_INF-sm)*exp(-HT/TAU_M);
%sh = H_INF-(H_INF-sh)*exp(-HT/TAU_H);
%sn = N_INF-(N_INF-sh)*exp(-HT/TAU_N);

sm = sm + HT*(AM*(1-sm)-BM*sm); 
sh = sh + HT*(AH*(1-sh)-BH*sh);
sn = sn + HT*(AN*(1-sn)-BN*sn);
%update voltage
svolt2 = svolt;
svolt= svolt - (HT/CAPACITANCE)*(sItot);

Vs.M = sm;
Vs.H = sh;
Vs.N = sn;
Vs.Volt = svolt;
Vs.Volt2 = svolt2;
Vs.Cai = Cai;
Vs.Nai = Nai;
Vs.Ki = Ki;
Vs.Itot = sItot;

end