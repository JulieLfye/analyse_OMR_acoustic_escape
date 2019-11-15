% code test

clear

D = load('D:\OMR_acoustic_experiments\test_data_all_whole_illumination\OMR_acoustic\data_whole_illumination_asus\7_dpf\3_0_Vpp\OMR_1000\data_OMR.mat');
load('D:\OMR_acoustic_experiments\test_data_all_whole_illumination\OMR_acoustic\data_whole_illumination\7_dpf\3_0_Vpp\OMR_1000\data_OMR.mat')


for i = 1:size(angle_before,2)
    a = size(D.angle_before,2);
    D.angle_before{a+1} = angle_before{i};
end

for i = 1:size(escape_matrix,2)
    a = size(D.escape_matrix,2);
    D.escape_matrix{a+1} = escape_matrix{i};
end

for i = 1:size(first_bout_direction,2)
    a = size(D.first_bout_direction,2);
    D.first_bout_direction{a+1} = first_bout_direction{i};
end

for i = 1:size(fish_bout_OMR,2)
    a = size(D.fish_bout_OMR,2);
    D.fish_bout_OMR{a+1} = fish_bout_OMR{i};
end

for i = 1:size(fish_to_consider_FT,2)
    a = size(D.fish_to_consider_FT,2);
    D.fish_to_consider_FT{a+1} = fish_to_consider_FT{i};
end

for i = 1:size(reaction_time_ms,2)
    a = size(D.reaction_time_ms,2);
    D.reaction_time_ms{a+1} = reaction_time_ms{i};
end

for i = 1:size(sign_escape,2)
    a = size(D.sign_escape,2);
    D.sign_escape{a+1} = sign_escape{i};
end

D.nb_fish = [D.nb_fish nb_fish];
D.nb_fish_escape = [D.nb_fish_escape nb_fish_escape];

clearvars -except D
angle_before = D.angle_before;
escape_matrix = D.escape_matrix;
first_bout_direction = D.first_bout_direction;
fish_bout_OMR = D.fish_bout_OMR;
fish_to_consider_FT = D.fish_to_consider_FT;
reaction_time_ms = D.reaction_time_ms;
nb_fish_escape = D.nb_fish_escape;
nb_fish = D.nb_fish;
sign_escape = D.sign_escape;

clear D