function plotwMarks(x,y,s,color)

plot(x,y,'.-','LineWidth',2)
for i=1:length(s)
    line([x(s(i)) x(s(i))],[min(min(y)) max(max(y))],...
        'LineWidth',3,'Color',[.8 .8 .8],'LineStyle','--')
    text(x(s(i)),1.01*max(max(y)),num2str(i),...
        'FontSize',16,'FontWeight','Bold','HorizontalAlignment','Center')
end
set(gca,'FontSize',20,'FontWeight','Bold')
return