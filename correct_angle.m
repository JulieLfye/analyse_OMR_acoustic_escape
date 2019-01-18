function [angle, angle_to_OMR] = correct_angle(nb_detected_object,...
    nb_frame, ang_body, fig, P)

angle = ang_body;

for f = 1:nb_detected_object
    %     if fig == 1
    %         figure
    %         plot(ang_body(f,:));
    %     end
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
    
    if fig ==1
        hold on
        plot(angle(f,:));
    end
end

OMRangle = mod(P.OMR.angle,360)*pi/180;
if OMRangle > pi
    OMRangle = OMRangle - 2*pi;
end

if fig == 1
    figure
end
angle_to_OMR = angle - OMRangle;
for f = 1:nb_detected_object
    ang = angle(f,find(isnan(angle(f,:))==0,1));
    if ang > pi
        angle_to_OMR(f,:) = angle_to_OMR(f,:) - 2*pi;
    end
    if fig == 1
        hold on
        plot(angle_to_OMR(f,:))
    end
end