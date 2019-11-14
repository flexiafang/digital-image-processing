clear;
close all;

% 读取图片
img = imread("lena.jpg");
%img = rgb2gray(img);

if numel(size(img)) > 2     % 彩色图片
    [h, w, d] = size(img);
    flag = 1;
else    % 灰度图片
    [h, w] = size(img);
    flag = 0;
end

angle = 30;     % 逆时针旋转角度
theta = angle / 180 * pi;

% 计算旋转矩阵和逆矩阵
rot = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
inv_rot = rot';     % 旋转变换的反变换矩阵

% 计算旋转后图像的尺寸 [height, width]
% height = round(h * abs(cos(theta)) + w * abs(sin(theta)));
% width = round(h * abs(sin(theta)) + w * abs(cos(theta)));
newsize = round([h, w] * abs([sin(theta), cos(theta); cos(theta), sin(theta)]));
height = newsize(1);
width = newsize(2);

% 创建新图像
if flag
    dst1 = uint8(zeros(height, width, d));
    dst2 = uint8(zeros(height, width, d));
else
    dst1 = uint8(zeros(height, width));
    dst2 = uint8(zeros(height, width));
end

% 根据反变换矩阵，求出旋转后图像的每个像素对应的原图像像素位置，并将灰度值填充
for x = 1 : height
    for y = 1 : width
        pixel = [x-height/2, y-width/2, 1] * inv_rot;
        
        % 最近邻插值
        m = round(pixel(1) + h/2);
        n = round(pixel(2) + w/2);
        if m > 0 && m <= h && n > 0 && n <= w
            if flag
                dst1(x, y, :) = img(m, n, :);
            else
                dst1(x, y) = img(m, n);
            end
        end
        
        % 双线性插值
        x_small = floor(pixel(1)) + h/2;
        x_large = ceil(pixel(1)) + h/2;
        y_small = floor(pixel(2)) + w/2;
        y_large = ceil(pixel(2)) + w/2;
        if x_small >0 && x_large <= h && y_small > 0 && y_large <= w
            if flag
                point1 = img(x_small, y_small, :) + (img(x_large, y_small, :) - img(x_small, y_small, :)) * (pixel(1) - x_small);
                point2 = img(x_small, y_large, :) + (img(x_large, y_large, :) - img(x_small, y_large, :)) * (pixel(1) - x_small);
                point3 = point1 + (point2 - point1) * (pixel(2) - y_small);
                dst2(x, y, :) = point3;
            else
                point1 = img(x_small, y_small) + (img(x_large, y_small) - img(x_small, y_small)) * (pixel(1) - x_small);
                point2 = img(x_small, y_large) + (img(x_large, y_large) - img(x_small, y_large)) * (pixel(1) - x_small);
                point3 = point1 + (point2 - point1) * (pixel(2) - y_small);
                dst2(x, y) = point3;
            end
        end        
    end
end

subplot(131), imshow(img), title('原图');
subplot(132), imshow(dst1), title('最近邻插值旋转图');
subplot(133), imshow(dst2), title('双线性插值旋转图');