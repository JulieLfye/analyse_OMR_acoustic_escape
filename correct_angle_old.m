function [angle, ang_OMR] = correct_angle_old(nb_detected_object,...
    nb_frame, ang_body, fig, P)

ang = ang_body;

% correct angle ie 180° problem
for f = 1:nb_detected_object
    i = 2;
    while i < nb_frame-1
        d = ang(f,i) - ang(f,i-1);
        if abs(d) > 130*pi/180 && abs(d) < 4
            ang(f,i) = ang(f,i-1);
            i = i + 1;
        else
            i = i+1;
        end
    end
end


angle = ang;
ang_OMR = nan(nb_detected_object,nb_frame);
for f = 1:nb_detected_object
    % remove 0/2*pi edge
    for i = 2:nb_frame
        d = (ang(f,i) - ang(f,i-1))*180/pi;
        if isnan(d) == 0
            ta(f,i) = angle_per_frame(d)*pi/180;
            angle(f,i) = angle(f,i-1) + ta(f,i);
        end
    end
    angle(f,end) = angle(f,end-1);
    
    %angle to OMR
    OMRangle = mod(P.OMR.angle,360)*pi/180;
    ang_OMR(f,:) = angle(f,:) - OMRangle;
    ang1 = mean(ang_OMR(f,1:5),'omitnan');
    if ang1 > pi
        ang_OMR(f,:) = ang_OMR(f,:) - 2*pi;
    end
end

if fig == 1
    figure
    plot(ang_OMR')
end