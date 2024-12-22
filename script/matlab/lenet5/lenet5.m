function [precision,number] = lenet5(img,parameters)
    %%%%%%%%%% layer1 conv
    layer1_weight = zeros(6,1,5,5);
    for i = 1 : 6
        layer1_weight(i,1,:,:) = parameters.layer1.conv(i).weights;
    end
    layer1_bias = parameters.layer1.bias;
   
    layer1 =  conv2d( reshape(img, [1, size(img)]),layer1_weight,layer1_bias,0,1);
    %%%%%%%%%% relu + maxpool
    layer1_relu = relu(layer1);
    layer1_mp = maxpool(layer1_relu,2,2);

    %%%%%%%%%% layer2 conv
    fm_mapping = {
        [0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 0], [5, 0, 1], ... 
        [0, 1, 2, 3],[1, 2, 3, 4],[2, 3, 4, 5],[3, 4, 5, 0],  [4, 5, 0, 1], [5, 0, 1, 2],[0, 2, 4, 1], [1, 3, 5, 0],[2, 4, 0, 1], ... 
        [0, 1, 2, 3, 4, 5]
    };
    layer2 = zeros(16,8,8);
    for i = 1 : 16
        map = fm_mapping{i};
        conv_weights = zeros(1,length(map),5,5);
        
        conv_weights(1,1,:,:) = parameters.layer2.conv(i).weights_0;
        conv_weights(1,2,:,:) = parameters.layer2.conv(i).weights_1;
        conv_weights(1,3,:,:) = parameters.layer2.conv(i).weights_2;

        if length(map) == 4
            conv_weights(1,4,:,:) = parameters.layer2.conv(i).weights_3;    
        elseif length(map) == 6
            conv_weights(1,4,:,:) = parameters.layer2.conv(i).weights_3;
            conv_weights(1,5,:,:) = parameters.layer2.conv(i).weights_4;
            conv_weights(1,6,:,:) = parameters.layer2.conv(i).weights_5;
        else 

        end

        % 获取对应的特征图，并将它们存储到 selected_feature_maps 中
        fm = layer1_mp(map+1, :, :);  % +1 因为 MATLAB 索引从 1 开始

        bias = parameters.layer2.bias(i);

        layer2(i,:,:) =  conv2d( fm,conv_weights,bias,0,1);
    end

    %%%%%%%%%% relu + maxpool
    % layer2_relu = relu(layer2);
    layer2_mp = maxpool(layer2,2,2);

    %%%%%%%%%% layer3 fc
    layer3_weight = parameters.layer3.weights;
    layer3_bias = parameters.layer3.bias;

    layer2_mp_view = zeros(1,numel(layer2_mp));
    [layer2_c,layer2_h,layer2_w] = size(layer2_mp);
    cnt = 1;
    for i = 1:layer2_c
        for j = 1:layer2_h
            for k = 1:layer2_w
                layer2_mp_view(1,cnt) = layer2_mp(i,j,k);
                cnt = cnt + 1;
            end
        end
    end

    layer3 = fc(layer2_mp_view,layer3_weight,layer3_bias);
    layer3_relu = relu(layer3);

    %%%%%%%%%% layer4 fc
    layer4_weight = parameters.layer4.weights;
    layer4_bias = parameters.layer4.bias;
    layer4 = fc(layer3_relu,layer4_weight,layer4_bias);
    layer4_relu = relu(layer4);

    %%%%%%%%%% layer3 fc
    layer5_weight = parameters.layer5.weights;
    layer5_bias = parameters.layer5.bias;
    layer5 = fc(layer4_relu,layer5_weight,layer5_bias);
    
%     disp("result:");
%     disp(layer5);
    [precision,number] = max(layer5);  % 返回最大值和最大值的索引
end