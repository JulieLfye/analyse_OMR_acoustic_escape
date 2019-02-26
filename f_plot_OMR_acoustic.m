function [] = f_plot_OMR_acoustic(Lr, Ll, nbL, nbR, Rr, Rl, ang_b, ang_esc,...
    mL, mR)

figure
% ----- plot without considering angle to OMR before escape
subplot(1,2,1)
% good turn
stem([-pi/2 pi/2],[-size(Lr,2)/nbL size(Rl,2)/nbR],'b')
hold on
% wrong turn
stem([-pi/2 pi/2],[size(Ll,2)/nbL -size(Rr,2)/nbR],'r')
plot([-pi/2 pi/2], [mL mR], 'k*')
ylim([-1,1])
xlim ([-pi pi])
plot([0 0],ylim,'k')
xticks([-pi/2 pi/2])
xticklabels({'Left side to OMR','Right side to OMR'})
yticks([-0.5 0.5])
yticklabels({'Turn right','Turn left'})
ytickangle(90)
% dpf = ['dpf = ' num2str(F.dpf)];
% text(2,0.7, dpf)
% text(2,0.6, ['V = ', F.V])
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
        p(i) = sum(sign(ang_esc(f)))/(nbL+nbR); % mean of turn
        
        if center (i) < 0 % left side
            if p(i) >= 0 % left turn - wrong
                plot(center(i),p(i),'k*');
                hold on
            elseif p(i) < 0 % right turn - good
                plot(center(i),p(i),'k*');
                hold on
            end
            % left turn - wrong
            a = find(ang_esc(f) > 0);
            if isempty(a) == 0
                stem(center(i), size(a,2)/(nbL+nbR), 'r');
            end
            % right turn - good
            a = find(ang_esc(f) <= 0);
            if isempty(a) == 0
                stem(center(i), -size(a,2)/(nbL+nbR), 'b');
            end
            
        elseif center(i) > 0 % right side
            if p(i) <= 0 % right turn - good
                plot(center(i),p(i),'k*');
                hold on
            elseif p(i) > 0 % left turn - wrong
                plot(center(i),p(i),'k*');
                hold on
            end
            % right turn - wrong
            a = find(ang_esc(f) <= 0);
            if isempty(a) == 0
                stem(center(i), -size(a,2)/(nbL+nbR), 'r');
            end
            % left turn - good
            a = find(ang_esc(f) > 0);
            if isempty(a) == 0
                stem(center(i), size(a,2)/(nbL+nbR), 'b');
            end
        end
    end
    i = i+1;
end
xlim ([-pi pi])
y = ylim;
plot(linspace(-pi,pi),y(2)*sin(linspace(-pi,pi)),':b')
plot([0 0],ylim,'k')
xticks([-pi -pi/2 0 pi/2 pi])
% xticklabels({'0','90','180','270','360'})
xticklabels({'\pi','\pi/2','0','-\pi/2','-\pi'})
ylabel('Turn right                    Turn left')
% ytickangle(90)


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