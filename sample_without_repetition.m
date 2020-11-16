function sample = sample_without_repetition(pdf,Num)

Sampl_num_initial = 5*Num;
sample_initial = discretesample(pdf, Sampl_num_initial);
[u,ib,ic] = unique(sample_initial,'stable');
Uniques = u(1:min(Num,length(u)));
if length(Uniques) > Num || length(Uniques) == Num 
    Position = find(sample_initial == Uniques(Num));
    sample = unique(sample_initial(1:Position(1)));
else
    while length(Uniques) < Num
        Num_new = Sampl_num_initial+Num;
        sample_new = discretesample(pdf, Num_new);
        Uniques = unique(sample_new,'stable');
    end
    Position = find(sample_new == Uniques(Num));
    sample = unique(sample_new(1:Position(1)));
end

        


