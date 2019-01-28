function [reaction_time, reaction_time_ms, angle_before, angle_escape,...
    nb_fish_considered, nb_fish_escape] = data_OMR_acoustic(nb_detected_object,...
    nb_frame, angle_to_OMR, fps)

f_remove = [];
reaction_time = nan(1,nb_detected_object);
angle_before = nan(1,nb_detected_object);
angle_escape = nan(1,nb_detected_object);
for f = 1:nb_detected_object
    b = sum(angle_to_OMR(f,nb_frame-55:nb_frame-30));
    if isnan(b) == 0
        d(f,:) = diff(angle_to_OMR(f,nb_frame-55:nb_frame-30));
        b = find(abs(d(f,:))>40*pi/180,1);
        if isempty(b) == 0
            reaction_time(1,f) = b + nb_frame - 55;
            angle_before(1,f) = angle_to_OMR(f,b + nb_frame - 57);
            angle_escape(1,f) = d(f,b);
        end
        
    else
        f_remove = [f_remove f];
    end
end
reaction_time(f_remove) = [];
angle_before(f_remove) = [];
angle_escape(f_remove) = [];
reaction_time_ms  = ((reaction_time - (nb_frame-46))/fps + 0.5/fps)*1000;
nb_fish_considered = size(reaction_time,2);
nb_fish_escape = size(reaction_time(~isnan(reaction_time)),2);
