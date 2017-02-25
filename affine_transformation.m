function Affine = affine_transformation(bestF1,bestF2)
% This function computes the affine transformation from given points.

% bestF1 and bestF2 consist of the best sorted features of the two images.
Image1 = [bestF1(1,1); 
          bestF1(2,1);
          bestF1(1,2);
          bestF1(2,2);
          bestF1(1,3);
          bestF1(2,3)];  

        
Image2 = [bestF2(1,1) bestF2(2,1) 0  0  1  0;
          0  0  bestF2(1,1) bestF2(2,1) 0 1;
          bestF2(1,2) bestF2(2,2) 0  0  1  0;
          0  0  bestF2(1,2) bestF2(2,2) 0 1; 
          bestF2(1,3) bestF2(2,3) 0 0 1 0;
          0  0 bestF2(1,3) bestF2(2,3) 0 1]; 
      
 %Affine is the affine matrix, representing rotations and translations.
 %It is derived from the formula Image2 * Affine = Image1.
 %where Image1 is a 6x1 matrix and Image2 is a 6x6 matrix.
          Affine = Image2\Image1 ;  