clc;
close all;
load HouseTallBasler64;
% load affrec1;
% xpoints = W(1:NrFrames,:);
% ypoints = W(NrFrames+1:end,:);
% tx = mean(xpoints,2);
% ty = mean(ypoints,2);
% xs=bsxfun(@minus,xpoints,tx);
% ys=bsxfun(@minus,ypoints,ty);
% w = [xs;ys;];
t = mean(W, 2);
W = W - repmat(t, 1, size(W, 2));
[U, D, V] = svd(W);
M = U(:, 1:3)*sqrt(D(1:3, 1:3)); 
S = (D(1:3, 1:3))*V(:, 1:3)';


    
figure(1);
plot3(S(1, :), S(2,:), S(3,:),'*');
grid on;
title('Computed coordinates');
xlabel('x'); 
ylabel('y'); 
zlabel('z');
figure(2);
plot3(X(1, :), X(2,:), X(3,:),'*');
grid on;
title('Original');
xlabel('x'); 
ylabel('y'); 
zlabel('z');
