clear;
close all;

% 读取图片并转化为灰度图像
src = imread('cameraman.jpg');
mask = imread('lena.jpg');
src = rgb2gray(src);
mask = rgb2gray(mask);
[h_src, w_src] = size(src);
[h_mask, w_mask] = size(mask);

% 计算灰度直方图
% pdf_src = imhist(src);
% pdf_mask = imhist(mask);
pdf_src = zeros(1, 256);
pdf_mask = zeros(1, 256);

for x = 1 : h_src
    for y  = 1 : w_src
        pdf_src(src(x, y) + 1) = pdf_src(src(x, y) + 1) + 1;
    end
end

for x = 1 : h_mask
    for y  = 1 : w_mask
        pdf_mask(mask(x, y) + 1) = pdf_mask(mask(x, y) + 1) + 1;
    end
end

pdf_src = pdf_src / (h_src * w_src);
pdf_mask = pdf_mask / (h_mask * w_mask);

% 计算累积概率分布
% 使用cumsum函数计算累积和
cdf_src = cumsum(pdf_src);
cdf_mask = cumsum(pdf_mask);

% 使用组映射规则进行灰度映射
% 找到原始累计直方图中距离规定累积直方图灰度值最近的灰度值，将原始累计直方图该灰度值之前的灰度值都映射为该规定累计直方图灰度值
record = 1;   % 记录上一次映射的灰度级位置的下一个灰度
differ = zeros(256, 1);
dst = uint8(zeros(h_src, w_src));

for x = 1 : 256
    % 过滤规定直方图概率密度为0的灰度级
    if pdf_mask(x)
        for y = 1 : 256
            differ(y) = abs(cdf_mask(x) - cdf_src(y));
        end
        % 找到差值最小的灰度值位置，若存在多个结果表明有概率密度为0的位置，取最后一位
        gml = find(differ == min(differ));
        
        % 将上一次映射灰度级到本次灰度级之间的灰度进行映射
        for z = record : gml(end)
            % 找到原图中灰度值为z-1的所有像素，对应位置的灰度值都映射为x-1
            match = find(src == z - 1);
            dst(match) = x - 1;
        end
        record = gml(end) + 1;
    end
end

% 显示结果
subplot(3, 3, 1); imshow(src); title('原图');
subplot(3, 3, 2); imshow(mask); title('标准图');
subplot(3, 3, 3); imshow(dst); title('直方图规定化结果');

% 显示灰度直方图
subplot(3, 3, 4); imhist(src); title('原图直方图');
subplot(3, 3, 5); imhist(mask); title('标准直方图');
subplot(3, 3, 6); imhist(dst); title('直方图匹配到标准图');

% 显示灰度直方图
pdf_dst = imhist(dst) / numel(dst);
cdf_dst = cumsum(pdf_dst);
subplot(3, 3, 7); bar(cdf_src); title('原图累积直方图');
subplot(3, 3, 8); bar(cdf_mask); title('标准累积直方图');
subplot(3, 3, 9); bar(cdf_dst); title('直方图匹配到标准图');