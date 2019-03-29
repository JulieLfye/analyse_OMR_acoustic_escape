% test code

% function [reaction_time, reaction_time_ms, angle_before, angle_escape,...
%     nb_fish_considered, nb_fish_escape, f_remove] = data_OMR_acoustic(nb_detected_object,...
%     nb_frame, angle_OMR, fps, fig)

% I take only fish that are present from the beginning of the trial and
% until the end

x = xbody;
y = ybody;
ang = angle_OMR;
f_remove = [];

for i = 1:nb_detected_object
    f = find(isnan(xbody(i,:))==1,1);
    if isempty(f) == 0
        f_remove = [f_remove i];
    end
end

x(f_remove,:) = [];
y(f_remove,:) = [];
ang(f_remove,:) = [];

% Bout detection

