clear all
clc
%%%%%%%%%%%%%%%%%%%%% Step 1: data preparation
ForCNN_Path = 'D:\Data\Image\Biomedicine\integrated\MIAS_Patches\MIAS_B_M_Norm_Preprocess\MIAS_BMN_ForCNN_More'; 
sub_category = fullfile('./mias_preprocess_Part1/trainvaltest/val/Malignant/*.png'); % obtan
Img_sub_catgory = dir(sub_category);
row= 120;
col = 120;
patch_height = 72;
pathch_width = 72;

is_Visulize = 0; % 1:true, 0:false   
threshold_bg = 0; 

% the number for extracting small patch for each bigger patch
totalNum_eachPatch = 1000*2;

%%%%%%%%%%%%%%%%%%%%% Step 2: To extract 
sprintf(['Start to deal with the sub category: Malignant!\n'])
sub_len = length(Img_sub_catgory); %
for nn=1:sub_len
    sprintf(['Start to deal with the No.%d image!\n'],nn)  
    Imgpath = fullfile('./mias_preprocess_Part1/trainvaltest/val/Malignant', Img_sub_catgory(nn).name);    
    % read the image
     img_png = imread(Imgpath);
     img_png = imresize(img_png,[row,col]);

     % We aims to extract the patches with 224 * 224
     filename =  Img_sub_catgory(nn).name;
     [~,filename_only,~] = fileparts(filename);
      
     patch_count = 0;
     while patch_count < totalNum_eachPatch
         patch_count = patch_count+1;
         if rem(patch_count, 500) == 0
             sprintf(['Start to extract the No.%d patches!\n'],patch_count)
         end
         % extract the surrounding patches         
         range_h = row - patch_height;
         range_w = col - pathch_width;

         coor_x  = randperm(range_w,1);% obtain the top-left x location of cropped box
         coor_y = randperm(range_h,1);  % obtain the top-left y location of cropped box

        croppedImg = imcrop(img_png, [coor_x, coor_y, pathch_width-1, patch_height-1]);
        
        % save the small patch
         if ~exist(fullfile(ForCNN_Path, 'val/Malignant/'),'dir')
                 mkdir(fullfile(ForCNN_Path,'val/Malignant/')) 
         end     
        new_filepath = [ForCNN_Path,'/val/Malignant/', filename_only,'_',num2str(patch_count,'%04d'),'.png'];    
        imwrite(croppedImg,new_filepath);       
         
     end
end
sprintf(['This work ends!\n'])
