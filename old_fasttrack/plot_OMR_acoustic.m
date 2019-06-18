%% ----- Plot OMR acoustic analyses -----

clear
close all;
clc;

F = Focus();

F.dpf = 5;
F.OMR = '0000';
F.V = '1_5';

p = F.path;
l = dir(p(1:end-1));
a = size(l,1);

% data to analyse
RT_ms = [];
ang_b = [];
ang_esc = [];
n_fish = [];
n_fish_esc = [];



Data = F.load('data_OMR');

RT_ms = [RT_ms Data.reaction_time_ms];
ang_b = [ang_b Data.angle_before];
ang_esc = [ang_esc Data.angle_escape];
n_fish = [n_fish Data.nb_fish_considered];
n_fish_esc = [n_fish_esc Data.nb_fish_escape];


% remove nan value
ang_b(isnan(RT_ms)==1) = [];
ang_b = mod(ang_b,2*pi);
ang_b(ang_b>pi) = ang_b(ang_b>pi)-2*pi;

ang_esc(isnan(RT_ms)==1) = [];

RT_ms(isnan(RT_ms)==1) = [];
RT_ms(RT_ms < 0) = 0;

% ----- All responses -----
Ll = []; % Left side, turn left
Lr = []; % Left side, turn right
Rl = []; % Right side, turn left
Rr = []; % Right side, turn right
ind_left = [];
ind_right = [];

for i = 1:size(ang_b,2)
    if ang_b(i) >= 0 %left side to OMR
        ind_left = [ind_left i];
        if ang_esc(i) < 0 %turn  right
            Lr = [Lr i];
        elseif ang_esc(i) > 0 % turn left
            Ll = [Ll i];
        end
    elseif ang_b(i) < pi %right side to OMR
        ind_right = [ind_right i];
        if ang_esc(i) < 0 %turn right
            Rr = [Rr i];
        elseif ang_esc(i) > 0 %turn left
            Rl = [Rl i];
        end
    end
end

nbL = size(ind_left,2);
nbR  = size(ind_right,2);
mL = (size(Ll,2) - size(Lr,2))/nbL;
mR = (size(Rr,2) - size(Rl,2))/nbR;

% ----- SLC responses -----
ind_SLC = find(RT_ms < 20);
ang_b_S = ang_b(ind_SLC);
ang_esc_S = ang_esc(ind_SLC);

Ll_S = []; % Left side, turn left
Lr_S = []; % Left side, turn right
Rl_S = []; % Right side, turn left
Rr_S = []; % Right side, turn right

for i = 1:size(ang_b_S,2)
    if ang_b_S(i) >= 0 %left side to OMR
        if ang_esc_S(i) < 0 %turn  right
            Lr_S = [Lr_S i];
        else % turn left
            Ll_S = [Ll_S i];
        end
    elseif ang_b_S(i) < 0 %right side to OMR
        if ang_esc_S(i) < 0 %turn right
            Rr_S = [Rr_S i];
        else %turn left
            Rl_S = [Rl_S i];
        end
    end
end
nbL_S = size(Lr_S,2) + size(Ll_S,2);
nbR_S = size(Rr_S,2) + size(Rl_S,2);
mL_S = (size(Ll_S,2) - size(Lr_S,2))/nbL_S;
mR_S = (size(Rr_S,2) - size(Rl_S,2))/nbR_S;

% ----- LLC responses -----
ind_LLC = find(RT_ms > 20);
ang_b_L = ang_b(ind_LLC);
ang_esc_L = ang_esc(ind_LLC);

Ll_L = []; % Left side, turn left
Lr_L = []; % Left side, turn right
Rl_L = []; % Right side, turn left
Rr_L = []; % Right side, turn right

for i = 1:size(ang_b_L,2)
    if ang_b_L(i) >= 0 %left side to OMR
        if ang_esc_L(i) < 0 %turn  right
            Lr_L = [Lr_L i];
        else % turn left
            Ll_L = [Ll_L i];
        end
    elseif ang_b_L(i) < 0 %right side to OMR
        if ang_esc_L(i) < 0 %turn right
            Rr_L = [Rr_L i];
        else %turn left
            Rl_L = [Rl_L i];
        end
    end
end
nbL_L = size(Lr_L,2) + size(Ll_L,2);
nbR_L = size(Rr_L,2) + size(Rl_L,2);
mL_L = (size(Ll_L,2) - size(Lr_L,2))/nbL_L;
mR_L = (size(Rr_L,2) - size(Rl_L,2))/nbR_L;

%% ----- Plot -----
close all

%  -- Plot reaction time histogram between 0 and 100 ms
edges = 0:1000/150:108;
figure;
histogram(RT_ms,edges);

