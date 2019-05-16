function [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F)

Data = F.load('data_OMR');

RT_ms = Data.reaction_time_ms;
ang_b = Data.angle_before;
sign_esc = Data.sign_escape;
mat_esc = Data.escape_matrix;
n_fish = Data.nb_fish;
n_fish_esc = Data.nb_fish_escape;
fbout = Data.fish_bout_OMR;

% remove nan value
ang_b(isnan(RT_ms)==1) = [];

ang_b = mod(ang_b,2*pi);
ang_b(ang_b>pi) = ang_b(ang_b>pi)-2*pi;
sign_esc(isnan(RT_ms)==1) = [];
mat_esc(isnan(RT_ms)==1) = [];
fbout(isnan(RT_ms)==1) = [];
RT_ms(isnan(RT_ms)==1) = [];
RT_ms(RT_ms < 0) = 0;