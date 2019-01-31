% test_code_2

close all
f = 8;
ang = ang_body(f,:);
figure;
plot(ang);
ang1 = ang;

for i = 2:nb_frame
    d = (ang(i)-ang(i-1))*180/pi;
    ta(i) = angle_per_frame(d);
%     if abs(ta(i)) <= 140
%         ang1(i) = ang1(i-1) + ta(i)*pi/180;
%     else
%         ang1(i) = ang1(i-1);
%     end
ang1(i)  = ang(i-1) + ta(i)*pi/180;
end

hold on
plot(ang1)