A = [353 339 277; -103 23.3 459; 0.707 -0.353 0.612];
B = [1440000; -632000; -918];
C = -inv(A)*B

% Original data
P = [353 339 277 1440000; -103 23.3 459 -632000; 0.707 -0.353 0.612 -918];
M = P(:, 1:3);
% Compute the camera center
C = sym('[c1; c2; c3]');
f = M*C + P(:,4);
res = solve(f);
C_hat = ones(3, 1);
names = fieldnames(res);
for j = 1 : numel(names)
 C_hat(j) = res.(names{j});
end
% Compute the calibration matrix K by RQ decomposition
ReverseRows = [0 0 1; 0 1 0 ; 1 0 0];
[Q R] = qr((ReverseRows * M)');
K = ReverseRows * R' * ReverseRows;
R = ReverseRows * Q';
scale = K(3,3);
K(:,3) = K(:, 3) ./ scale;
R(3,:) = R(3, :) .* scale;
