function [reaction_time, reaction_time_ms, angle_before, angle_escape,...
    nb_fish_considered, nb_fish_escape, f_remove] = data_OMR_acoustic(nb_detected_object,...
    nb_frame, angle_OMR, fps, fig)

fr_ac = nb_frame - 47;
time = -8:1:47;

f_remove = [];
reaction_time = nan(1,nb_detected_object);
angle_before = nan(1,nb_detected_object);
angle_escape = nan(1,nb_detected_object);
ang1 = nan(1,nb_detected_object);
d = nan(1,25);
for f = 1:nb_detected_object
    b = sum(angle_OMR(f,nb_frame-55:nb_frame-30));
    if isnan(b) == 0
        d = diff(angle_OMR(f,nb_frame-55:nb_frame-20));
        b = find(abs(d)>40*pi/180,1);
        if isempty(b) == 0
            fr = nb_frame - 55 + b;
            reaction_time(1,f) = nb_frame - 55 + b;
            angle_before(1,f) = angle_OMR(f,b + nb_frame - 55);
            angle_escape(1,f) = d(b);
        end
    else
        f_remove = [f_remove f];
    end
end
reaction_time(f_remove) = [];
angle_before(f_remove) = [];
angle_escape(f_remove) = [];
reaction_time_ms  = ((reaction_time - (fr_ac))/fps + 0.5/150)*1000;
nb_fish_considered = size(reaction_time,2);
nb_fish_escape = size(reaction_time(~isnan(reaction_time)),2);

ang = angle_OMR;
ang(f_remove,:) = [];

if fig == 1
    figure
    time = time*1000/150;
    plot(time,ang(:,nb_frame-55:end));
    hold on;
    plot([0 0],ylim,'k');
end