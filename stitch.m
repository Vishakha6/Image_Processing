function stitch(J, K, A)

R = A(1,3); A(1,3) = A(2,3); A(2,3) = R;
sizeJ = size(J); sizeK = size(K);

X_Y(:,1) = round(A*[0;0;1]);
X_Y(:,2) = round(A*[size(K,1);0;1]);
X_Y(:,3) = round(A*[0;size(K,2);1]);
X_Y(:,4) = round(A*[size(K,1);size(K,2);1]);
X_min = min(X_Y(1,:)); Y_min = min(X_Y(2,:));
R1 = 0; R2 = 0;
if X_min<0
    R1 = X_min;
end
if Y_min<0
    R2 = Y_min;
end
for i = 1:sizeJ(1)
    for j = 1:sizeJ(2)
        stitchedI(i-R1, j-R2) = J(i,j);
    end
end
for i = 1:sizeK(1)
    for j = 1:sizeK(2)
        
        X_Y = round(A*[i; j; 1]);
        if X_Y(1) < sizeJ(1) && X_Y(2) < sizeJ(2)
            stitchedI(X_Y(1)-R1, X_Y(2)-R2) = K(i,j);
        end
    end
end
% sizeI = size(stitchedI);
figure, imshow(stitchedI, [])
end