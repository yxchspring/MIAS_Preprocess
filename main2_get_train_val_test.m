clear all
clc
ForCNN_Path = './mias_preprocess_Part1/trainvaltest'; 
% reference: https://blog.csdn.net/qq_39516859/article/details/81844162
categories_all = dir('./mias_preprocess_Part1/original');

for ii=1:length(categories_all)
    if(isequal(categories_all(ii).name,'.' ) ||  isequal(categories_all(ii).name,'..' ) || ~ categories_all(ii).isdir) % skip the .,.., and non dir
        continue;
    end
    sub_category = fullfile('./mias_preprocess_Part1/original', categories_all(ii).name,'*.png'); % obtan
    png_sub_catgory = dir(sub_category);
    
    sprintf(['Start to deal with the sub category:',categories_all(ii).name,'\n'])    
    sub_len = length(png_sub_catgory); %
    for nn=1:sub_len
        rng('default')
        smp_num = randperm(sub_len);
        pngpath = fullfile('./mias_preprocess_Part1/original', categories_all(ii).name,png_sub_catgory(smp_num(nn)).name);
%         pngpath = fullfile('./mias_preprocess_Part1', categories_all(ii).name, [categories_all(ii).name,'_',png_sub_catgory(smp_num(nn)).name]);
        
        %%%%%%%%%%%%%%%%%%%% Part 1: Extract the train set
        if nn <= ceil(sub_len*0.6)
             %%%%%%%%%%%%%%%%%%%% Part 1.1: Obtain the training set for CNN
             if ~exist(fullfile( ForCNN_Path,'/train',categories_all(ii).name),'dir')
                 mkdir(fullfile( ForCNN_Path,'/train',categories_all(ii).name)) 
             end      
             copyfile(pngpath,fullfile( ForCNN_Path,'/train', categories_all(ii).name,[categories_all(ii).name,'_',png_sub_catgory(smp_num(nn)).name]));   
        end         
       %%%%%%%%%%%%%%%%%%%% Part 2: Extract the val set
        if nn >ceil(sub_len*0.6) &&  nn <= ceil(sub_len*0.8)
             %%%%%%%%%%%%%%%%%%%% Part 1.1: Obtain the training set for CNN
             if ~exist(fullfile( ForCNN_Path,'/val',categories_all(ii).name),'dir')
                 mkdir(fullfile( ForCNN_Path,'/val',categories_all(ii).name)) 
             end      
             copyfile(pngpath,fullfile( ForCNN_Path,'/val', categories_all(ii).name,[categories_all(ii).name,'_',png_sub_catgory(smp_num(nn)).name]));   
        end   
        %%%%%%%%%%%%%%%%%%%% Part 3: Extract the test set
         if nn > ceil(sub_len*0.8) 
              %%%%%%%%%%%%%%%%%%%% Part 3.1: Obtain the validation set for CNN
             if ~exist(fullfile( ForCNN_Path,'/test',categories_all(ii).name),'dir')
                 mkdir(fullfile( ForCNN_Path,'/test',categories_all(ii).name)) 
             end      
             copyfile(pngpath,fullfile( ForCNN_Path,'/test', categories_all(ii).name,[categories_all(ii).name,'_',png_sub_catgory(smp_num(nn)).name]));                      
        end      
        
    end
    
end
sprintf('The work for extracting fifteen dataset is completed!\n')





