clear;
close all;

I = imread('rice-bw.png');%读入图像
[h, w] = size(I);
bw = bwlabel(I); %用连通区域来辅助标记

boundaries = cell(0,0);     % 保存多条边界
direction = [-1, 0; -1, 1; 0, 1; 1, 1; 1, 0; 1, -1; 0, -1; -1, -1];    %方向为顺时针

% 起始记录：起始点，以及起点下一个边界点
% 当循环到同一个起始点且下一个边界点相同时，此边界跟踪完成
flag = [];
judge_flag = [];

for i = 1 : h
    for j = 1 : w
        if bw(i, j) >= 1           
            flag = [i, j, -100, -100];
            label = bw(i, j);    % 连通域标记
            start = 1;    % 起始搜索方向
            point = [i, j;];    % 用来存放坐标点
            judge_flag = [-100, -100, -100, -100];
            get_next = 0 ;  %是否获取到起始点后的下一个边界点       
            center_x = i;
            center_y = j;

        while ~isequal(flag, judge_flag) 
            k = start;
            while(1)                       
                %(x,y)为周围的相邻像素坐标
                x = center_x + direction(k, 1);
                y = center_y + direction(k, 2);
                %判断坐标是否越界
                if x >0  && x <= h && y > 0 && y <= w
                    if bw(x, y) == label  %找到下一个边界点
                        center_x = x;
                        center_y = y;
                        point = [point; [x, y]]; 
                        judge_flag = [i, j, x, y];
                        if get_next == 0    %确定起始点及其方向
                            flag(3) = x;
                            flag(4) = y;
                            get_next = 1;
                            judge_flag = [];
                        end
                        break;  %已经找到边界点，跳出点周围搜索，进行下一点的边界点搜索
                    end
                end
                k = mod(k, 8) + 1;
            end
            %下一个边界点的搜索方向
            start = mod((k + 4), 8) + 1;
        end
        
        boundaries = [boundaries, point];
        bw = bw - (bw == label) * label;
    end
end

end

imshow(label2rgb(I, @gray, [.5 .5 .5]))%显示图像
hold on
for k = 1 : length(boundaries)
	boundary = boundaries{k};
	plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2)
end%整个循环表示的是描边