%test 2
close all

cxf = xbody;
cyf = ybody;
ang = angle_OMR;
f_remove = [];

for i = 1:nb_detected_object
    f = find(isnan(xbody(i,:))==1,1);
    if isempty(f) == 0
        f_remove = [f_remove i];
    end
end

cxf(f_remove,:) = [];
cyf(f_remove,:) = [];
ang(f_remove,:) = [];

prewindow = 0.2;
prewindow = round(prewindow*fps);
postwindow = 0.2;
postwindow = round(postwindow*fps);
im = 1;
sig_lim = round(0.6*150/6);
correl_lim = 0.85;

%% bout detection for OMR_acoustic
f = 7;
% for f = 1:size(cxf,1)
    
    cx = cxf(f,:);
    cy = cyf(f,:);
    angf = ang(f,:);
    
    mx = movmean(cx,10,'omitnan');
    my = movmean(cy,10,'omitnan');
    mangf = movmean(angf,10,'omitnan');
    
    dx = diff(mx, 1, 2);
    dxcarr = dx.^2;
    dy = diff(my, 1, 2);
    dycarr = dy.^2;
    dtheta = diff(mangf, 1, 2);
    dthetacarr = dtheta.^2;
    
    % get variances
    vardxy = nanvar(dx(:)+dy(:));
    vardth = nanvar(dtheta(:));
    
    % get the significant displacement
    sigdisplacementmatrix = ((dxcarr'+dycarr')/vardxy)';
    sigdisplacementmatrix = sigdisplacementmatrix - min(sigdisplacementmatrix);
    sigdisplacementmatrix = sigdisplacementmatrix/max(sigdisplacementmatrix)*100;
    vel = sigdisplacementmatrix;
    vel = movmean(vel,5);
    lvel = log(vel);
    lvel(~isfinite(lvel)) = NaN;
    lvel(isnan(lvel)) = 0;
    lvel(lvel<-5) = -5;
    
    % ----- find peak and valley -----
    minIPI = round(0.2*fps);
    minh = std(lvel)+median(lvel);
    minPro = 2;
    [peakMags, peakInds] = findpeaks(lvel,'MinPeakDistance', minIPI, 'MinPeakHeight', minh, 'MinPeakProminence',minPro);
    
    [peakMagsvel, peakIndsvel] = findpeaks(vel,'MinPeakDistance', minIPI, 'MinPeakHeight', 1);
    
    %     plot(vel)
    %     hold on
    %     plot(peakIndsvel,peakMagsvel,'bo')
    %     plot(peakInds, vel(peakInds)+5,'ko')
    
    %% part to define bout
    indbout = nan(2,size(peakInds,2));
    if isempty(peakInds) == 0
        
        % remove peak too close from the edges
        while isempty(peakInds) == 0 && peakInds(1) < round(0.15*fps)
            peakInds(1) = [];
            peakMags(1) = [];
        end
        if isempty(peakInds) == 0
            n = 0;
            
            while isempty(peakInds) == 0 && peakInds(end) > size(vel,2)-round(0.1*fps)+1
                n = n+1;
                peakInds(end) = [];
                peakMags(end) = [];
            end
        end
        
        peakIndsvel1 = peakIndsvel;
        i = 1;
        for i=1:size(peakInds,2)
            j = size(peakIndsvel,2);
            k = [];
            while j > 0
                d = abs(peakInds(i) - peakIndsvel(j));
                if d < 10
                    k = j;
                    j = 0;
                else
                    j = j - 1;
                end
            end
            peakIndsvel1(k) = 0;
            
            if isempty(k) == 0
                % peak detected on both lvel and vel
                [fg,x,y, correl, limwindow] = fitgauss_vel_bout(prewindow, postwindow, peakInds, peakIndsvel, i, indbout, vel, im);
                if peakInds(i) < size(vel,2)-70 % non escape bout
                    if correl > correl_lim && fg.sig < sig_lim
                        indbout(1,i) = round(fg.mu - 3*fg.sig)-1;
                        indbout(2,i) = round(fg.mu + 3*fg.sig)+1;
                        if indbout(1,i) <= 0
                            indbout(1,i) = 1;
                        end
                        if i < size(peakInds,2)
                            if indbout(2,i) > peakInds(i+1)-10
                                indbout(2,i) = peakInds(i+1)-11;
                            end
                        else
                            if indbout(2,i) > x(end)
                                indbout(2,i) = x(end);
                            end
                        end
                    end
                elseif peakInds(i) >= size(vel,2)-70 % escape bout
                    if correl > 0.8 && fg.sig < sig_lim
                        % define beginning and end bout
                        acc = abs(diff(vel(limwindow(1):limwindow(2))));
                        indbout(1,i) = round(fg.mu - 3*fg.sig)-1;
                        indbout(2,i) = round(fg.mu + 3*fg.sig)+1;
                        if indbout(1,i) <= 0
                            indbout(1,i) = 1;
                        end
                        if i < size(peakInds,2)
                            if indbout(2,i) > peakInds(i+1)-10
                                indbout(2,i) = peakInds(i+1)-11;
                            end
                        else
                            if indbout(2,i) > x(end)
                                indbout(2,i) = x(end);
                            end
                        end
                    end
                end
                
            else
                % peak detected on lvel but not on vel
                [fg,x,y, correl, limwindow] = fitgauss_vel_bout(prewindow, postwindow, peakInds, peakIndsvel, i, indbout, vel, im);
                if correl > correl_lim && fg.sig < sig_lim
                    [mags, inds] = findpeaks(y,'minPeakHeight', 1.5*std(y));
                    indbout(1,i) = round(fg.mu - 3*fg.sig)-1;
                    indbout(2,i) = round(fg.mu + 3*fg.sig)+1;
                    if indbout(1,i) <= 0
                        indbout(1,i) = 1;
                    end
                    if i < size(peakInds,2)
                        if indbout(2,i) > peakInds(i+1)-10
                            indbout(2,i) = peakInds(i+1)-11;
                        end
                    else
                        if indbout(2,i) > x(end)
                            indbout(2,i) = x(end);
                        end
                    end
                end
            end
        end
        
        
        indbout(:,isnan(indbout(1,:))) = [];
        d = diff(indbout,1)+1;
        indbout(:,d<0.1*fps) = [];
        %  -- check if peak detected on vel but not on lvel
        peakIndsvel1(peakIndsvel1==0) = [];
        if isempty(peakIndsvel1) == 0
            i = 1;
            for i = 1:size(peakIndsvel1,2)
                indtoadd = [];
                if peakIndsvel1(i) > round(0.15*fps) && peakIndsvel1(i) < size(vel,2)-round(0.1*fps)+1
                    ibout = zeros(2,size(peakIndsvel1,2));
                    [fg,x,y, correl, limwindow] = fitgauss_vel_bout(prewindow, postwindow, peakIndsvel1, peakIndsvel, i, ibout, vel, im);
                    if correl > correl_lim && fg.sig < sig_lim
                        indtoadd = [round(fg.mu - 3*fg.sig)-1; round(fg.mu + 3*fg.sig)+1];
                    end
                    if isempty(indtoadd) == 0
                        if indtoadd(1) <= 0
                            indtoadd(1,i) = 1;
                        end
                        if peakIndsvel1(i) < peakInds(1) % first bout
                            if indtoadd(2) > indbout(1,1)
                                indtoadd(2) = indbout(1,1)-5;
                            end
                            indbout = [indtoadd, indbout];
                        elseif peakIndsvel1(i) > peakInds(end) % last bout
                            if indtoadd(2) > size(vel,2)
                                indtoadd(2) = size(vel,2);
                            end
                            if indtoadd(1) <= indbout(2,end)
                                indtoadd(1) = indbout(2,end) + 1;
                            end
                            indbout = [indbout, indtoadd];
                        else % between 2 bouts
                            jsup = find(indbout(2,:)>fg.mu,1);
                            jinf = find(indbout(1,:)<fg.mu);
                            if isempty(jinf) == 0
                                jinf = jinf(end);
                            elseif indtoadd(2) >= indbout(1,jsup)
                                indtoadd(2) = indbout(1,jsup)-1;
                                jinf = jsup-1;
                            end
                            if jsup-jinf == 1
                                % peak with position jsup
                                indbout = [indbout(:,1:jinf), indtoadd, indbout(:,jsup:end)];
                            end
                        end
                    end
                end
            end
        end
    end
    
    figure
    plot(vel);
    hold on
    plot(peakIndsvel,peakMagsvel,'bo')
    plot(peakInds, vel(peakInds)+5,'ko')
    for i = 1:size(indbout,2)
        x = indbout(1,i):1:indbout(2,i);
        y = vel(indbout(1,i):1:indbout(2,i));
        plot(x,y,'r')
    end
% end

