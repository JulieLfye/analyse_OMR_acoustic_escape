figure;

f = 2;
angle = ang_body(f,1:end-1);
% for f = 1:nb_detected_object
    for i = 2:nb_frame
        
        d = (ang_body(f,i) - ang_body(f,i-1))*180/pi;
        
        if isnan(d) == 0
            t = angle_per_frame(d)*pi/180;
           
%             if abs(t) < 160*pi/180
                angle(1,i) = angle(1,i-1) + t ;
%             else
%                 angle(f,i) = angle(f,i-1);
%             end
        end
        
        
    end
    hold on
    plot(angle(1,:)*180/pi)
% end
plot([1 345],[360 360],'k')