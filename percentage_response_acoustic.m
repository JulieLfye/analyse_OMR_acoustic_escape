% function [] = percentage_response_acoustic(n_fish, n_fish_esc, ind_SLC, ind_LLC)

N = size(n_fish,2);
percent_resp_all_fish = n_fish_esc./n_fish*100;
percent_SLC_esc = nan(size(n_fish_esc));
percent_SLC_all_fish = nan(size(n_fish_esc));
percent_LLC_all_fish = nan(size(n_fish_esc));
% test = 0;
% testL = 0;

for i = 1:size(n_fish,2)
    if i==1
        f = find(ind_SLC <= n_fish_esc(1));
%         percent_SLC_esc(1) = size(f,2)/n_fish_esc(1)*100;
%         test = test + size(f,2);
        percent_SLC_all_fish(1) = size(f,2)/n_fish(1)*100;
        percent_LLC_all_fish(1) = (n_fish_esc(i)-size(f,2))/n_fish(1)*100;
%         testL = testL + n_fish_esc(i)-size(f,2);
    else
        f = find(sum(n_fish_esc(1:i-1)) < ind_SLC);
        f = find(ind_SLC(f) <= n_fish_esc(i)+sum(n_fish_esc(1:i-1)));
%         test = test + size(f,2);
%         percent_SLC_esc(i) = size(f,2)/n_fish_esc(i)*100;
        percent_SLC_all_fish(i) = size(f,2)/n_fish(i)*100;
        percent_LLC_all_fish(i) = (n_fish_esc(i)-size(f,2))/n_fish(i)*100;
%         testL = testL + n_fish_esc(i)-size(f,2);
    end
end
percent_LLC_esc = 100 - percent_SLC_esc;

figure
bar(1,mean(percent_resp_all_fish),'b')
hold on
errorbar(1,mean(percent_resp_all_fish), std(percent_resp_all_fish)/sqrt(N),'k')

bar(2,mean(percent_SLC_all_fish),'b')
errorbar(2,mean(percent_SLC_all_fish), std(percent_SLC_all_fish)/sqrt(N),'k')

bar(3,mean(percent_LLC_all_fish),'b')
errorbar(3,mean(percent_LLC_all_fish), std(percent_LLC_all_fish)/sqrt(N),'k')

% bar(4,mean(percent_SLC_esc),'r')
% errorbar(4,mean(percent_SLC_esc), std(percent_SLC_esc)/sqrt(N),'k')
% 
% bar(5,mean(percent_LLC_esc),'r')
% errorbar(5,mean(percent_LLC_esc), std(percent_LLC_esc)/sqrt(N),'k')