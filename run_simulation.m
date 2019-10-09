function [hObject_new, handles_new] = run_simulation(Args,hObject,handles)

%clc
%close all


%External concentrations
global Ko Cao Nao Vc Vsr Bufc Kbufc Bufsr Kbufsr taufca taug Vmaxup Kup R F T RTONF CAPACITANCE ...
    Gkr pKNa Gto GKs GK1 GNa GbNa KmK KmNa knak GCaL GbCa knaca KmNai KmCa ksat n GpCa KpCa GpK ...
    i_low i_high j_low j_high stimduration stimstrength period currents kT Tc type protocol State GK GL VL



handles.count = handles.count + 1;
ow = Args.ow;
type = Args.type; %EPI, ENDO, MCELL, or NEURON


%Ko=5.4;
%Cao=2.0;
%Nao=140.0;
if isequal(type,'NEURON')
    Ko = Args.Ko;
    Cao = Args.Cao;
    Nao = Args.Nao;
    
    Vc = Args.Vc;
    
    %Constants
    R=8314.472;
    F=96485.3415;
    %Tc = 37;
    Tc = Args.Tc;
    T=Tc+273.0;
    kT = 3^((Tc-37.0)/10);
    RTONF=(R*T)/F;
    
    %Conductances
    %GNa = 120;
    %GK = 36;
    %GL = 0.3;
    VL = -49;
    
    GNa = Args.GNa;
    GK = Args.GK;
    GL = Args.GL;
    
    CAPACITANCE = Args.Cm;
    
    HT = Args.HT;
    
    %Initial values of state variables
    
    Cai_init=Args.Cai;
    Nai_init=Args.Nai;
    Ki_init=Args.Ki;
    
    %V_init=(5/115)*RTONF*(log((Nao/Nai_init))) + (100/115)* RTONF*(log((Ko/Ki_init))) + (10/115)*VL;
    V_init = -62;
    
    %duration of the simulation
    STOPTIME = Args.STOPTIME;
    
    stimduration=Args.dur;
    stimstrength=-10* Args.amp;
    tbegin=Args.tbegin;
    tend=tbegin+stimduration;
    
    time = 0;
    step = 0;
    Istim = 0;
    Var = VariablesN(V_init, Cai_init,Nai_init,Ki_init);
    State = [0,Var.Volt,Var.Volt2,Var.Cai,Var.Nai,Var.Ki,Var.M,Var.H,Var.N,Var.Itot];
    currents = [0 0 0 0];
    
    leg = get(handles.popupmenu2,'Value');
    
    switch leg
        case 1
            label = [get(handles.edit3,'String'), ' mM'];
        case 2
            label = [get(handles.edit1,'String'), ' mM'];
        case 3
            label = [get(handles.edit2,'String'), ' mM'];
        case 4
            label = [get(handles.edit4,'String') ' ' char(176) 'C'];
        case 5
            label = [get(handles.edit7,'String'), ' mM'];
        case 6
            label = [get(handles.edit5,'String'), ' mM'];
        case 7
            label = [get(handles.edit6,'String'), ' mM'];
        case 8
            label = [get(handles.edit8,'String'), ' \muF/cm^{2}'];
        case 9
            label = [get(handles.edit9,'String'), ' mA'];
        case 10
            label = [get(handles.edit10,'String'), ' ms'];
        case 11
            label = [get(handles.edit11,'String'), ' ms'];
        case 12
            label = [get(handles.edit17,'String'), ' mS/cm^{2}'];
        case 13
            label = [get(handles.edit16,'String'), ' mS/cm^{2}'];
        case 14
            label = [get(handles.edit15,'String'), ' mS/cm^{2}'];
    end
    
    if ow == 1
        genvarname('handles.P',num2str(handles.count));
        eval(['handles.P' num2str(handles.count) '=plot(handles.axes1,0,0);']);
        handles.labels{handles.count,1} = label;
        legend(handles.labels);
    else
        cla(handles.axes1);
        clear handles.labels;
        handles.labels = {};
        handles.P=plot(handles.axes1,0,0);
        handles.count = 1;
        handles.labels{handles.count,1} = label;
        legend(handles.labels);
    end
    
    while time<=STOPTIME
        time = time+HT;
        if(time>=tbegin && time<=tend)
            
            Istim=stimstrength;
        end
        
        if(time>tend)    
            Istim=0.;

        end
        
            Var = StepN(Var,HT,time,step,Istim);
                if(mod(step,10)==0)
                    State = [State; time, Var.Volt,Var.Volt2,Var.Cai,Var.Nai,Var.Ki,Var.M,Var.H,Var.N,Var.Itot];
                    if(mod(step,250)==0)
                        
                        xvals = State(:,1);
                        yvar = get(handles.popupmenu3,'Value');
                        switch yvar
                            case 1
                                yvals = State(:,2); %Voltage
                            case 2
                                yvals = currents(:,2); %INa
                            case 3
                                yvals = currents(:,3); %IK
                            case 4
                                yvals = currents(:,4); %IL
                            case 5
                                yvals = State(:,7); %M
                            case 6
                                yvals = State(:,8); %H
                            case 7
                                yvals = State(:,9); %N
                        end
                        
                        if(ow == 0)
                            set(handles.P,'xdata',xvals,'ydata',yvals);
                            
                        else
                            eval(['set(handles.P' num2str(handles.count) ',''xdata'',xvals,''ydata'',yvals);']);
                        end
                        ylim(handles.axes1,'auto');
                        drawnow('update');
                        guidata(hObject,handles);
                    end
                end
                
                step = step+1;
            end
            %handles.count = handles.count + 1;
            handles.State = State;
            
            %ylim(handles.axes1,'auto');
            
        hObject_new = hObject;
        handles_new = handles;
        
        
        else
            protocol = Args.protocol; %DYNREST or S1S2REST
            
            Ko = Args.Ko;
            Cao = Args.Cao;
            Nao = Args.Nao;
            
            %Intracellular volumes
            
            %Vc=0.016404;
            %Vsr=0.001094;
            
            Vc = Args.Vc;
            Vsr = Args.Vsr;
            
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
            %Tc = 37;
            Tc = Args.Tc;
            T=Tc+273.0;
            kT = 3^((T-310)/10);
            RTONF=(R*T)/F;
            
            %Cellular capacitance
            %CAPACITANCE=0.185;
            CAPACITANCE = Args.Cm;
            
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
            %GNa=14.838;
            GNa = Args.GNa;
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
            %HT =0.02;
            HT = Args.HT;
            
            %Initial values of state variables
            
            CaSR_init=Args.Cai;
            Nai_init=Args.Nai;
            Ki_init=Args.Ki;
            
            
            Cai_init=0.0002;
            %CaSR_init=0.2;
            %Nai_init=11.6;
            %Ki_init=138.3;
            V_init=RTONF*(log((Ko/Ki_init)));
            
            
            
            %duration of the simulation
            %STOPTIME=600;
            STOPTIME = Args.STOPTIME;
            
            switch protocol
                case 'DYNREST'
                    i_low=0;
                    i_high=1;
                    j_low=0;
                    j_high=1;
                    stimduration = Args.dur;
                    %stimduration=1.0;
                    stimstrength = -1 * Args.amp;
                    %stimstrength=-52;
                    %period=1000;
                    period = Args.bcl;
                    sum=period*1000.;
                    tbegin = Args.tbegin;
                    %tbegin=50;
                    tend=tbegin+stimduration;
                case 'S1S2REST'
                    i_low=0;
                    i_high=1;
                    j_low=0;
                    j_high=1;
                    stimduration=Args.dur;
                    stimstrength=-1* Args.amp;
                    tbegin=Args.tbegin;
                    tend=tbegin+stimduration;
                    counter=1;
                    dia=5000;
                    %basicperiod=1000.;
                    basicperiod = Args.bcl;
                    basicapd=274;
                    repeats=10;
            end
            
            
            time = 0;
            step = 0;
            Istim = 0;
            Var = Variables(V_init, Cai_init, CaSR_init,Nai_init,Ki_init);
            State = [0,Var.Volt,Var.Volt2,Var.Cai,Var.CaSR,Var.Nai,Var.Ki,Var.M,Var.H,Var.J,Var.Xr1,Var.Xr2,Var.Xs,Var.S,Var.R,Var.D,Var.F,Var.FCa,Var.G,Var.Itot];
            currents = [0 0 0 0 0 0 0 0 0 0 0 0];
            
            leg = get(handles.popupmenu2,'Value');
            
            switch leg
                case 1
                    label = [get(handles.edit3,'String'), ' mM'];
                case 2
                    label = [get(handles.edit1,'String'), ' mM'];
                case 3
                    label = [get(handles.edit2,'String'), ' mM'];
                case 4
                    label = [get(handles.edit4,'String') ' ' char(176) 'C'];
                case 5
                    label = [get(handles.edit7,'String'), ' mM'];
                case 6
                    label = [get(handles.edit5,'String'), ' mM'];
                case 7
                    label = [get(handles.edit6,'String'), ' mM'];
                case 8
                    label = [get(handles.edit8,'String'), ' \muF/cm^{2}'];
                case 9
                    label = [get(handles.edit13,'String'), ' \mum^{3}'];
                case 10
                    label = [get(handles.edit14,'String'), 'mum^{3}'];
                case 11
                    label = [get(handles.edit9,'String'), ' mA'];
                case 12
                    label = [get(handles.edit10,'String'), ' ms'];
                case 13
                    label = [get(handles.edit11,'String'), ' ms'];
                case 14
                    label = Args.type;
            end
            
            if ow == 1
                genvarname('handles.P',num2str(handles.count));
                eval(['handles.P' num2str(handles.count) '=plot(handles.axes1,0,0);']);
                handles.labels{handles.count,1} = label;
                legend(handles.labels);
            else
                cla(handles.axes1);
                clear handles.labels;
                handles.labels = {};
                handles.P=plot(handles.axes1,0,0);
                handles.count = 1;
                handles.labels{handles.count,1} = label;
                legend(handles.labels);
            end
            
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
                        
                        xvals = State(:,1);
                        yvar = get(handles.popupmenu3,'Value');
                        switch yvar
                            case 1
                                yvals = State(:,2); %Voltage
                            case 2
                                yvals = State(:,4); %Cai
                            case 3
                                yvals = currents(:,6); %INa
                            case 4
                                yvals = currents(:,9); %ICaL
                            case 5
                                yvals = currents(:,5); %Ito
                            case 6
                                yvals = currents(:,3); %IKs
                            case 7
                                yvals = currents(:,2); %IKr
                            case 8
                                yvals = currents(:,4); %IK1
                            case 9
                                yvals = currents(:,11); %INaCa
                            case 10
                                yvals = currents(:,8); %INaK
                            case 11
                                yvals = currents(:,7); %IbNa
                            case 12
                                yvals = currents(:,10); %IbCa
                            case 13
                                yvals = currents(:,12); %Irel
                        end
                        
                        if(ow == 0)
                            set(handles.P,'xdata',xvals,'ydata',yvals);
                            
                        else
                            eval(['set(handles.P' num2str(handles.count) ',''xdata'',xvals,''ydata'',yvals);']);
                        end
                        ylim(handles.axes1,'auto');
                        drawnow('update');
                        guidata(hObject,handles);
                    end
                end
                
                step = step+1;
            end
            %handles.count = handles.count + 1;
            handles.State = State;
            
            %ylim(handles.axes1,'auto');
            
            hObject_new = hObject;
            handles_new = handles;
    end
    
end

