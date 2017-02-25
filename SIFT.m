I = imread('white_square.jpg');
imshow(I)
I = single(rgb2gray(I));
[f,d] = vl_sift(I);
perm = randperm(size(f,2));
sel = perm(1:22);
h1 = vl_plotframe(f(:,sel));
h2 = vl_plotframe(f(:,sel));
set(h1, 'color', 'k', 'linewidth', 0.75);
set(h2, 'color', 'r', 'linewidth', 0.5);

I1 = imread('SIFT1.png');
figure, imshow(I1)
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);
perm1 = randperm(size(f1,2));
sel1 = perm1(1:200);
g1 = vl_plotframe(f1(:,sel1));
g2 = vl_plotframe(f1(:,sel1));
set(g1, 'color', 'k', 'linewidth', 0.75);
set(g2, 'color', 'r', 'linewidth', 0.5);

I2 = imread('SIFT2.png');
figure, imshow(I2);
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);
perm2 = randperm(size(f2,2));
sel2 = perm2(1:200);
k1 = vl_plotframe(f2(:,sel2));
k2 = vl_plotframe(f2(:,sel2));
set(k1, 'color', 'k', 'linewidth', 0.75);
set(k2, 'color', 'r', 'linewidth', 0.5);