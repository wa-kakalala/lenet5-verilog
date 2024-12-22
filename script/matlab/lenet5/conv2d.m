function output = conv2d(fm, weight, bias, padding, stride)
    % fm: 输入特征图 (C x H x W)
    % weight: 卷积核 (Cin x Kh x Kw x Cout)
    % bias: 偏置 (1 x Cout)
    % padding: 填充大小 (1x2，表示上下和左右的填充)
    % stride: 步长 (1x1)

    % 获取输入特征图和卷积核的尺寸
    [C, H, W] = size(fm); % 输入特征图的尺寸
    [Cout,Cin, Kh, Kw] = size(weight); % 卷积核的尺寸

    % 判断卷积核的输入通道数与输入特征图的通道数是否匹配
    if Cin ~= C
        error('卷积核的输入通道数与输入特征图的通道数不匹配！');
    end

    % 在输入特征图上进行填充
    fm_padded = padarray(fm, [padding, padding], 0, 'both');
    % 计算输出特征图的尺寸
    H_out = floor((H + 2*padding - Kh) / stride) + 1;
    W_out = floor((W + 2*padding - Kw) / stride) + 1;

    % 初始化输出特征图
    output = zeros(Cout, H_out, W_out);

    % 执行卷积操作
    for i = 1:H_out
        for j = 1:W_out
            for k = 1:Cout
                % 计算卷积区域的左上角位置
                row_start = (i - 1) * stride + 1;
                row_end = row_start + Kh - 1;
                col_start = (j - 1) * stride + 1;
                col_end = col_start + Kw - 1;
                
                % 提取当前卷积窗口
                conv_region = fm_padded(:, row_start:row_end, col_start:col_end);
                % 卷积操作：加权求和并加上偏置
                w_shape = size( weight(k,:, :, :));
                new_weight = reshape(weight(k,:, :, :),[w_shape(2),w_shape(3),w_shape(4)]);
%                 disp( class( conv_region ) );
%                 disp( class( new_weight ) );
                output(k, i, j) = sum(sum(sum(conv_region .* new_weight))) + bias(k);
            end
        end
    end
end
