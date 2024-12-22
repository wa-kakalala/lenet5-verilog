function output = fc(input, w, b)
    % input: 输入数据，大小为 [batch_size, input_size]，已经展平
    % W: 权重矩阵，大小为 [output_size, input_size]
    % b: 偏置，大小为 [output_size, 1]
    % output: 输出数据，大小为 [batch_size, output_size]
    
    % 计算全连接层的输出
    % output = input * w' + b';  % 使用矩阵乘法并加上偏置
    output = integer_mtimes(input,w') + b';
end
