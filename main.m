% clc
% clear
profile on
tic
% '16-test'; '16-train'; '16-valid'; '17-test'; '17-train'; '17-valid';
% '16-test'; '16-train'; '16-valid'; '17-test'; '17-train'; '17-valid'; '64-kdd-test'; '64-kdd-train'; '64-kdd-valid'; '69-plants.test'; '69-plants.train'; '69-plants.valid'; '100-baudio-test'; '100-baudio-train'; '100-baudio-valid'; '100-bnetflix-test'; '100-bnetflix-train'; '100-bnetflix-valid';
%     '100-jester-test'; '100-jester-train'; '100-jester-valid'; '111-accident-test'; '111-accident-train'; '111-accident-valid'
% '135-tretail-test'; '135-tretail-train'; '135-tretail-valid'; '163-pumsb_star.test'; '163-pumsb_star.train'; '163-pumsb_star.valid'; '180-dna.test'; '180-dna.train'; '180-dna.valid'; '190-kosarek.test'; '190-kosarek.train'; '190-kosarek.valid';
% '294-msweb.test';'294-msweb.train';'294-msweb.valid'; '500-book.test';'500-book.train';'500-book.valid';'500-tmovie.test';'500-tmovie.train';'500-tmovie.valid';'839-cwebkb.test';'839-cwebkb.train';'839-cwebkb.valid';'889-cr52.test';'889-cr52.train';'889-cr52.valid';'910-c20ng.test';'910-c20ng.train';'910-c20ng.valid';'1058-bbc.test';
% '1058-bbc.train';'1058-bbc.valid';'1556-ad.test';'1556-ad.train';'1556-ad.valid';
Sets_num = 10;
filename_set = {'910-c20ng.test';}
%     '910-c20ng.valid';'1058-bbc.test';
% '1058-bbc.train';'1058-bbc.valid';'1556-ad.test';'1556-ad.train';'1556-ad.valid';}
% Rate = [0.01 0.1];
Rate = 0.10;
for f = 1:length(filename_set)
    filename = filename_set{f};
%     tic
    data = dlmread([filename, '.jkl']);
    Node_num = data(1,1);
%     toc
%     data_pro = Score_convert(data_pro);
%     [Node_num,Node_loc,Node_info,Cell] = index_identification(data_pro);
    
    for r = 1:length(Rate)
        Index_sum = cell(Sets_num,Node_num);
        parfor Iter = 1:Sets_num
            fid=fopen([filename, '-prunded-',num2str(Rate(r)),'-prunded-',num2str(Iter),'.jkl'],'w');
            fprintf(fid,'%d\n',Node_num); 
            if Iter == 1
%% *****************  Not sample from the distribution ****************
                for i = 1:Node_num
                    position = find(data(:,1)==(i-1) & data(:,2)>0);
                    CPS_num = data(position,2);
                    if CPS_num < 50
                        Index = 1:CPS_num;
                        CPS_new = data(position(1)+Index,:); 
                    else
                        Sample_CPS_num = round(CPS_num*Rate(r));
                        Index = 1:Sample_CPS_num;
                        Index = [Index CPS_num];
                        CPS_new = data(position+Index,:); 
                    end
                    Index_sum{Iter,i} = Index;
                    fprintf(fid,'%d ',i-1);
                    fprintf(fid,'%d\n',length(Index));
                    for j = 1:size(CPS_new,1)
                        temp = CPS_new(j,:);  
                        if temp(2) == 0                                        % candidate without parents
                            fprintf(fid,'%10.8f ',temp(1));
                            fprintf(fid,'%d\n',temp(2));
                        else                                                   % candidate with parents
                            fprintf(fid,'%10.8f ',temp(1));
                            fprintf(fid,'%d ',temp(2:(2+temp(2)-1)));
                            fprintf(fid,'%d\n',temp(2+temp(2)));
                        end
                    end
                end
            else
%% *****************  Sample from the distribution ****************
                for i = 1:Node_num
                    position = find(data(:,1)==(i-1) & data(:,2)>0);
                    CPS_num = data(position,2);
                    if CPS_num < 50
                        Index = 1:CPS_num; 
                    else
                        Sample_CPS_num = round(CPS_num*Rate(r));
                        Index = CPS_index(CPS_num,Sample_CPS_num);
                    end
                    Index_sum{Iter,i} = Index;
                    CPS_new = data(position+Index,:);
                    fprintf(fid,'%d ',i-1);
                    fprintf(fid,'%d\n',length(Index));
                    for j = 1:size(CPS_new,1)
                        temp = CPS_new(j,:);  
                        if temp(2) == 0                                        % candidate without parents
                            fprintf(fid,'%10.8f ',temp(1));
                            fprintf(fid,'%d\n',temp(2));
                        else                                                   % candidate with parents
                            fprintf(fid,'%10.8f ',temp(1));
                            fprintf(fid,'%d ',temp(2:(2+temp(2)-1)));
                            fprintf(fid,'%d\n',temp(2+temp(2)));
                        end
                    end
                end
            end
        end
    end
end
toc

profile viewer

y_range = 100;
for Iter = 1:Sets_num
    figure(Iter*2-1)
    for i = 1:Node_num
        x = i*ones(1,length(Index_sum{Iter,i}));
        y = Index_sum{Iter,i};
        plot(x,y,'*');
        hold on
    end
%     axis([0 Node_num+1 0 y_range])
    grid on
    set(figure(Iter*2-1), 'unit', 'normalized', 'position', [0,0,1,1]);
    
    figure(Iter*2)
    for i = 1:Node_num
        temp1 = Index_sum{Iter,i};
        temp2 = 1:temp1(end);
        y = setdiff(temp2,Index_sum{Iter,i});
        x = i*ones(1,length(y));
        plot(x,y,'*');
        hold on
    end
%     axis([0 Node_num+1 0 y_range])
    grid on
    set(figure(Iter*2), 'unit', 'normalized', 'position', [0,0,1,1]);
end

Sum = 0;
for i = 1:Node_num
    temp = Index_sum{1,i};
    if temp(end)>100
        Sum = Sum + 100;
    else
        Sum = Sum + temp(end);
    end       
end


R1 = zeros(Sets_num,Node_num);
R2 = zeros(Sets_num,Node_num);
for Iter = 2:Sets_num
    Sum_new_1 = 0;
    Sum_new_2 = 0;
    for i = 1:Node_num
        Sum_new_1 = Sum_new_1 + sum(Index_sum{Iter,i}<101);
        temp1 = Index_sum{Iter,i};
        temp2 = 1:temp1(end);
        y = setdiff(temp2,Index_sum{Iter,i});
        Sum_new_2 = Sum_new_2 + sum(y<101);
        R1 (Iter,i) = sum(Index_sum{Iter,i}<101);
        R2 (Iter,i) = sum(y<101);
    end
    rate_1 = Sum_new_1/Sum;
    rate_2 = Sum_new_2/Sum;
end
        





    
    
    








