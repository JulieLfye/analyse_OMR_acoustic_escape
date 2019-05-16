function [] = f_plot_new_OMR_acoustic(OMR, m_ind, std_ind, n_f, n_f_ind, p_ind, F, name)

figure

if F.dpf == 5
    plot(OMR, m_ind, '-ko')
    hold on
    errorbar(OMR, m_ind, std_ind, 'k')
    xlim([-300, 2300])
    plot(xlim, [0, 0], 'k')
    xticks([0, 500, 1000, 1500, 2000])
    xticklabels({'0', '500', '1000', '1500', '2000'})
    ylim([-1.3, 1.3])
    yticks([-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1])
    yticklabels({'-1', '-0.8', '-0.6', '-0.4', '-0.2', '0', '0.2', '0.4', '0.6', '0.8', '1'})
    text(-200,-1/2,'Against OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
    text(-200,1/2,'To OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
    for k = 1:5
        text((k-1)*500,1.2,['nall = ' num2str(n_f(k))],'HorizontalAlignment', 'center')
        text((k-1)*500,1.1,['nesc = ' num2str(n_f_ind(k))],'HorizontalAlignment', 'center')
        text((k-1)*500,1,['p = ' num2str(p_ind(k))],'HorizontalAlignment', 'center')
    end
    title({name [num2str(F.dpf) ' dpf - ' F.V ' Vpp']})
end

if F.dpf == 6
    plot(OMR, m_ind, '-ro')
    hold on
    errorbar(OMR, m_ind, std_ind, 'r')
    xlim([-300, 2300])
    plot(xlim, [0, 0], 'k')
    xticks([0, 500, 1000, 1500, 2000])
    xticklabels({'0', '500', '1000', '1500', '2000'})
    ylim([-1.3, 1.3])
    yticks([-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1])
    yticklabels({'-1', '-0.8', '-0.6', '-0.4', '-0.2', '0', '0.2', '0.4', '0.6', '0.8', '1'})
    text(-200,-1/2,'Against OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
    text(-200,1/2,'To OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
    for k = 1:5
        text((k-1)*500,1.2,['nall = ' num2str(n_f(k))],'HorizontalAlignment', 'center')
        text((k-1)*500,1.1,['nesc = ' num2str(n_f_ind(k))],'HorizontalAlignment', 'center')
        text((k-1)*500,1,['p = ' num2str(p_ind(k))],'HorizontalAlignment', 'center')
    end
    title({name [num2str(F.dpf) ' dpf - ' F.V ' Vpp']})
end

if F.dpf == 7
    plot(OMR, m_ind, '-bo')
    hold on
    errorbar(OMR, m_ind, std_ind, 'b')
    xlim([-300, 2300])
    plot(xlim, [0, 0], 'k')
    xticks([0, 500, 1000, 1500, 2000])
    xticklabels({'0', '500', '1000', '1500', '2000'})
    ylim([-1.3, 1.3])
    yticks([-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1])
    yticklabels({'-1', '-0.8', '-0.6', '-0.4', '-0.2', '0', '0.2', '0.4', '0.6', '0.8', '1'})
    text(-200,-1/2,'Against OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
    text(-200,1/2,'To OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
    for k = 1:5
        text((k-1)*500,1.2,['nall = ' num2str(n_f(k))],'HorizontalAlignment', 'center')
        text((k-1)*500,1.1,['nesc = ' num2str(n_f_ind(k))],'HorizontalAlignment', 'center')
        text((k-1)*500,1,['p = ' num2str(p_ind(k))],'HorizontalAlignment', 'center')
    end
    title({name [num2str(F.dpf) ' dpf - ' F.V ' Vpp']})
end