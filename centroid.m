function c = centroid(x,fs)
f(n) = n * fs / length(x);
c = sum((f(n)*x))/sum(x);
end