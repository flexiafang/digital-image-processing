clear;
close all;

% 读取二值图像
img = imread('rice-bw.png');
img = double(img);
subplot(1, 2, 1), imshow(img), title('原图');

% 创建标记图像
[height, width] = size(img);
connected = zeros(height, width);   % 标记后的图
queue = [];     % 存储可能为当前连通域成员的点坐标
label = 1;  % 标记值，从1开始标记
offsets = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];   % 相对邻域中心的邻域坐标

for i = 1:height
    for j = 1:width
        if img(i, j) == 1 && connected(i, j) == 0
            connected(i, j) = label;
            if isempty(queue)
                queue = [i; j];
            else
                queue = [queue, [i; j]];
            end
            while ~isempty(queue)
                pix = [queue(1, 1), queue(2, 1)];
                % 邻域搜索
                for k = 1 : 8
                    neighbour = pix + offsets(k, :);   % 计算邻域坐标
                    if neighbour(1) >= 1 && neighbour(1) <= height && neighbour(2) >= 1 && neighbour(2) <= width
                        if img(neighbour(1), neighbour(2)) == 1 && connected(neighbour(1), neighbour(2)) == 0
                            connected(neighbour(1), neighbour(2)) = label;
                            queue = [queue, [neighbour(1); neighbour(2)]];  % 邻域坐标入队
                        end
                    end
                end
                queue(:, 1) = [];   % 首元素出队，即pix点出队，遍历队列中下一个点的邻域
            end
            label = label + 1;  % 标记加1，进行下一个区域的搜索
        end
    end
end

% 显示标记结果
connected = mat2gray(connected);
subplot(1, 2, 2), imshow(connected), title('连通区域标记结果');