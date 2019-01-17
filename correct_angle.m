function [angle] = correct_angle(nb_detected_object, nb_frame, ang_body)

for f = 1:nb_detected_object
%     figure
%     plot(ang_body(f,:));
    for i = 2:nb_frame-1
        % correct angle
        diff_g = ang_body(f,i) - ang_body(f,i-1);
        diff_d = ang_body(f,i+1) - ang_body(f,i);
        t = diff_g - diff_d;
        if abs(diff_g) > 150*pi/180 && abs(diff_d) > 150*pi/180  
            if abs(t) > 5
                ang_body(f,i) = (ang_body(f,i-1) + ang_body(f,i+1))/2;
            end
        end
        
        % remove 0/2*pi edge
        d = (ang_body(f,i) - ang_body(f,i-1))*180/pi;
        if isnan(d) == 0
            ta = angle_per_frame(d)*pi/180;
            angle(f,i) = angle(f,i-1) + ta;
        end
        
    end
    angle(f,end) = angle(f,end-1);
%     hold on
%     plot(angle(f,:));
end