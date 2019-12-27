% obtain the patches for each image
clear all;
% main_dir = 'E:\RstudioProjects\Biomedical\Images\breasthistology\normalized\Reinhard';
main_dir = './mias_preprocess_Part1/trainvaltest';

ForCNN_Path = 'D:\Data\Image\Biomedicine\integrated\MIAS_Patches\MIAS_B_M_Norm_Preprocess\MIAS_BMN_ForCNN_More'; 
subfold ={'Benign','Malignant','Normal'};

if ~exist(fullfile(ForCNN_Path, 'test_image/Benign/'),'dir')
     mkdir(fullfile(ForCNN_Path,'test_image/Benign/')) 
end 
if ~exist(fullfile(ForCNN_Path,'test_image/Malignant/'),'dir')
     mkdir(fullfile(ForCNN_Path,'test_image/Malignant/')) 
end
if ~exist(fullfile(ForCNN_Path, 'test_image/Normal/'),'dir')
     mkdir(fullfile(ForCNN_Path,'test_image/Normal/')) 
end
%% Step 1: read the all files from folder 'test'
test_dir = fullfile(main_dir,'test');
patch_height = 72;
pathc_width = 72;
for cls_subfold = 1:3
    %disp(subfold)
    directory = fullfile(test_dir,subfold{cls_subfold});
    %directory = test_dir;
    dirs=dir([directory,'.\*.png']);%dirs结构体类型,不仅包括文件名，还包含文件其他信息。
    dircell=struct2cell(dirs)'; %类型转化，转化为元组类型
    filenames=dircell(:,1) ;%文件类型存放在第一列
    [n m] = size(filenames);%获得大小
    for i = 1:n      
     if ~isempty( strfind(filenames{i}, '.png') )%筛选出tif文件
         filename = filenames{i};
         filepath = fullfile(directory,filename);
         % read the image
         img_png = imread(filepath);
     %          img_png = imresize(img_png,[384,510]);
         row= 120;
         col = 120;
         steps_row =12;
         steps_col = 12;
         % We aims to extract the patches with 224 * 224
          [~,filename_only,~] = fileparts(filename);
         patch_count = 0;
         % ref:
         % https://www.mathworks.com/matlabcentral/answers/115653-how-to-divide-the-image-into-overlapping-blocks
         % https://www.mathworks.com/matlabcentral/answers/297762-divide-an-image-to-overlapped-blocks
         % https://www.mathworks.com/matlabcentral/answers/333847-how-to-convert-image-into-overlapping-blocks
         for m=1:steps_row:row-patch_height+1
             for n=1:steps_col:col-pathc_width+1
                 patch_count = patch_count + 1;
                 % obtian the corresponding patch
                 block=img_png(m:m+patch_height-1, n:n+pathc_width-1,:);
                 %%% for CNN
%                  imwrite(block,[main_dir,'\Reinhard_Patches_CNN\test\Initial\',subfold{cls_subfold},'\',filename_only,'_',num2str(patch_count),'.png']) 
                 %%% for BOF
                 imwrite(block,[ForCNN_Path,'\test_image\',subfold{cls_subfold},'\',filename_only,'_',num2str(patch_count,'%02d'),'.png']) 
             end
         end
         disp(['The patches extraction for ',filename,' has been completed!']);
     end
    end
    disp(['The assignment for ',subfold{cls_subfold},' has been completed!']);
    
end


