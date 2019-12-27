############################## 1. data ##############################
1.1 The original MIAS dataset
You should download the dataset and extract it to the current path, like ./all-mias



Please refer to the following URL for the original data provided.
http://peipa.essex.ac.uk/pix/mias/all-mias.tar.gz
https://www.repository.cam.ac.uk/handle/1810/250394?show=full
Paper for the data source: 
SUCKLING J, P. (1994). The mammographic image analysis society digital mammogram database. Digital Mammo, 375-386.

############################## 2. codes ##############################
2.1 Extract the ROIs
a) Extract ROIs for Benign: main1_B_Part1_extract_ROIs.m
b) Extract ROIs for Malignant: main1_M_Part1_extract_ROIs.m
c) Extract ROIs for Normal: main1_Norm_Part1_extract_ROIs.m

2.2 Split the dataset into train, val, and test sets.
main2_get_train_val_test.m

2.3 Randomly extract the patches from the ROIs for training set
a) main3_B_train_Part2_extract_patches.m
b) main3_M_train_Part2_extract_patches.m
c) main3_Norm_train_Part2_extract_patches.m

2.4 Randomly extract the patches from the ROIs for validation set
a) main4_B_val_Part2_extract_patches.m
b) main4_M_val_Part2_extract_patches.m
c) main4_Norm_val_Part2_extract_patches.m

2.5 Randomly extract the patches from the ROIs for testing set
a) main5_B_test_Part2_extract_patches.m
b) main5_M_test_Part2_extract_patches.m
c) main5_Norm_test_Part2_extract_patches.m

2.6 Extract patches for one whole ROI wiht 50% overlap by sliding window:
main6_test_image_extract_patches_overlap05.m

############################## 3. Other notes ##############################

If you find this research useful, please cite our paper.
Xiangchun Yu 1, Wei Pang 2, Qing Xu 1,* and Miaomiao Liang 1,*, Mammographic Image Classification with Deep Fusion Learning.

If you have any question, please contact us below.
Xiangchun Yu: yuxc@jxust.edu.cn