function [] = f_plot_new_OMR_acoustic(OMR, m_ind, std_ind, n_f, n_f_ind, p_ind, F, name)

if F.dpf == 7
    color = 'b';
elseif F.dpf == 6
    color = 'r';
elseif F.dpf == 5
    color = 'k';
end

figure
hold on
mk = size(OMR,2);
plot(OMR,m_ind,'-o','Color',color,'MarkerFace',color)
errorbar(OMR, m_ind, std_ind,'Color',color)
xlim([-300, 2300])
plot(xlim, [0, 0], 'k')
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
ylim([-1.3, 1.3])
yticks([-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1])
yticklabels({'-1', '-0.8', '-0.6', '-0.4', '-0.2', '0', '0.2', '0.4', '0.6', '0.8', '1'})
text(-200,-1/2,'Against OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
text(-200,1/2,'To OMR', 'rotation', 90, 'HorizontalAlignment', 'center')
xlabel('OMR duration (ms)')
ylabel('PI')
for k = 1:mk
    if isempty(n_f) == 0
        text((k-1)*500,1.2,['nall = ' num2str(n_f(k))],'HorizontalAlignment', 'center')
    end
    if isempty(n_f_ind) == 0
        text((k-1)*500,1.1,['n_{esc} = ' num2str(n_f_ind(k))],'HorizontalAlignment', 'center')
    end
    if isempty(p_ind) == 0
        if p_ind(k) < 0.001
            if m_ind(k) < 0
                text((k-1)*500,m_ind(k)-(std_ind(k)+0.2),'***','Color',color,...
                    'HorizontalAlignment', 'center','Fontsize',20)
            else
                text((k-1)*500,m_ind(k)+(std_ind(k)+0.2),'***','Color',color,...
                    'HorizontalAlignment', 'center','Fontsize',20)
            end
        elseif p_ind(k) < 0.01
            if m_ind(k) < 0
                text((k-1)*500,m_ind(k)-(std_ind(k)+0.2),'**','Color',color,...
                    'HorizontalAlignment', 'center','Fontsize',20)
            else
                text((k-1)*500,m_ind(k)+(std_ind(k)+0.2),'**','Color',color,...
                    'HorizontalAlignment', 'center','Fontsize',20)
            end
        elseif p_ind(k) < 0.05
            if m_ind(k) < 0
                text((k-1)*500,m_ind(k)-(std_ind(k)+0.2),'*','Color',color,...
                    'HorizontalAlignment', 'center','Fontsize',20)
            else
                text((k-1)*500,m_ind(k)+(std_ind(k)+0.2),'*','Color',color,...
                    'HorizontalAlignment', 'center','Fontsize',20)
            end
        end
    end
end
title({name [num2str(F.dpf) ' dpf - ' F.V ' Vpp']})