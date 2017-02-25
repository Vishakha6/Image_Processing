%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RANSAC 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
%input both images and extract SIFT features for them. 
Image1 = imread('SIFT1.png');
Image1 = single(rgb2gray(Image1));
[features1,descriptor1] = vl_sift(Image1);
descriptor1=double(descriptor1);
Image2 = imread('SIFT2.png');
Image2 = single(rgb2gray(Image2));
[features2,descriptor2] = vl_sift(Image2);
descriptor2=double(descriptor2);
%% 
% f = zeros(size(features1,2),1);
%calculating SSD and sorting features matrix according to the matching
%descriptors and image index.
Features = zeros(size(features2,2),5);
for i = 1:size(features2,2)
    counter = 9999999;
    compare = 10;
    for j = 1:size(features1,2)
        SSD = 0;
        for k = 1:128
            SSD = SSD + (descriptor1(k,j)-descriptor2(k,i))^2;
        end
        if SSD < counter
           counter = SSD;
           compare = j;
        end
    end
    Features(i,1) = features2(1,i);
    Features(i,2) = features2(2,i);
    Features(i,3) = features1(1,compare);
    Features(i,4) = features1(2,compare);
    Features(i,5) = counter;
end
%% 
Temp_ = sortrows(Features,5);
Temp = Temp_';

NewF1 = Temp(3:4, :);
NewF2 = Temp(1:2, :);

Euclidean_Counter = zeros(1,1000);
limit = 0;
for best_count = 1:1000
%%
%Taking 3 random features to compute Affine Transform.
r = randi([1 379],1,3);
bestF1 = NewF1(:,r);
bestF2 = NewF2(:,r);

%Computing Affine Transform with "affine_transformation" function.
Affine = affine_transformation(bestF1,bestF2);
Affine = reshape(Affine,[2,3]);

%Converting to Homogeneous form to apply the 2x3 Affine Transform. 
X = [NewF1(1, 1:379)' NewF1(2, 1:379)']; 
Y = [NewF2(1, 1:379)' NewF2(2, 1:379)' ones(1,379)'];
X = X';
Y = Y';
NewY = Affine*Y;
%% 
%Calculating Euclidean distance from the best matching features.
%Comparing if any pair has distance less than 2
%Storing them for best count

for i=1:379
    
            Z1 = ((NewY(1,i) - X(1,i)))^2;   
            Z2 = ((NewY(2,i) - X(2,i)))^2; 
            Z = sqrt(Z1+Z2);
            if Z < 2
                Euclidean_Counter(best_count) = Euclidean_Counter(best_count) + 1;
                
            else
            end
end

%Using the best count to determine best affine transform.
if Euclidean_Counter(best_count) > limit
   limit = Euclidean_Counter(best_count);
   best_affine = Affine;
end
end
Euclidean_Counter = sort(Euclidean_Counter, 'descend');

Affine1 = [1 0 100; 0 1 0;];
Affine2 = [0.8*cos(pi/16) -0.8*sin(pi/16) 100; 0.8*sin(pi/16) 0.8*cos(pi/16) 50];
%Using the best affine transform to accurately stitch the images.
stitch(Image1, Image2, best_affine)
title('final stitch');
stitch(Image1, Image2, Affine1)
stitch(Image1, Image2, Affine2)
