%%implementarea pompei
k1= 0.624;
k2= -0.015;
k3= -0.0006;
%k= 0.047;
k=0.035
k11= k2*k2+4*(k-k3)*k1
k12= 8*(k-k3)
k13= 2*(k-k3)
%C= 9.05
C=9

%%
%treapta de la 0 la u0=6.7
h0=16.78
q0=37.07
%treapta de la u0 pana la u0+0,5=7.2
h1=19.66
q1=40.12

%identificarea functiei 
delta_h=h1-h0;
delta_ua=7.2-6.7;
kp=(delta_h/3)/delta_ua %se inmulteste cu 1/3 pt ca se ia in considerare modelul traductorului
h63 = h0+ 0.63*delta_h
Tp=214
H_proces = tf(kp, [Tp 1])


%Ca  sa calculam regulatorul am nevoie de Ho
%% calcularea si implementarea unui regulator PI
T0 = Tp/4;  %s-a impus ca timpul de raspuns sa fie Tp= 214
Ho = tf(1, [T0 1])
H_pi = (1/H_proces)*(Ho/(1-Ho));
H_PI = minreal(H_pi)
[kp,ki,kd] = piddata(H_PI)



%sim('bucla_deschisa.slx')
%% feed-forward
kcompensare = (delta_h/(q1-q0))/(delta_h/delta_ua)

%% cascada
%regulator PI din bucla interna
%41.51 il iau de pe graficul lui q cand am doar procesul pentru un timp de
%rulare de 6 secunde
%72.76
kp_in = (41.51-q0)/delta_ua
q63 = q0 + 0.63*(41.51-q0)
%%
Tp_in = 0.8;  %se ia de pe acelasi grafic de unde am luat val. 46.21
H_intern = tf(kp_in, [Tp_in 1]);%functia procesului
T0_in = Tp_in/4;  %se impune tr=4
Ho_in = tf(1, [T0_in 1]);
Hr_in = (1/H_intern)*(Ho_in/(1-Ho_in));
HPI_in = minreal(Hr_in)
[kp1, ki1, kd1] = piddata(HPI_in)

%% regulator PI din bucla externa
kp_ext = ((26.04-h0)/3)/(41.51-q0)
h63_2=h0+0.63*(26.04-h0)
%T_ext = 554;
T_ext = 353;

H_extern = tf(kp_ext, [T_ext 1])
T0_ext = Tp/4;  
Ho_ext = tf(1, [T0_ext 1]);
Hr_ext = (1/H_extern)*(Ho_ext/(1-Ho_ext))
%Hr_ext = (1/H_extern)*(Ho/(1-Ho))
HPI_ext = minreal(Hr_ext)
[kp2, ki2, kd2] = piddata(HPI_ext)