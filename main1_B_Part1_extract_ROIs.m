clear all
clc
%% Step1: read the images and conduct preprocessing operation
% Get the filepath
pgm_path = './all-mias';
% Intialize the variables
threshold_bg = 20; 
Img_width = 1024;
Img_height = 1024;
% crop_w = 140*2;
% crop_h = 140*2;
crop_w = 120;
crop_h = 120;
is_Visulize = 1; % 1:true, 0:false   
cur_repeat = 1; 

% read the Benign labels information
[filenames,~,~, labels,x,y,radius] = textread('data_B_labels.txt','%s%s%s%s%d%d%d');

if ~exist(fullfile('./mias_preprocess_Part1/original','Benign'),'dir')
    mkdir(fullfile('./mias_preprocess_Part1/original','Benign')) 
end

% read the images and conduct median filter and background removal
files_len = length(filenames);
sprintf(['Start to read the pgm files:','\n'])
for nn=1:files_len
    if mod(nn,10)==0
        sprintf(['Start to read the NO.',num2str(nn),' files!\n'])
    end    
     %% 1) read the nn pgm 
     file_nn_name = [filenames{nn},'.pgm'];
     pgmpath = fullfile(pgm_path,file_nn_name);     
     Img_old = imread(pgmpath);   
     if is_Visulize
         figure(1),
         imshow(Img_old);
         title('Original image');
         impixelinfo;     
     end
     
       %% 2) conduct median filter firstly
     Img_medfilt = medfilt2(Img_old);   
      if is_Visulize
          figure(2),
          imshow(Img_medfilt);
          title('Median filter');
          impixelinfo;            
      end
      
     %% 3) conduct histogram equalization
%      Img_hist = histeq(Img_medfilt);
%      ADAPTHISTEQ
      Img_hist = adapthisteq(Img_medfilt);
     if is_Visulize
         figure(3),
         imshow(Img_hist)
         title('histogram equalization');
         impixelinfo;  
     end
        
    %% 4) Extract the ROIs
    % transform the coordination into the top-left form
    Img = Img_hist;
    figure(6),
    imshow(Img)
    title('Extract the ROIs');
    title(file_nn_name);
    impixelinfo;   
    coor_x = x(nn)-round(crop_w/2); % obtain the top-left x location of cropped box
    coor_y = Img_height-y(nn)-round(crop_h/2); % obtain the top-left y location of cropped box    
    croppedImg = imcrop(Img, [coor_x,coor_y,crop_w-1,crop_h-1]);
    imrect(gca, [coor_x,coor_y,crop_w-1,crop_h-1]);%      
    
    % plot the rectangle for the original position
    coor_x_r = x(nn)-round(radius(nn)/2); % obtain the top-left x location of cropped box
    coor_y_r = Img_height-y(nn)-round(radius(nn)/2);
    rectangle('position',[coor_x_r,coor_y_r,radius(nn)-1,radius(nn)-1],'curvature',[0,0],'edgecolor','r');
    pause(2)% sleep 2 seconds
    
    if is_Visulize
        figure(4),
        imshow(croppedImg)
        title('Extract the ROIs');       
        impixelinfo;   
    end    
      
   %% 5) remove the background
     foreground = croppedImg > threshold_bg; % Or whatever.
     foreground = bwareaopen(foreground, 1500); % or whatever.
     labeledImage = bwlabel(foreground);
     measurements = regionprops(labeledImage, 'BoundingBox');
     if isempty(measurements) % Judge this struct type variable is empty or not.
         croppedImg_foreg = croppedImg;
     else
         BBox = measurements.BoundingBox;
         croppedImg_foreg = imcrop(croppedImg, BBox);
     end     
     if is_Visulize
         figure(5),
         imshow(croppedImg_foreg);
         title('Remove background');
         impixelinfo;
     end    
    croppedImg_foreg = imresize(croppedImg_foreg, [crop_h, crop_w]);
     %% 6) save the croppedImg_foreg
     
     idx_dot = strfind(file_nn_name,'.');
     curFileName =  file_nn_name(1:idx_dot-1);
     
     % When nn==2, the following codes run.     
     if nn >=2 
         % initialize the  flag_same
         if strcmp(curFileName, filenames{nn-1})
             flag_same = 1;          
         else
             flag_same = 0;
         end
         % if flag_same is equal to 1, please add the suffix '_1,2,3' to
         % its name.
         if  flag_same ==1
             cur_repeat = cur_repeat +1;
             imgname = ['Benign_', curFileName, '_', num2str(cur_repeat)];
             imwrite(croppedImg_foreg,['./mias_preprocess_Part1/original/Benign/',imgname,'.png']);     
         else
             imgname = ['Benign_', curFileName];
             imwrite(croppedImg_foreg,['./mias_preprocess_Part1/original/Benign/',imgname,'.png']);
             cur_repeat = 1;
         end  
     % when nn=1   
     else
             imgname = ['Benign_', curFileName];
             imwrite(croppedImg_foreg,['./mias_preprocess_Part1/original/Benign/',imgname,'.png']);
     end
end
sprintf(['This work ends!\n'])


