function c = centroid(x,fs)
fn = n * fs / length(x);
c = sum((fn*x))/sum(x);
end