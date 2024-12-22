% 函数：将数据限制到(-1, 1)区间并转化为定点表示
function fixed_point_data = process_layer_data(data)
    % 定义定点数据类型
    word_length = 8; % 总位宽，1位符号位 + 0位整数位 + 7位小数位
    frac_length = 7; % 小数位长度
    % 限制数据到(-1, 1)区间
    data(data > 1) = 0.99999;
    data(data < -1) = -0.99999;
    
    % 使用 fi 函数进行定点表示（1位符号位，0位整数位，7位小数位）
    fixed_point_data = fi(data, 1, word_length, frac_length);
end