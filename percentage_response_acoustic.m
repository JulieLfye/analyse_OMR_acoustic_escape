% function [] = percentage_response_acoustic(n_fish, n_fish_esc, ind_SLC, ind_LLC)

percent_resp = n_fish_esc./n_fish*100;
m_percent_resp = mean(percent_resp);
std_percent_resp = std(percent_resp);

for i = 1:size(n_fish,2)
    if i==1
        f = find(ind_SLC <= n_fish_esc(1));
        percent_SLC(1) = size(f,2)/n_fish_esc(1)*100;
    else
        f = find(n_fish_esc(i-1) < ind_SLC);
        f = find(ind_SLC(f) <= n_fish_esc(i));
        percent_SLC(i) = size(f,2)/n_fish_esc(1)*100;
    end
end
percent_LLC = 100 - percent_SLC;

figure
bar(1,m_percent_resp)
hold on
errorbar(1,m_percent_resp, std_percent_resp,'k')

bar(2,mean(percent_SLC))
errorbar(2,mean(percent_SLC), std(percent_SLC),'k')

bar(3,mean(percent_LLC))
errorbar(3,mean(percent_LLC), std(percent_LLC),'k')