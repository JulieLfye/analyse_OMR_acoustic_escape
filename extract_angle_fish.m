function [ang_body] = extract_angle_fish(nb_detected_object, nb_frame, w, h,...
    xbody, ybody, file, path)

ang_body = nan(nb_detected_object,nb_frame);
for f = 1:nb_detected_object
    for i = 1:nb_frame
        wa = w;
        ha = h;
        if isnan(xbody(f,i)) == 0
            im = frame_open(file,path,i+1);
            [im_bw] = cropped_im(xbody(f,i),ybody(f,i),wa,ha,im);
            se = strel('square',2);
            im_bw = imdilate(im_bw,se);
            [~,n] = bwlabel(im_bw);
            if n ~= 0
                while n > 1 && wa >= 0 && ha >=0
                    wa = wa - 10;
                    ha = ha - 10;
                    [im_bw] = cropped_im(xbody(f,i),ybody(f,i),wa,ha,im);
                    se = strel('square',2);
                    im_bw = imdilate(im_bw,se);
                    [~,n] = bwlabel(im_bw);
                end
                [~,~,ang] = get_orientation_distmap(im_bw);
                ang_body(f,i) = ang*pi/180;
            end
        end
    end
    %     hold on
    %     plot(ang_body(f,:));
end

