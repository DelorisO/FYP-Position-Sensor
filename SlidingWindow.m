% Implementation of the sliding window function
%function SW = SlidingWindow(y)
y = linspace(1,10000,10000)';
y = [y,y+(0.4*rand([10000 1]))];
y = [y,y+(0.4*rand([10000 1]))];
y = [y,y+(0.4*rand([10000 1]))];
y = [y,y+(0.4*rand([10000 1]))];
counter = 1;
humanrate = 25; % 25 to get every 1 second what position it is)

for k=1:length(y)
    if  mod(k,humanrate) == 0
        %do processing function
        %SW(k+1-w:k) = 2*w_y(k+1-w:k);
        SW(counter,:) = mean(y(k+1-humanrate:k,:));
        counter = counter+1;
    end
end

%end