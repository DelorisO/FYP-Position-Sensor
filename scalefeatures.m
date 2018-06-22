function new_f = scalefeatures(f)
%scales features along columns
[rows, cols] = size(f);
min_work=min(f);
max_work=max(f);

for i = 1:rows
    for j = 1:cols
        new_f(i,j) = (f(i,j)-min_work(j))/(max_work(j)-min_work(j));
    end
end

end