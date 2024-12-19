function output = relu(input)
    % 输入 input 为 Cout x C x H x W 的四维数组
    % 输出 output 是经过 ReLU 激活函数处理后的四维数组，保持相同的尺寸
    output = max(0, input);  % 对输入数组的每个元素应用 ReLU
end
