function [] = task4()
    clc;
    close all;
    success = mexMTF2('init','pipeline v img_source f')
    [~, first_frame] = mexMTF2('get_frame');
    figure;
    imshow(first_frame);
    hold on
    NrPoints = 4;
    [x,y]=ginput(NrPoints);
    p1 = [x(1) y(1)];
    p2 = [x(2) y(2)];
    p3 = [x(3) y(3)];
    p4 = [x(4) y(4)];
    plot([p1(1) p2(1)], [p1(2) p2(2)], 'r');
    plot([p3(1) p4(1)], [p3(2) p4(2)], 'r');
    counter = 1;
    tracker = mexMTF2('create_tracker','mtf_sm esm mtf_am ssd mtf_ssm 6', cat(2,x,y)');
    NrFrames = 10;
    W(counter,:) = x;
    W(counter+NrFrames,:) = y;
    while counter<=NrFrames
        [~, current_frame] = mexMTF2('get_frame');
        [~, corners] = mexMTF2('get_region', tracker);
        drawregion(current_frame, corners(1,:), corners(2,:), counter);
        counter = counter+1;
        W(counter,:) = corners(1,:);
        W(counter+NrFrames,:) = corners(2,:);
        pause(1);
    end
    save('custom.mat','W', 'NrPoints', 'NrFrames');
end

function [] = drawregion(image, x,y, counter)
    imshow(image);
    hold on;
    p1 = [x(1) y(1) 1];
    p2 = [x(2) y(2) 1];
    p3 = [x(3) y(3) 1];
    p4 = [x(4) y(4) 1];
    plot([p1(1) p2(1)], [p1(2) p2(2)], 'b');
    plot([p3(1) p4(1)], [p3(2) p4(2)], 'b');
    drawnow;
    hold off;
    saveas(gcf,['syn' num2str(counter) '.png']);
end