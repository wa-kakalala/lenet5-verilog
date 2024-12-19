function output = maxpool(input, pool_size, stride)
    % input: Cout x C x H x W 输入数据
    % pool_size: 池化窗口大小 [pool_height, pool_width]
    % stride: 步幅（stride）
    
    % 获取输入尺寸
    [C, H, W] = size(input);
    pool_height = pool_size;
    pool_width = pool_size;
    
    % 计算输出的尺寸
    out_H = floor((H - pool_height) / stride) + 1;
    out_W = floor((W - pool_width) / stride) + 1;
    
    % 初始化输出数组
    output = zeros(C, out_H, out_W);
    
    % 对每个输出通道和输入通道进行池化操作
    for c = 1:C
        for h = 1:out_H
            for w = 1:out_W
                % 计算池化区域的索引
                h_start = (h - 1) * stride + 1;
                w_start = (w - 1) * stride + 1;
                h_end = h_start + pool_height - 1;
                w_end = w_start + pool_width - 1;

                % 提取当前池化窗口区域
                region = input(c, h_start:h_end, w_start:w_end);

                % 计算池化区域的最大值
                output(c, h, w) = max(max(region));
            end
        end
    end
end
