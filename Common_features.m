%f1, f2 represent the features and d1,d2 represent the descriptors.
I1 = imread('SIFT1.png');
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);

I2 = imread('SIFT2.png');
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);

total(225000) = 0;
d1=double(d1);
d2=double(d2);
B = zeros(225000,3);
l = 1;
for i=1:500
    for j=1:450
        s = 0;
        for k = 1:128
            s = s + (d2(k,i)-d1(k,j))^2;
        end
        total(l) = s;
        B(l,1:3) = [s i j];
        l = l+1;
    end
end
% Sorting of descriptors done in order to match them with respective
% indices.
A = sortrows(B,1);
C = A((1:3),:);

%common features selected.
v1 = f1(:,C(1,3));
for i = 2:3
    v1 = [v1 f1(:,C(i,3))];
end
v2 = f2(:,C(1,2));
for i = 2:3
    v2 = [v2 f2(:,C(i,2))];
end

perm = [1 2 3];
color = ['w' 'g' 'b'];

I1 = imread('SIFT1.png');
imshow(I1)
for i = 1:3;
    sel = perm(i);
    g1 = vl_plotframe(v1(:,sel));
    g2 = vl_plotframe(v1(:,sel));
    set(g1, 'color', 'k', 'linewidth', 3);
    set(g2, 'color', color(i), 'linewidth', 1);
end
I2 = imread('SIFT2.png');
figure, imshow(I2)
 for i = 1:3;
    sel = perm(i);
    h1 = vl_plotframe(v2(:,sel));
    h2 = vl_plotframe(v2(:,sel));
    set(h1, 'color', 'k', 'linewidth', 3);
    set(h2, 'color', color(i), 'linewidth', 1);
 end
