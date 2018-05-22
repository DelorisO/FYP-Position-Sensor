% Implementation of the sliding window function

%Creating a function on which to test this with

y = linspace(0,5000,5001);
x = y;

scatter(x,y);

%Created a mock function to deal with this

w=20;
counter = 0;

for k=1:5000
    w_y(k)=y(k);
    if mod(k,w) == 0
        %do processing function
        w_yi(k+1-w:k) = 2*w_y(k+1-w:k);
        counter = counter+1;
    end
end

plot(w_yi);