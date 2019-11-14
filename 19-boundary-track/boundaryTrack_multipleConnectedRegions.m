clear;
close all;

% 读取二值图像
src = imread('rice-bw.png');
[h, w] = size(src);

% 在图像最外围加一圈黑边，使所有的连通区域都包含在图像内部
h = h + 2;
w = w + 2;
img = zeros(h, w);
img(2 : h - 1, 2 : w - 1) = src;

% 边界标记图像
edge = zeros(h, w);

% 相对邻域坐标，搜索方向为顺时针，左上方像素开始
directs = [-1, -1; 0, -1; 1, -1; 1, 0; 1, 1; 0, 1; -1, 1; -1, 0];

% 边界标记
for i = 2 : h -1
    for j = 2 : w - 1
        if img(i, j) == 1   % 如果当前像素是前景像素
            neighbour = [i, j] + directs;   % 计算当前像素的所有八邻域像素
            for k = 1 : 8   % 遍历当前像素的八邻域
                pix = neighbour(k, :);
                if img(pix(1), pix(2)) == 0     % 如果邻域像素是背景像素
                    edge(pix(1), pix(2)) = 1;   % 边界标记图像相应像素进行标记
                end
            end
        end
    end
end

% 减去加上的最外围边缘
edge = edge(2 : h - 1, 2 : w - 1);

% 显示结果
subplot(1, 2, 1), imshow(src), title('原图');
subplot(1, 2, 2), imshow(edge), title('边界跟踪标记');