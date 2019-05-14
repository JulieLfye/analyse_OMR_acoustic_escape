% code test

F = Focus();
% Choose age and voltage
F.dpf = 7;
F.V = '1_5';

% 0 OMR
F.OMR = '0000';
Data0 = F.load('data_OMR');

% 500 OMR
F.OMR = '0500';
Data500 = F.load('data_OMR');

% 1000 OMR
F.OMR = '1000';
Data1000 = F.load('data_OMR');

% 1500 OMR
F.OMR = '1500';
Data1500 = F.load('data_OMR');

% 2000 OMR
F.OMR = '2000';
Data2000 = F.load('data_OMR');

% plot all mean
mall = [mean(Data0.escape_matrix,'omitnan'), mean(Data500.escape_matrix,'omitnan'),...
    mean(Data1000.escape_matrix,'omitnan'), mean(Data1500.escape_matrix,'omitnan'),...
    mean(Data2000.escape_matrix,'omitnan')];
err = [std(Data0.escape_matrix,'omitnan')/sqrt(sum(Data0.nb_fish_escape)),...
    std(Data500.escape_matrix,'omitnan')/sqrt(sum(Data500.nb_fish_escape)),...
    std(Data1000.escape_matrix,'omitnan')/sqrt(sum(Data1000.nb_fish_escape)),...
    std(Data1500.escape_matrix,'omitnan')/sqrt(sum(Data1500.nb_fish_escape)),...
    std(Data2000.escape_matrix,'omitnan')/sqrt(sum(Data2000.nb_fish_escape))];
OMRtime = [0, 500, 1000, 1500, 2000];

hold on
plot(OMRtime, mall, 'b-o')
hold on
errorbar(OMRtime, mall, err, 'b')
xlim([-100 2100])
plot(xlim, [0 0], 'k')

% 