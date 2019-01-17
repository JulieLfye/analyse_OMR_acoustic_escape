
f = 7;
% ----- Correct head-tail detection
angle_r = ang_body(f,:);
plot(ang_body(f,:)*180/pi);
for i = 2:nb_frame-1
    diff_g = ang_body(f,i) - ang_body(f,i-1);
    diff_d = ang_body(f,i+1) - ang_body(f,i);
    t = diff_g - diff_d;
    if abs(diff_g) > 150*pi/180 && abs(diff_d) > 150*pi/180
        
        if abs(t) > 5
            angle_r(i) = (angle_r(i-1) + angle_r(i+1))/2;
        end
    end
    
end
hold on
plot(angle_r*180/pi)



figure
angle = angle_r;
% for f = 1:nb_detected_object
    for i = 2:nb_frame
        
        d(i) = (angle_r(i) - angle_r(i-1))*180/pi;
        
        if isnan(d) == 0
            t(i) = angle_per_frame(d(i))*pi/180;
           
%             if abs(t) < 170*pi/180
                angle(1,i) = angle(1,i-1) + t(i);
%             else
%                 angle(1,i) = angle(1,i-1);
%             end
        end
        
        
    end
    hold on
    plot(angle(1,:)*180/pi)
% end
plot([1 345],[360 360],'k')

