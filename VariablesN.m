function [V] =  VariablesN(V_init, Cai_init, Nai_init, Ki_init)

global Cao T kT

V.Volt=V_init;
V.Volt2=V_init;
V.Cai=Cai_init;
V.Nai=Nai_init;
V.Ki=Ki_init;

VCa = 0.03335*T*(log(Cao/Cai_init)-12.995);

AM=-0.1*kT*(35+V_init+VCa)/(exp(-0.1*(35*V_init+VCa))-1);
BM=4*exp(-(V_init+VCa+60)/18)*kT;
TAU_M=1/(AM+BM);
M_INF=AM/(AM+BM);
AH=0.07*kT*exp(-0.05*(V_init+VCa+60));
BH=kT/(1+exp(-0.1*(V_init+VCa+30)));
TAU_H=1/(AH+BH);
H_INF=AH/(AH+BH);
AN=kT*(-0.01*(V_init+VCa+50))/(exp(-0.1*(V_init+VCa+50))-1);
BN=kT*0.125*exp(-0.0125*(V_init+VCa+60));
TAU_N=1/(AN+BN);
N_INF=AN/(AN+BN);

V.M= M_INF;
V.H= H_INF;
V.N= N_INF;
V.Itot = 0;
end