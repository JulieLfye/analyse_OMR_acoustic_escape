function [reaction_time, reaction_time_ms, angle_before, angle_escape,...
    nb_fish_considered, nb_fish_escape] = data_OMR_acoustic(nb_detected_object,...
    nb_frame, ang_OMR, fps)

frame_acoustic_signal = nb_frame-46;

f_remove = [];
reaction_time = nan(1,nb_detected_object);
angle_before = nan(1,nb_detected_object);
angle_escape = nan(1,nb_detected_object);
ang1 = nan(1,nb_detected_object);
d = nan(1,25);
for f = 1:nb_detected_object
    b = sum(ang_OMR(f,nb_frame-55:nb_frame-30));
    if isnan(b) == 0
        d = diff(ang_OMR(f,nb_frame-55:nb_frame-20));
        b = find(abs(d)>40*pi/180,1);
        if isempty(b) == 0
            fr = nb_frame - 55 + b;
            reaction_time(1,f) = nb_frame - 55 + b;
            angle_before(1,f) = ang_OMR(f,b + nb_frame - 55);
            angle_escape(1,f) = d(b);
        end
        
    else
        f_remove = [f_remove f];
    end
end
reaction_time(f_remove) = [];
angle_before(f_remove) = [];
angle_escape(f_remove) = [];
reaction_time_ms  = ((reaction_time - (nb_frame-46))/fps + 0.5/150)*1000;
nb_fish_considered = size(reaction_time,2);
nb_fish_escape = size(reaction_time(~isnan(reaction_time)),2);

ang = ang_OMR;
ang(f_remove,:) = [];

im = -9:1:46;
im = im*1000/150;
plot(im,ang(:,nb_frame-55:end));
hold on;
plot([0 0],ylim,'k');