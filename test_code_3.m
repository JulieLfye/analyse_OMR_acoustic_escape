% test code

% with statistic comparaison
close all

figure
matrix_turn = sign(ang_b).*sign(ang_esc);
matrix_turn(isnan(matrix_turn)==1) = [];
std_allturn = 1/sqrt(nbL+nbR);
m_allturn = mean(matrix_turn)/std_allturn;
[~,p_all] = ttest(matrix_turn);
p_all = ['p = ' num2str(p_all,3)];

SLCturn = ang_b(ind_SLC).*ang_esc(ind_SLC);
std_SLC = 1/sqrt(nbL_S+nbR_S);
m_SLC = mean(SLCturn)/std_SLC;
[~,p_SLC] = ttest(matrix_turn(ind_SLC));
p_SLC = ['p = ' num2str(p_SLC,3)];

LLCturn = ang_b(ind_LLC).*ang_esc(ind_LLC);
std_LLC = 1/sqrt(nbL_L + nbR_L);
m_LLC = mean(LLCturn)/std_LLC;
[~,p_LLC] = ttest(matrix_turn(ind_LLC));
p_LLC = ['p = ' num2str(p_LLC,3)];

if m_allturn >= 0
    stem(-0.5, -m_allturn, 'r');
else
    stem(-0.5, -m_allturn, 'b');
end
hold on
if m_SLC >= 0
    stem(0, -m_SLC, 'r');
else
    stem(0, -m_SLC, 'b');
end
if m_LLC >= 0
    stem(0.5, -m_LLC, 'r');
else
    stem(0.5, -m_LLC, 'b');
end

xlim([-0.75, 0.75])
xticks([-0.5, 0, 0.5])
xticklabels({'All escape','SLC','LLC'})
title('mean/std')
b = max(abs(ylim));
ylabel('Sigma')
ylim([-b b]);
text(-0.5, -b+0.5, p_all, 'HorizontalAlignment', 'center')
text(0, -b+0.5, p_SLC, 'HorizontalAlignment', 'center')
text(0.5, -b+0.5, p_LLC, 'HorizontalAlignment', 'center')
text(-0.7,-b/2,'Against OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
text(-0.7,b/2,'To OMR', 'rotation', 90, 'HorizontalAlignment', 'center')