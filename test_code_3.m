% test code

% function [] = f_turn_to_OMR(reaction_time_ms, angle_before, angle_escape,
% nb_fish_considered, nb_fish_escape)

close all

% plot reaction time histogram between 0 and 100 ms
edges = 0:1000/150:108;
figure;
histogram(RT_ms,edges);


% Good turn, all responses
f_plot_OMR_acoustic(Lr, Ll, nbL, nbR, Rr, Rl, ang_b, ang_esc,...
    mL, mR);
subplot(1,2,1)
hold on
nb_fish = ['n = ', num2str(sum(nb_fish_considered1))];
nb_esc = ['n_{esc} = ', num2str(sum(nb_fish_escape1))];
text(2,0.9, nb_fish)
text(2,0.8, nb_esc)
title('All response')

%SLC
f_plot_OMR_acoustic(Lr_S, Ll_S, nbL_S, nbR_S, Rr_S, Rl_S, ang_b_S, ang_esc_S,...
    mL_S, mR_S);
subplot(1,2,1)
hold on
nb_fish = ['n = ', num2str(sum(nb_fish_considered1))];
nb_esc = ['n_{esc} = ', num2str(nbL_S + nbR_S)];
text(2,0.9, nb_fish)
text(2,0.8, nb_esc)
title('Only SLC')


%LLC
f_plot_OMR_acoustic(Lr_L, Ll_L, nbL_L, nbR_L, Rr_L, Rl_L, ang_b_L, ang_esc_L,...
    mL_L, mR_L); 
subplot(1,2,1)
hold on
nb_fish = ['n = ', num2str(sum(nb_fish_considered1) - (nbL_S + nbR_S))];
nb_esc = ['n_{esc} = ', num2str(nbL_L + nbR_L)];
text(2,0.9, nb_fish)
text(2,0.8, nb_esc)
title('Only LLC')