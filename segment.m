function [labels] = segment(im, edgeGrad, fix_x, fix_y, opt)

verbose = false;

if nargin > 4
    if strcmp(opt, 'verbose')
        verbose = true;
    end
end

%% Energy fucntion parameters
if verbose
    fprintf('Computing binary weight matrix\n');
end

% Binary weights
nju = 5;                    
k = 20;                     
lambda = 1000;              

% Unary weights
D  = 1e100;                 % Fixation point unary weight
Z = 10;

unaryColourWeight = 1;      % Importance of colourmodel unary weights

foreground = 2;             
background = 1;            

%% Image parameters
[yRes, xRes] = size(edgeGrad);
nPix = xRes*yRes;

%% Compute binary weights
E = edges4connected(yRes,xRes);                                             % Indices of adjacent pixels (Potts model)

%1. Average edge probability at adjacent edges
I = edgeGrad(E(:,1))+edgeGrad(E(:,2)) / 2;                              
        
%2. Edge where at least one of the pixels belongs to the edge map
J = zeros(size(E,1),1);
J(I ~= 0) = exp( -nju*( I(I ~= 0) ));              
%3. Edges where none of the pixels belong to the edge map
J(I == 0) = k;                                                           

%4. Calculate the distance of each edge from the fixation point
[y, x] = ind2sub([yRes, xRes], E(:,1));                               
[y_new, x_new] = ind2sub([yRes, xRes], E(:,2));
x_midpoint = (x + x_new) / 2 - fix_x(1);
y_midpoint = (y + y_new) / 2 - fix_y(1);
s = sqrt(x_midpoint.^2 + y_midpoint.^2);

%5. Weights are the inverse of the distance from the fixation point
L = 1./s;
%6. Normalize the weights to have maximum of 1
L = L/max(L);  
J = J.*L;
P = sparse(E(:,1),E(:,2),J,nPix,nPix,4*nPix);

%%7. Construct unary weights for image boundary and fixation point 
O_ = zeros(numel(edgeGrad),2);
O_(1:yRes,background) = D;                                      % Left column
O_(end-yRes+1:end,background) = D;                              % Right column
O_((0:xRes-1)*yRes+1,background) =D;                                        % Top row
O_((1:xRes)*yRes,background) =D;                                            % Bottom row
O_(sub2ind([yRes, xRes], fix_y(1), fix_x(1)), foreground) = D;            % Fixation point
O_(sub2ind([yRes, xRes], fix_y(2:end), fix_x(2:end)), foreground) = Z;   % Fixation point
N = sparse(O_);

%%8. Perform min-cut using maxflow function.
[~, labels] = maxflow(P,N);
labels = reshape(labels, [yRes, xRes]);
labels = cleanupSegmentation(labels, fix_x(1), fix_y(1));

end