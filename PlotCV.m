%plot cv results 
x = linspace(-5,9,8);
y = linspace(-10,4,8);
figure
imagesc('XData',x,'YData',y,'CData',CVAccuracy);

%figure
%imagesc([2^-5 2^9],[2^-10 2^4],CVAccuracy)
%set(gca, 'XScale','log');
%set(gca,'XTick',x);
%set(gca, 'YScale','log');
%set(gca,'YTick',y);
colorbar;

%CVPlot = [Cgvalues,CVAccuracy'];
%figure;
%imagesc(CVPlot');
%colorbar;