% -- All responses
f_plot_OMR_acoustic(Lr, Ll, nbL, nbR, Rr, Rl, ang_b, ang_esc,...
    mL, -mR);
subplot(1,2,1)
hold on
nb_fish = ['n = ', num2str(sum(n_fish))];
nb_esc = ['n_{esc} = ', num2str(sum(n_fish_esc))];
title({'All response', '', [nb_fish ' - ' nb_esc]})
subplot(1,2,2)
title([num2str(F.dpf) 'dpf - ' F.OMR 'ms OMR - ' F.V ' Vpp'])

% -- SLC responses
f_plot_OMR_acoustic(Lr_S, Ll_S, nbL_S, nbR_S, Rr_S, Rl_S, ang_b_S, ang_esc_S,...
    mL_S, -mR_S);
subplot(1,2,1)
hold on
nb_fish = ['n = ', num2str(sum(n_fish))];
nb_esc = ['n_{esc} = ', num2str(size(ind_SLC,2))];
title({'Only SLC', '', [nb_fish ' - ' nb_esc]})

% -- LLC responses
f_plot_OMR_acoustic(Lr_L, Ll_L, nbL_L, nbR_L, Rr_L, Rl_L, ang_b_L, ang_esc_L,...
    mL_L, -mR_L);
subplot(1,2,1)
hold on
nb_fish = ['n = ', num2str(sum(n_fish) - (nbL_S + nbR_S))];
nb_esc = ['n_{esc} = ', num2str(size(ind_LLC,2))];
title({'Only LLC', '', [nb_fish ' - ' nb_esc]})

% -- Plot just mean for statistic comparison
figure
matrix_turn = sign(ang_b).*sign(ang_esc);
matrix_turn(isnan(matrix_turn)==1) = [];
std_allturn = 1/sqrt(nbL+nbR);
m_allturn = mean(matrix_turn);
[~,p_all] = ttest(matrix_turn);
p_all = ['p = ' num2str(p_all,3)];
p_all = [p_all ' - n = ' num2str(sum(n_fish_esc))];

std_SLC = 1/sqrt(nbL_S+nbR_S);
m_SLC = mean(matrix_turn(ind_SLC));
[~,p_SLC] = ttest(matrix_turn(ind_SLC));
p_SLC = ['p = ' num2str(p_SLC,3)];
p_SLC = [p_SLC ' - n = ' num2str(size(ind_SLC,2))];

std_LLC = 1/sqrt(nbL_L + nbR_L);
m_LLC = mean(matrix_turn(ind_LLC));
[~,p_LLC] = ttest(matrix_turn(ind_LLC));
p_LLC = ['p = ' num2str(p_LLC,3)];
p_LLC = [p_LLC ' - n = ' num2str(size(ind_LLC,2))];

if m_allturn >= 0
    bar(-0.5, -m_allturn, 0.05);
else
    bar(-0.5, -m_allturn, 0.05);
end
hold on
if m_SLC >= 0
    bar(0, -m_SLC, 0.05);
else
    bar(0, -m_SLC, 0.05);
end
if m_LLC >= 0
    bar(0.5, -m_LLC, 0.05);
else
    bar(0.5, -m_LLC, 0.05);
end

errorbar(-0.5, -m_allturn, std_allturn,'k');
errorbar(0, -m_SLC, std_SLC, 'k');
errorbar(0.5, -m_LLC, std_LLC, 'k');
xlim([-0.75, 0.75])
xticks([-0.5, 0, 0.5])
xticklabels({'All escape','SLC','LLC'})
title({'mean/std', [num2str(F.dpf) 'dpf - ' F.OMR 'ms OMR - ' F.V ' Vpp']})
b = 1;
ylim([-b b]);
text(-0.5, -b*0.92, p_all, 'HorizontalAlignment', 'center')
text(0, -b*0.92, p_SLC, 'HorizontalAlignment', 'center')
text(0.5, -b*0.92, p_LLC, 'HorizontalAlignment', 'center')
text(-0.7,-b/2,'Against OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
text(-0.7,b/2,'To OMR', 'rotation', 90, 'HorizontalAlignment', 'center')

% -- Plot % of response
resp_all = sum(n_fish_esc)/sum(n_fish)*100;
resp_SLC = size(ind_SLC,2)/sum(n_fish)*100;
resp_LLC = size(ind_LLC,2)/sum(n_fish)*100;
resp_LLCR = size(ind_LLC,2)/(sum(n_fish)-size(ind_SLC,2))*100;
resp_by_all = [size(ind_SLC,2)/sum(n_fish_esc)*100, size(ind_LLC,2)/sum(n_fish_esc)*100];

figure
stem(resp_all)
hold on
stem([2 3], resp_by_all)
% stem(3.4, resp_LLCR)
xlim([0 4])
ylim([0 100])