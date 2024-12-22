function C = integer_mtimes(A, B)
    [m, n] = size(A);
    [n2, p] = size(B);
    
    if n ~= n2
        error('矩阵维度不匹配');
    end
    
    C = zeros(m, p);  % 创建一个 int8 类型的结果矩阵
    
    for i = 1:m
        for j = 1:p
            sum = 0;  % 初始化一个 int8 类型的求和变量
            for k = 1:n
                sum = sum + A(i,k) * B(k,j);  % 逐元素求和
            end
            C(i,j) = sum;  % 将结果存储到 C
        end
    end
end