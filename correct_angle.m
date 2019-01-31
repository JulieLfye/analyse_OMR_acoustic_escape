% function [angle, ang_OMR] = correct_angle(nb_detected_object,...
%     nb_frame, ang_body, fig, P)

ang = ang_body;
angle = ang;
ang_OMR = angle;
OMRangle = mod(P.OMR.angle,360)*pi/180;

% for f = 1:nb_detected_object
    
    f = 5;
    
    d  = [nan diff(ang(f,:))];
    [val,ind] = findpeaks(d,'MinPeakHeight',pi/2);
%         plot(d)
%         hold on
%         plot(ind,val,'o')
    
    %% determine  ang correct angle for group of peaks
    dind = diff(ind);
    b1 = find(dind<8);
    a = diff(b1);
    b2 = find(a>1);
    ind2 = ind;
    if isempty(b2) == 0
        n1 = 1;
        n2 = b2(1);
        i = 1;
        while i <= size(b2,2)+1 % 2 groups at least
            %%
            if n1 == n2
                %create group of index
                gpind = ind(b1(n1):b1(n1)+1);
                ind2(b1(n1):b1(n1)+1) = nan;
                i = i+1;
                n1 = n2+1;
                if i >= size(b2,2)+1
                    n2 = size(b1,2);
                else
                    n2 = b2(i);
                end
                % correct the angle
                mmin = min(gpind);
                mmax = max(gpind);
                m = round(mean(gpind));
                if mmax <= nb_frame-5 && mmin-5 >= 1
                    md = mean(ang(f,mmax+4:mmax+5),'omitnan');
                    mg = mean(ang(f,mmin-5:mmin-4),'omitnan');
                elseif mmax > nb_frame-5
                    md = ang(f,end);
                    mg = mean(ang(f,mmin-5:mmin-4),'omitnan');
                elseif mmin <= 5
                    mg = ang(f,1);
                    md = mean(ang(f,mmax+4:mmax+5),'omitnan');
                end
                % correction
                if mmax <= nb_frame-3 && mmin-3 >= 1
                    ang(f,mmin-3:m-1) = mg;
                    ang(f,m:mmax+3) = md;
                elseif mmax > nb_frame-3
                    ang(f,m:end ) = md;
                elseif mmin <= 3
                    ang(f,1:m-1) = mg;
                end
                %%
            else
                % create group of index
                gpind = ind(b1(n1):b1(n2)+1);
                ind2(b1(n1):b1(n2)+1) = nan;
                i = i+1;
                n1 = n2+1;
                if i >= size(b2,2)+1
                    n2 = size(b1,2);
                else
                    n2 = b2(i);
                end
                % correct the angle
                mmin = min(gpind);
                mmax = max(gpind);
                m = round(mean(gpind));
                if mmax <= nb_frame-5 && mmin-5 >= 1
                    md = mean(ang(f,mmax+4:mmax+5),'omitnan');
                    mg = mean(ang(f,mmin-5:mmin-4),'omitnan');
                elseif mmax > nb_frame-5
                    md = ang(f,end);
                    mg = mean(ang(f,mmin-5:mmin-4),'omitnan');
                elseif mmin <= 5
                    mg = ang(f,1);
                    md = mean(ang(f,mmax+4:mmax+5),'omitnan');
                end
                % correction
                if mmax <= nb_frame-3 && mmin-3 >= 1
                    ang(f,mmin-3:m-1) = mg;
                    ang(f,m:mmax+3) = md;
                elseif mmax > nb_frame-3
                    ang(f,m:end ) = md;
                elseif mmin <= 3
                    ang(f,1:m-1) = mg;
                end
            end
        end
    elseif isempty(b1) == 0 %only one group
        n1 = 1;
        gpind = ind(b1(n1):b1(n1)+1);
        mmin = min(gpind);
        mmax = max(gpind);
        m = round(mean(gpind));
        if mmax <= nb_frame-5 && mmin-5 >= 1
            md = mean(ang(f,mmax+4:mmax+5),'omitnan');
            mg = mean(ang(f,mmin-5:mmin-4),'omitnan');
        elseif mmax > nb_frame-5
            md = ang(f,end);
            mg = mean(ang(f,mmin-5:mmin-4),'omitnan');
        elseif mmin <= 5
            mg = ang(f,1);
            md = mean(ang(f,mmax+4:mmax+5),'omitnan');
        end
        % correction
        if mmax <= nb_frame-3 && mmin-3 >= 1
            ang(f,mmin-3:m-1) = mg;
            ang(f,m:mmax+3) = md;
        elseif mmax > nb_frame-3
            ang(f,m:end ) = md;
        elseif mmin <= 3
            ang(f,1:m-1) = mg;
        end
    end
    
    
    %% correct isolated point
    l = find(isnan(ind2) == 0);
    for i = 1:size(l,2)
        q = ind2(l(i));
        
        if q <= nb_frame-4 && q >= 1
            md = mean(ang(f,q+3:q+4),'omitnan');
            mg = mean(ang(f,q-4:q-3),'omitnan');
        elseif q> nb_frame-4
            md = ang(f,end);
        elseif q <= 4
            mg = ang(f,1);
        end

        % correct angle
        if q <= nb_frame-3 && q-3 >= 1
            ang(f,q-2:q-1) = mg;
            ang(f,q:q+2) = md;
        elseif q > nb_frame-3
            ang(f,q+1:end ) = md;
        elseif q <= 3
            ang(f,1:q) = mg;
        end        
    end
    % adapt first and last angle
    ang(f,1) = mean(ang(f,2:5),'omitnan');
    ang(f,end) = mean(ang(f,end-5:end-2),'omitnan');
    
    %% Correction of the 0-360 edge
    for i = 2:nb_frame
        d1 = (ang(f,i) - ang(f,i-1))*180/pi;
        if isnan(d1) == 0
            ta = angle_per_frame(d1);
            if abs(ta) <= 150
                angle(f,i) = angle(f,i-1) + ta*pi/180;
            else
                angle(f,i) = angle(f,i-1);
            end
        end
    end
    %% Angle to OMR
    ang_OMR(f,:) = angle(f,:) - OMRangle;
    ang1 = mean(ang_OMR(f,1:5),'omitnan');
    if ang1 > pi
        ang_OMR(f,:) = ang_OMR(f,:) - 2*pi;
    end
    
    if fig == 1
        figure;
        plot(ang_body(f,:));
        hold on;
        plot(angle(f,:));
        plot(ang_OMR(f,:));
    end
% end