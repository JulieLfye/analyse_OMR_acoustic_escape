function [reaction_time, angle_before, angle_escape] = data_OMR_acoustic(nb_detected_object,...
    nb_frame, angle_to_OMR, fps);

f_remove = [];
reaction_time = nan(1,nb_detected_object);
angle_before = nan(1,nb_detected_object);
angle_escape = nan(1,nb_detected_object);
for f = 1:nb_detected_object
    b = sum(angle_to_OMR(f,nb_frame-55:nb_frame));
    if isnan(b) == 0
        d = diff(angle_to_OMR(f,end-55:end));
        b = find(abs(d)>60*pi/180,1);
        if isempty(b) == 0
            reaction_time(1,f) = b + nb_frame - 55;
            angle_before(1,f) = angle_to_OMR(f,b + nb_frame - 57);
            angle_escape(1,f) = d(b);
        end
        
    else
        f_remove = [f_remove f];
    end
end
reaction_time(f_remove) = [];
angle_before(f_remove) = [];
angle_escape(f_remove) = [];
reaction_time  = ((reaction_time - (nb_frame-45))/fps + 0.5/fps)*1000;
