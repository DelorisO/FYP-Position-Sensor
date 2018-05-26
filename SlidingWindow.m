% Implementation of the sliding window function
function SW = SlidingWindow(y)
%Creating a function on which to test this with

%Created a mock function to deal with this

w=20;
counter = 0;

for k=1:5000
    w_y(k)=y(k);
    if mod(k,w) == 0
        %do processing function
        %SW(k+1-w:k) = 2*w_y(k+1-w:k);
        SW(k) = mean(w_y(k+1-w:k));
        counter = counter+1;
    end
end

end