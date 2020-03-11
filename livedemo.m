function [] = task4()
    clc;
    close all;
    success = mexMTF2('init','pipeline v img_source f')
    [~, first_frame] = mexMTF2('get_frame');
    figure;
    imshow(first_frame);
    hold on
    NrPoints = 8;
    [x,y]=ginput(NrPoints);
    counter = 1;
    tracker1 = mexMTF2('create_tracker','mtf_sm esm mtf_am ssd mtf_ssm 6', cat(2,x(1:4),y(1:4))');
    tracker2 = mexMTF2('create_tracker','mtf_sm esm mtf_am ssd mtf_ssm 6', cat(2,x(5:end),y(5:end))');
    NrFrames = 50;
    W(counter,:) = x;
    W(counter+NrFrames,:) = y;
    close all;
    while counter<NrFrames
%         [~, current_frame] = mexMTF2('get_frame');
        [~, corners1] = mexMTF2('get_region', tracker1);
        [~, corners2] = mexMTF2('get_region', tracker2);
%         drawregion(current_frame, corners(1,:), corners(2,:), counter);
        counter = counter+1;
        W(counter,:) = [corners1(1,:) corners2(1,:)];
        W(counter+NrFrames,:) = [corners1(2,:) corners2(2,:)];
        pause(1);
    end
    
        t = mean(W, 2);
        W = W - repmat(t, 1, size(W, 2));
        [U, D, V] = svd(abs(W));
        M = U(:, 1:3)*sqrt(D(1:3, 1:3)); 
        S = sqrt(D(1:3, 1:3))*V(:, 1:3)';
        close all
        figure(1);
        plot3(S(1, :), S(2,:), S(3,:),'o');
        grid on;
        title('Computed coordinates');
        xlabel('x'); 
        ylabel('y'); 
        zlabel('z');
%     save('custom.mat','W', 'NrPoints', 'NrFrames');
end
