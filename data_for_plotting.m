function [RT_ms1, ang_b1, sign_esc1, mat_esc1, n_fish, n_fish_esc, fbout1] = data_for_plotting(F)

Data = F.load('data_OMR');

RT_ms = Data.reaction_time_ms;
ang_b = Data.angle_before;
sign_esc = Data.sign_escape;
mat_esc = Data.escape_matrix;
n_fish = Data.nb_fish;
n_fish_esc = Data.nb_fish_escape;
fbout = Data.fish_bout_OMR;

% remove nan value
ang_b1 = [];
sign_esc1 = [];
mat_esc1 = [];
fbout1 = [];
RT_ms1 = [];

for i = 1:size(n_fish,2)
    ang_b1 = [ang_b1 ang_b{i}];
    sign_esc1 = [sign_esc1 sign_esc{i}];
    mat_esc1 = [mat_esc1 mat_esc{i}];
    fbout1 = [fbout1 fbout{i}];
    RT_ms1 = [RT_ms1 RT_ms{i}];
end
ang_b1(isnan(RT_ms1)==1) = [];
ang_b1 = mod(ang_b1,2*pi);
ang_b1(ang_b1>pi) = ang_b1(ang_b1>pi)-2*pi;
sign_esc1(isnan(RT_ms1)==1) = [];
mat_esc1(isnan(RT_ms1)==1) = [];
fbout1(isnan(RT_ms1)==1) = [];
RT_ms1(isnan(RT_ms1)==1) = [];
RT_ms1(RT_ms1 < 0) = 0;



