% test code

% i = 3;
% j = 3;
% mall(i,j) = mean(percent_resp_all_fish);
% mall(i,j+3) = std(percent_resp_all_fish)/sqrt(N);
% 
% mSLC(i,j) = mean(percent_SLC_all_fish);
% mSLC(i,j+3) = std(percent_SLC_all_fish)/sqrt(N);
% 
% mLLC(i,j) = mean(percent_LLC_all_fish);
% mLLC(i,j+3) = std(percent_LLC_all_fish)/sqrt(N);

close all
figure
x = [500, 1000, 2000];
% 5dpf black
i = 1;
plot(x,mall(i,1:3),'-xk','MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth', 2)
hold on
errorbar(x,mall(i,1:3),mall(i,4:6),'k')
% 6dpf red
i = 2;
plot(x,mall(i,1:3),'-xr','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth', 2)
hold on
errorbar(x,mall(i,1:3),mall(i,4:6),'r')
% 7 dpf blue
i = 3;
plot(x,mall(i,1:3),'-xb','MarkerFaceColor','b','MarkerEdgeColor','b','LineWidth', 2)
hold on
errorbar(x,mall(i,1:3),mall(i,4:6),'b')
% title('ALL, black 5dpf, red 6dpf, blue 7dpf')
% xlim([0 2500])

% figure
x = [500, 1000, 2000];
% 5dpf black
i = 1;
plot(x,mSLC(i,1:3),'-ok','MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth', 2)
hold on
errorbar(x,mSLC(i,1:3),mSLC(i,4:6),'k')
% 6dpf red
i = 2;
plot(x,mSLC(i,1:3),'-or','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth', 2)
hold on
errorbar(x,mSLC(i,1:3),mSLC(i,4:6),'r')
% 7 dpf blue
i = 3;
plot(x,mSLC(i,1:3),'-ob','MarkerFaceColor','b','MarkerEdgeColor','b','LineWidth', 2)
hold on
errorbar(x,mSLC(i,1:3),mSLC(i,4:6),'b')
title('SLC, black 5dpf, red 6dpf, blue 7dpf')
% xlim([0 2000])

% figure
x = [500, 1000, 2000];
% 5dpf black
i = 1;
plot(x,mLLC(i,1:3),'-sk','MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth', 2)
hold on
errorbar(x,mLLC(i,1:3),mLLC(i,4:6),'k')
% 6dpf red
i = 2;
plot(x,mLLC(i,1:3),'-sr','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth', 2)
hold on
errorbar(x,mLLC(i,1:3),mLLC(i,4:6),'r')
% 7 dpf blue
i = 3;
plot(x,mLLC(i,1:3),'-sb','MarkerFaceColor','b','MarkerEdgeColor','b','LineWidth', 2)
hold on
errorbar(x,mLLC(i,1:3),mLLC(i,4:6),'b')
title('All cross, SLC o, LLC square, black 5dpf, red 6dpf, blue 7dpf')
xlim([0 2500])