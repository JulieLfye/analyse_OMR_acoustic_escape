function [] = plot_OMR_acoustic(Lr, Ll, nbL, nbR, Rr, Rl, ang_b, ang_esc,...
    F, mL, mR)

figure
% ----- plot without considering angle to OMR before escape
subplot(1,2,1)
stem([-pi/2 pi/2],[-size(Lr,2)/nbL size(Rl,2)/nbR],'k')
hold on
stem([-pi/2 pi/2],[size(Ll,2)/nbL -size(Rr,2)/nbR],'r')
plot([-pi/2 pi/2], [mL mR], 'b*')
ylim([-1,1])
xlim ([-pi pi])
plot([0 0],ylim,'k')
xticks([-pi/2 pi/2])
xticklabels({'Left side to OMR','Right side to OMR'})
yticks([-0.5 0.5])
yticklabels({'Turn right','Turn left'})
ytickangle(90)
dpf = ['dpf = ' num2str(F.dpf)];
text(2,0.7, dpf)
text(2,0.6, ['V = ', F.V])
plot(linspace(-pi,pi),sin(linspace(-pi,pi)),':b')

% ----- plot by considering angle to OMR before escape
p = 20*pi/180;
edges = -pi:p:pi;
center = -pi+p/2:p:pi-p/2;

ang = ang_b-pi;
i = 1;
p = nan(1,18);
subplot(1,2,2)
while i <= 18
    f = find(ang >= edges(i) & ang < edges(i+1));
    if isempty(f) == 0
        p(i) = sum(sign(ang_esc(f)))/(nbL+nbR);
        if center (i) < 0
            if p(i) >= 0
                stem(center(i),p(i),'r');
                hold on
            elseif p(i) < 0
                stem(center(i),p(i),'k');
                hold on
            end
        elseif center(i) > 0
            if p(i) <= 0
                stem(center(i),p(i),'r');
                hold on
            elseif p(i) > 0
                stem(center(i),p(i),'k');
                hold on
            end
        end
    end
    i = i+1;
end
xlim ([-pi pi])
plot([0 0],ylim,'k')
xticks([-pi -pi/2 0 pi/2 pi])
xticklabels({'\pi','\pi/2','0','-\pi/2','-\pi'})
ylabel('Turn left               Turn righ')
% ytickangle(90)
y = ylim;
plot(linspace(-pi,pi),y(2)*sin(linspace(-pi,pi)),':b')

% subplot(1,2,2)
% stem(ang_b(Lr)-pi,sign(ang_esc(Lr))*0.8,'k')
% hold on
% stem(ang_b(Ll)-pi,sign(ang_esc(Ll))*0.8,'r')
% stem(ang_b(Rr)-pi,sign(ang_esc(Rr))*0.8,'r')
% stem(ang_b(Rl)-pi,sign(ang_esc(Rl))*0.8,'k')
% ylim([-1,1])
% xlim ([-pi pi])
% plot([0 0],ylim,'k')
% xticks([-pi -pi/2 0 pi/2 pi])
% xticklabels({'\pi','\pi/2','0','-\pi/2','-\pi'})
% yticks([-0.5 0.5])
% yticklabels({'Turn right','Turn left'})
% ytickangle(90)