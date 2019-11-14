clear;
close all;

% 读取图片后转换成灰度图片
src = imread('lena.jpg');
gray = rgb2gray(src);

% 对图片进行傅里叶变换
gray_fft = fft2(gray);
% 对频谱取模并进行缩放
grayfft = log(abs(gray_fft) + 1);

% 将频谱中零频率分量移动至频谱中心 [1,2;3,4] --> [4,3;2,1]
gray_fft_shift = fftshift(gray_fft);
% 对频移后的频谱取模并缩放
grayfftshift = log(abs(gray_fft_shift) + 1);

% 傅里叶反变换，频域变换到空域，并取实部
dst = real(ifft2(ifftshift(gray_fft_shift)));

% 显示傅里叶变换结果
subplot(2, 2, 1), imshow(src), title('原图');
subplot(2, 2, 2), imshow(grayfft, []), title('傅里叶频谱');
subplot(2, 2, 3), imshow(grayfftshift, []), title('频移后的傅里叶频谱');
subplot(2, 2, 4), imshow(dst, []), title('傅里叶反变换结果');