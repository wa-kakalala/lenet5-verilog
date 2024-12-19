% parameters = load_weights();
% img = imread('./image/9/test_img_9992.png');
% if size(img, 3) == 3
%     img = rgb2gray(img);  % 将彩色图片转换为灰度图像
% end
% 
% [precision,number] = lenet5(double(img) / 255 ,parameters);
%   
% fprintf("precision : %f, number: %d\r\n",precision,number-1);
% imshow(img);

parameters = load_weights();
base_dir = './image/';
corrects = 0;
total = 0;
for idx = 1:9
    path = [base_dir num2str(idx) './'];
    files = dir(fullfile(path, '*.png'));
    total = total + length(files);
    for i = 1:length(files)
        file_name = fullfile(path, files(i).name);  % 添加文件路径
        img = imread(file_name);
        if size(img, 3) == 3
            img = rgb2gray(img);  % 将彩色图片转换为灰度图像
        end
        [~,number] = lenet5(double(img) / 255 ,parameters);
        if( number-1 == idx )
            corrects = corrects +1;
        end
    end
end
fprintf(" acc: %.2f \r\n",double(corrects)/total);