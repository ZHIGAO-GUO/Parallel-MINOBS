function x_sorted = CPS_index(CPS_num,Num_sample)

sigma = 0.5*Num_sample;
pd1 = makedist('HalfNormal','mu',0,'sigma',sigma);
x = 1:1:CPS_num;
pdf1 = pdf(pd1,x);
pdf_normalized = pdf1/sum(pdf1);

% rng('default')          % For reproducibility
x = sample_without_repetition(pdf_normalized, Num_sample);
x_sorted = sort(x);

if x_sorted(1) ~= 1
    x_sorted = [1 x_sorted];
end

if x_sorted(end) ~= CPS_num
    x_sorted = [x_sorted CPS_num];
end




