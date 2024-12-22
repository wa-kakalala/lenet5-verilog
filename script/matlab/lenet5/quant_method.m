function quant_parameters = quant_method( parameters )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% layer1
    conv1_weights_flat = zeros(5 *5 * 6+6);
    cnt = 1;
    for i = 1:6
        conv_flat = reshape(parameters.layer1.conv(i).weights, [], 1);
        for j = 1: size(conv_flat,1)
            conv1_weights_flat(cnt) = conv_flat(j);
            cnt = cnt + 1;
        end
    end

    % 展平偏置
    bias_flat = reshape(parameters.layer1.bias, [], 1);
    for j = 1: size(bias_flat,1)
        conv1_weights_flat(cnt) = bias_flat(j);
        cnt = cnt + 1;
    end
%     figure(1);
%     plot(conv1_weights_flat);
%     title("Layer1 Weights");
    fprintf("layer1 weights max: %.3f\n",max(max(conv1_weights_flat)));
    fprintf("layer1 weights min: %.3f\n",min(min(conv1_weights_flat)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% layer2
    conv2_weights_flat = zeros(5*5*3*6 + 5*5*4*9 + 5*5*6 + 16);
    cnt = 1;
    % 遍历第1到第6个卷积层的权重
    for i = 1:6
        for k = 0:2  % 每个卷积层有三个权重字段 weights_0, weights_1, weights_2
            weight_field = ['weights_' num2str(k)];
            conv_flat = reshape(parameters.layer2.conv(i).(weight_field), [], 1);
            for j = 1: size(conv_flat,1)
                conv2_weights_flat(cnt) = conv_flat(j);
                cnt = cnt + 1;
            end
        end
    end
    % 遍历第7到第15个卷积层的权重
    for i = 7:15
        for k = 0:3  % 每个卷积层有四个权重字段 weights_0, weights_1, weights_2, weights_3
            weight_field = ['weights_' num2str(k)];
            conv_flat = reshape(parameters.layer2.conv(i).(weight_field), [], 1);
            for j = 1: size(conv_flat,1)
                conv2_weights_flat(cnt) = conv_flat(j);
                cnt = cnt + 1;
            end
        end
    end
    % 处理第16个卷积层的权重，包含六个权重字段
    i = 16;
    for k = 0:5  % 每个卷积层有六个权重字段 weights_0, weights_1, ..., weights_5
        weight_field = ['weights_' num2str(k)];
        conv_flat = reshape(parameters.layer2.conv(i).(weight_field), [], 1);
        for j = 1: size(conv_flat,1)
            conv2_weights_flat(cnt) = conv_flat(j);
            cnt = cnt + 1;
        end
    end
    % 展平偏置
    bias_flat = reshape(parameters.layer2.bias, [], 1);
    for j = 1: size(bias_flat,1)
        conv2_weights_flat(cnt) = bias_flat(j);
        cnt = cnt + 1;
    end
    % 可视化处理结果
%     figure(2);
%     plot(conv2_weights_flat);
%     title("Layer2 Weights");

    % 打印最大值
    fprintf("layer2 weights max: %.3f\n", max(max(conv2_weights_flat)));
    fprintf("layer2 weights min: %.3f\n", min(min(conv2_weights_flat)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% layer3
    % 初始化一个一维数组来存储所有的权重和偏置
    % 120x256 + 120
    layer3_weights_flat = zeros(1, numel(parameters.layer3.weights) + numel(parameters.layer3.bias));
    % 通过循环展平并添加权重
    cnt = 1;
    weights_flat = reshape(parameters.layer3.weights, [], 1);
    for i = 1:length(weights_flat)
        layer3_weights_flat(cnt) = weights_flat(i);
        cnt = cnt + 1;
    end
    % 通过循环展平并添加偏置
    bias_flat = reshape(parameters.layer3.bias, [], 1);
    for i = 1:length(bias_flat)
        layer3_weights_flat(cnt) = bias_flat(i);
        cnt = cnt + 1;
    end
    % 可视化处理结果
%     figure(3);
%     plot(layer3_weights_flat);
%     title("Layer3 Weights");

    % 打印最大值
    fprintf("layer3 weights max: %.3f\n", max(layer3_weights_flat));
    fprintf("layer3 weights min: %.3f\n", min(layer3_weights_flat));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% layer4
    % 初始化一个一维数组来存储所有的权重和偏置
    layer4_weights_flat = zeros(1, numel(parameters.layer4.weights) + numel(parameters.layer4.bias));

    % 通过循环展平并添加权重
    cnt = 1;
    weights_flat = reshape(parameters.layer4.weights, [], 1);
    for i = 1:length(weights_flat)
        layer4_weights_flat(cnt) = weights_flat(i);
        cnt = cnt + 1;
    end

    % 通过循环展平并添加偏置
    bias_flat = reshape(parameters.layer4.bias, [], 1);
    for i = 1:length(bias_flat)
        layer4_weights_flat(cnt) = bias_flat(i);
        cnt = cnt + 1;
    end

    % 可视化处理结果
%     figure(4);
%     plot(layer4_weights_flat);
%     title("Layer4 Weights");

    % 打印最大值
    fprintf("layer4 weights max: %.3f\n", max(layer4_weights_flat));
    fprintf("layer4 weights min: %.3f\n", min(layer4_weights_flat));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% layer5
    % 初始化一个一维数组来存储所有的权重和偏置
    layer5_weights_flat = zeros(1, numel(parameters.layer5.weights) + numel(parameters.layer5.bias));

    % 通过循环展平并添加权重
    cnt = 1;
    weights_flat = reshape(parameters.layer5.weights, [], 1);
    for i = 1:length(weights_flat)
        layer5_weights_flat(cnt) = weights_flat(i);
        cnt = cnt + 1;
    end

    % 通过循环展平并添加偏置
    bias_flat = reshape(parameters.layer5.bias, [], 1);
    for i = 1:length(bias_flat)
        layer5_weights_flat(cnt) = bias_flat(i);
        cnt = cnt + 1;
    end

    % 可视化处理结果
%     figure(5);
%     plot(layer5_weights_flat);
%     title("Layer5 Weights");

    % 打印最大值
    fprintf("layer5 weights max: %.3f\n", max(layer5_weights_flat));
    fprintf("layer5 weights min: %.3f\n", min(layer5_weights_flat));
    
    % layer1 weights max: 0.490
    % layer1 weights min: -0.584
    % layer2 weights max: 0.559
    % layer2 weights min: -0.615
    % layer3 weights max: 0.708
    % layer3 weights min: -0.872
    % layer4 weights max: 0.583
    % layer4 weights min: -0.621
    % layer5 weights max: 0.279
    % layer5 weights min: -1.050  仅有极少的数
    quant_parameters = parameters;
    % quant_parameters fi 
    
    % 第1层：处理权重和偏置
    for i = 1:6
        quant_parameters.layer1.conv(i).weights = process_layer_data(quant_parameters.layer1.conv(i).weights);
    end
    quant_parameters.layer1.bias = process_layer_data(quant_parameters.layer1.bias);

    % 第2层：处理权重和偏置
    for i = 1:6
        for k = 0:2
            weight_field = ['weights_' num2str(k)];
            quant_parameters.layer2.conv(i).(weight_field) = process_layer_data(quant_parameters.layer2.conv(i).(weight_field));
        end
    end
    for i = 7:15
        for k = 0:3
            weight_field = ['weights_' num2str(k)];
            quant_parameters.layer2.conv(i).(weight_field) = process_layer_data(quant_parameters.layer2.conv(i).(weight_field));
        end
    end
    i = 16;
    for k = 0:5
        weight_field = ['weights_' num2str(k)];
        quant_parameters.layer2.conv(i).(weight_field) = process_layer_data(quant_parameters.layer2.conv(i).(weight_field));
    end
    quant_parameters.layer2.bias = process_layer_data(quant_parameters.layer2.bias);

    % 第3层：处理权重和偏置
    quant_parameters.layer3.weights = process_layer_data(quant_parameters.layer3.weights);
    quant_parameters.layer3.bias = process_layer_data(quant_parameters.layer3.bias);

    % 第4层：处理权重和偏置
    quant_parameters.layer4.weights = process_layer_data(quant_parameters.layer4.weights);
    quant_parameters.layer4.bias = process_layer_data(quant_parameters.layer4.bias);

    % 第5层：处理权重和偏置
    quant_parameters.layer5.weights = process_layer_data(quant_parameters.layer5.weights);
    quant_parameters.layer5.bias = process_layer_data(quant_parameters.layer5.bias);
end