% test code

%extract information for good and wrong turn

RT_ms = reaction_time_ms1;
RT_ms(isnan(RT_ms)==1) = [];
RT_ms(RT_ms < 0) = 0;

ang_b = angle_before1;
ang_b(isnan(ang_b)==1) = [];
ang_b = mod(ang_b,2*pi);

ang_esc = angle_escape1;
ang_esc(isnan(ang_esc)==1) = [];

% ----- All responses -----
Ll = []; % Left side, turn left
Lr = []; % Left side, turn right
Rl = []; % Right side, turn left
Rr = []; % Right side, turn right

for i = 1:size(ang_b,2)
    if ang_b(i) < pi %left side to OMR
        if ang_esc(i) < 0 %turn  right
            Lr = [Lr i];
        else % turn left
            Ll = [Ll i];
        end
    elseif ang_b(i) >= pi %right side to OMR
        if ang_esc(i) < 0 %turn right
            Rr = [Rr i];
        else %turn left
            Rl = [Rl i];
        end
    end
end

nbL = size(Lr,2) + size(Ll,2);
nbR = size(Rr,2) + size(Rl,2);
mL = (size(Ll,2) - size(Lr,2))/nbL;
mR = (size(Rl,2) - size(Rr,2))/nbL;

% ----- SLC responses -----
ind_SLC = find(RT_ms < 20);
ang_b_S = ang_b(ind_SLC);
ang_esc_S = ang_esc(ind_SLC);

Ll_S = []; % Left side, turn left
Lr_S = []; % Left side, turn right
Rl_S = []; % Right side, turn left
Rr_S = []; % Right side, turn right

for i = 1:size(ang_b_S,2)
    if ang_b_S(i) < pi %left side to OMR
        if ang_esc_S(i) < 0 %turn  right
            Lr_S = [Lr_S i];
        else % turn left
            Ll_S = [Ll_S i];
        end
    elseif ang_b_S(i) >= pi %right side to OMR
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
mR_S = (size(Rl_S,2) - size(Rr_S,2))/nbL_S;

% ----- LLC responses -----
ind_LLC = find(RT_ms > 20);
ang_b_L = ang_b(ind_LLC);
ang_esc_L = ang_esc(ind_LLC);

Ll_L = []; % Left side, turn left
Lr_L = []; % Left side, turn right
Rl_L = []; % Right side, turn left
Rr_L = []; % Right side, turn right

for i = 1:size(ang_b_L,2)
    if ang_b_L(i) < pi %left side to OMR
        if ang_esc_L(i) < 0 %turn  right
            Lr_L = [Lr_L i];
        else % turn left
            Ll_L = [Ll_L i];
        end
    elseif ang_b_L(i) >= pi %right side to OMR
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
mR_L = (size(Rl_L,2) - size(Rr_L,2))/nbL_L;