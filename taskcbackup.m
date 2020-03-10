function [] = taskc()
    clc;
    close all;
%     load HouseTallBasler64;
    load affrec1;
    m = size(W,1)/2;
    n = size(W,2);
     t = mean(W, 2);
     W = W - repmat(t, 1, size(W, 2));
     s = W.^2;
     s = s(1:m, :) + s(m+1:2*m, :);
     s = mean(s, 2);
     s = sqrt(s) / sqrt(2);
     W = W ./ repmat(s, 2, size(W, 2));

    U = W(1:m, :);
    V = W(m+1:end, :);
    for j=1:n
        for i=1:m
            x(i*3-2, j) = U(i, j);
            x(i*3-1, j) = V(i, j);
            x(i*3  , j) = 1;
        end
    end
%     for i=1:m
%         [x(i*3-2:i*3, :)] = normalise(x(i*3-2:i*3, :));
%     end

    [P, S, cond] = fsvd(x);
%     [P, S, cond] = fsvd(W);
    figure(1);
    plot3(S(1, :), S(2,:), S(3,:),'.');
%         plot3(S(1, :)./S(4,:), S(2,:)./S(4,:), S(3,:)./S(4,:),'*');
    grid on;
    title('Computed coordinates');
    xlabel('x'); 
    ylabel('y'); 
    zlabel('z');
    figure(2);
    plot3(X(1, :), X(2,:), X(3,:),'.');
    grid on;
    title('Original');
    xlabel('x'); 
    ylabel('y'); 
    zlabel('z');
end


function [newpts] = normalise(pts)

    finiteind = find(abs(pts(3,:)) > eps);
    

    pts(1,finiteind) = pts(1,finiteind)./pts(3,finiteind);
    pts(2,finiteind) = pts(2,finiteind)./pts(3,finiteind);
    pts(3,finiteind) = 1;
    
    c = mean(pts(1:2,finiteind)')';            % Centroid of finite points
    newp(1,finiteind) = pts(1,finiteind)-c(1); % Shift origin to centroid.
    newp(2,finiteind) = pts(2,finiteind)-c(2);
    
    meandist = mean(sqrt(newp(1,finiteind).^2 + newp(2,finiteind).^2));
    
    scale = sqrt(2)/meandist;
    
    T = [scale   0   -scale*c(1)
         0     scale -scale*c(2)
         0       0      1      ];
    
    newpts = T*pts;
end
function [Ps,Xs,cond,xs] = fsvd(xs)
    m = size(xs,1)/3;
    n = size(xs,2);

    lambda = ones(m,n);
    for it = 1:1
      for p = 1:n
        lp = lambda(:,p);
        lambda(:,p) = lp/norm(lp);
      end
      for i = 1:m
        li = lambda(i,:);
        lambda(i,:) = li/norm(li);
      end
    end

    for i = 1:m
      for p = 1:n
        xs(3*i-2:3*i,p) = lambda(i,p)*xs(3*i-2:3*i,p);
      end
    end
    [U,S,V] = svd(xs);
    S = S/S(1,1);
    cond = [S(4,4),S(5,5)];
    Ps = fliplr(U(:,1:4));  
    Xs = (-S(1:4,1:4)*V(:,1:4)');
end
