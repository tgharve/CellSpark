clear
%clc
%close all


%External concentrations
global Ko Cao Nao Vc Vsr Bufc Kbufc Bufsr Kbufsr taufca taug Vmaxup Kup R F T RTONF CAPACITANCE ...
    Gkr pKNa Gto GKs GK1 GNa GbNa KmK KmNa knak GCaL GbCa knaca KmNai KmCa ksat n GpCa KpCa GpK ...
    i_low i_high j_low j_high stimduration stimstrength period currents kT Tc type protocol

type = 'EPI'; %EPI, ENDO, or MCELL
protocol = 'DYNREST'; %DYNREST or S1S2REST

Ko=5.4;
Cao=2.0;
Nao=140.0;

%Intracellular volumes
Vc=0.016404;
Vsr=0.001094;

%Calcium dynamics
Bufc=0.15;
Kbufc=0.001;
Bufsr=10.;
Kbufsr=0.3;
taufca=kT*2.;
taug=kT*2.;
Vmaxup=0.000425;
Kup=0.00025;

%Constants
R=8314.472;
F=96485.3415;
Tc = 37;
T=Tc+273.0;
kT = 3^((T-310)/10);
RTONF=(R*T)/F;

%Cellular capacitance
CAPACITANCE=0.185;

%Parameters for currents
%Parameters for IKr
Gkr=0.096;
%Parameters for Iks
pKNa=0.03;

%cell type dependent parameters for Iks and Ito
switch type
    case 'EPI'
        Gto = 0.294;
        GKs = 0.245;
    case 'MCELL'
        Gto = 0.294;
        GKs = 0.062;
    case 'ENDO'
        Gto = 0.073;
        GKs = 0.245;
end

%Parameters for Ik1
GK1=5.405;

%Parameters for INa
GNa=14.838;
%Parameters for IbNa
GbNa=0.00029;
%Parameters for INaK
KmK=1.0;
KmNa=40.0;
knak=1.362;
%Parameters for ICaL
GCaL=0.000175;
%Parameters for IbCa
GbCa=0.000592;
%Parameters for INaCa
knaca=1000;
KmNai=87.5;
KmCa=1.38;
ksat=0.1;
n=0.35;
%Parameters for IpCa
GpCa=0.825;
KpCa=0.0005;
%Parameters for IpK;
GpK=0.0146;

%timestep (ms)
HT =0.02;

%Initial values of state variables

Cai_init=0.0002;
CaSR_init=0.2;
Nai_init=11.6;
Ki_init=138.3;
V_init=RTONF*(log((Ko/Ki_init)));


%duration of the simulation
STOPTIME=600;

switch protocol
    case 'DYNREST'
        i_low=0;
        i_high=1;
        j_low=0;
        j_high=1;
        stimduration=1.0;
        stimstrength=-52;
        period=1000;
        sum=period*1000.;
        tbegin=50;
        tend=tbegin+stimduration;
    case 'S1S2REST'
        i_low=0;
        i_high=1;
        j_low=0;
        j_high=1;
        stimduration=1.;
        stimstrength=-52;
        tbegin=50;
        tend=tbegin+stimduration;
        counter=1;
        dia=5000;
        basicperiod=1000.;
        basicapd=274;
        repeats=10;
end


time = 0;
step = 0;
Istim = 0;
Var = Variables(V_init, Cai_init, CaSR_init,Nai_init,Ki_init);
State = [0,Var.Volt,Var.Volt2,Var.Cai,Var.CaSR,Var.Nai,Var.Ki,Var.M,Var.H,Var.J,Var.Xr1,Var.Xr2,Var.Xs,Var.S,Var.R,Var.D,Var.F,Var.FCa,Var.G,Var.Itot];
currents = [0 0 0 0 0 0 0 0 0 0 0 0];

plot(0,0)
xlim([0,STOPTIME])
grid minor
hold on

while time<=STOPTIME
    time = time+HT;
    switch protocol
        case 'DYNREST'
            if(time>sum)
                if (period>4000)
                    period=period-1000;
                    sum=sum+period*30;
                elseif  (period>3000)
                    period=period-1000;
                    sum=sum+period*30;
                elseif (period>2000)
                    period=period-1000;
                    sum=sum+period*30;
                elseif (period>1000)
                    period=period-1000;
                    sum=sum+period*100;
                elseif (period>500)
                    period=period-250;
                    sum=sum+period*100;
                elseif(period>400)
                    period=period-50;
                    sum=sum+period*100;
                elseif(period>300)
                    period=period-10;
                    sum=sum+period*100;
                elseif(period>250)
                    period=period-5;
                    sum=sum+period*100;
                elseif(period>50)
                    period=period-1;
                    sum=sum+period*100;
                else
                    %disp('Restitution protocol complete')
                end
            end
            if(time>=tbegin && time<=tend)
                
                Istim=stimstrength;
            end
            
            if(time>tend)
                
                Istim=0.;
                tbegin=tbegin+period;
                tend=tbegin+stimduration;
            end
            
            
        case 'S1S2REST'
            if(counter<repeats)
                if(time>=tbegin && time<=tend)
                    Istim=stimstrength;
                end
                if(time>tend)
                    Istim=0.;
                    tbegin=tbegin+basicperiod;
                    tend=tbegin+stimduration;
                    counter=counter+1;
                    
                elseif(counter==repeats)
                    if(time>=tbegin && time<=tend)
                        Istim=stimstrength;
                    end
                    if(time>tend)
                        Istim=0.;
                        tbegin=tbegin+basicapd+dia;
                        tbeginS2=tbegin;
                        tend=tbegin+stimduration;
                        counter=counter+1;
                    elseif(counter==repeats+1)
                        if(time>=tbegin && time<=tend)
                            Istim=stimstrength;
                        end
                        if(time>tend)
                            Istim=0.;
                            tbegin=tbegin+basicperiod;
                            tend=tbegin+stimduration;
                            counter=0;
                        end
                        if(dia>1000)
                            dia=dia-1000;
                        elseif(dia>300)
                            dia=dia-100;
                        elseif(dia>150)
                            dia=dia-5;
                        elseif(dia>5)
                            dia=dia-1;
                        else
                          %  disp('Restitution protocol complete')
                        end
                    end
                end
            end
    end
    Var = Step(Var,HT,time,step,Istim);
    if(mod(step,10)==0)
        State = [State; time, Var.Volt,Var.Volt2,Var.Cai,Var.CaSR,Var.Nai,Var.Ki,Var.M,Var.H,Var.J,Var.Xr1,Var.Xr2,Var.Xs,Var.S,Var.R,Var.D,Var.F,Var.FCa,Var.G,Var.Itot];
        if(mod(step,250)==0)
            plot(State(:,1),State(:,2),'b');
            drawnow
        end
    end
    step = step+1;
end
hold off
plot(State(:,1),State(:,2),'b')
xlim([0,STOPTIME])
grid minor




