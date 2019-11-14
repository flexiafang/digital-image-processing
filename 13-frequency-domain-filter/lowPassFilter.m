clear;
close all;

% 读取图像
src = imread('lena.jpg');
gray = rgb2gray(src);

% 傅里叶变换
grayfft = fft2(gray);
grayfftshift = fftshift(grayfft);

% 计算频域数据
[M, N] = size(grayfftshift);     % 频域尺寸
m = fix(M/2);
n = fix(N/2);
[u, v] = meshgrid(-M/2 : M/2 - 1, -N/2 : N/2 - 1);   % 生成频域网格
d = sqrt(u.^2 + v.^2);  % 计算频域各点到频域中心的距离
d0 = 50;    % 截止频率

% 理想低通滤波
% for i = 1 : M
%     for j = 1 : N
%         
%         if d <= d0
%             h = 1;
%         else
%             h = 0;
%         end
%         ideal(i, j) = h * grayfftshift(i, j);     % 计算滤波结果
%     end
% end
h_ideal = double(d <= d0);    % 计算转移函数
ideal = h_ideal .* grayfftshift;
ideal = uint8(real(ifft2(ifftshift(ideal))));

% 巴特沃斯低通滤波
order = 4;  % 4阶巴特沃斯低通滤波
% for i = 1 : M
%     for j = 1 : N
%         d = sqrt((i - m)^2 + (j - n)^2);    % 计算当前频值与频域中心的距离
%         h = 1 / (1 + (d / d0)^(2 * order));     % 计算巴特沃斯低通滤波器的转移函数
%         btw(i, j) = h * grayfftshift(i, j);     % 计算滤波结果
%     end
% end
h_btw = 1 ./ (1 + (d ./ d0).^(2 * order));
btw = h_btw .* grayfftshift;
btw = uint8(real(ifft2(ifftshift(btw))));

% 高斯低通滤波
h_gauss = exp(-(d.^2)./(2 * (d0^2)));
gauss = h_gauss .* grayfftshift;
gauss = uint8(real(ifft2(ifftshift(gauss))));

% 显示结果
subplot(2,2,1), imshow(gray), title('原图');
subplot(2,2,2), imshow(ideal), title('理想低通滤波');
subplot(2,2,3), imshow(btw), title('巴特沃斯低通滤波');
subplot(2,2,4), imshow(gauss), title('高斯低通滤波');