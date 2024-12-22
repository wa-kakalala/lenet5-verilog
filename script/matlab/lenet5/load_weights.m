%{
save format: 
parameters.layer1
    conv(1).weights
    conv(2).weights
    conv(3).weights
    conv(4).weights
    conv(5).weights
    conv(6).weights
    bias   
parameters.layer2
    conv(1) ~ conv(6)
        weights_0
        weights_1
        weights_2
    conv(7) ~ conv(15)
        weights_0
        weights_1
        weights_2
        weights_3
    conv(16)
        weights_0
        weights_1
        weights_2
        weights_3
        weights_4
        weights_5
    bias  
parameters.layer3
    weights
    bias
parameters.layer4
    weights
    bias
parameters.layer5
    weights
    bias
%}

function parameters = load_weights()
    %%%%%%%%%%%%% load first layer : 
    %%% conv 6x5x5 
    file_id = fopen('./weights/float/1_conv1.weight.txt', 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error('无法打开文件,1_conv1.weight.txt');
    end
    for i = 1:6
        parameters.layer1.conv(i).weights  = fscanf(file_id,"%f",[5,5])';
    end
    fclose(file_id);
    % disp(parameters.layer1.conv(6).weights);
    %%% bias 6x1
    file_id = fopen('./weights/float/2_conv1.bias.txt', 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error('无法打开文件,2_conv1.bias.txt');
    end

    parameters.layer1.bias  = fscanf(file_id,"%f",[6,1]);
    fclose(file_id);
    %fisp(parameters.layer1.bias);
    
    %%%%%%%%%%%%% load second layer : 
    %%% conv 3x5x5  0~5 
    start = 3;
    for i = 1:6
        file_name = ['./weights/float/' num2str(start) '_c3.convs.' num2str(i - 1) '.weight.txt'];
        file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
        % 检查文件是否成功打开
        if file_id == -1
            error(['无法打开文件,' file_name]);
        end
        parameters.layer2.conv(i).weights_0  = fscanf(file_id,"%f",[5,5])';
        parameters.layer2.conv(i).weights_1  = fscanf(file_id,"%f",[5,5])';
        parameters.layer2.conv(i).weights_2  = fscanf(file_id,"%f",[5,5])';
        fclose(file_id);
        start = start +2;
    end
    % disp(parameters.layer2.conv(6).weights_2);
    
    %%% conv 4x5x5  6~14
    start = 15;
    for i = 7:15
        file_name = ['./weights/float/' num2str(start) '_c3.convs.' num2str(i - 1) '.weight.txt'];
        file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
        % 检查文件是否成功打开
        if file_id == -1
            error(['无法打开文件,' file_name]);
        end
        parameters.layer2.conv(i).weights_0  = fscanf(file_id,"%f",[5,5])';
        parameters.layer2.conv(i).weights_1  = fscanf(file_id,"%f",[5,5])';
        parameters.layer2.conv(i).weights_2  = fscanf(file_id,"%f",[5,5])';
        parameters.layer2.conv(i).weights_3  = fscanf(file_id,"%f",[5,5])';
        fclose(file_id);
        start = start +2;
    end
    
    %%% conv 6x5x5  15
    file_id = fopen('./weights/float/33_c3.convs.15.weight.txt', 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' './weights/float/33_c3.convs.15.weight.txt']);
    end
    parameters.layer2.conv(16).weights_0  = fscanf(file_id,"%f",[5,5])';
    parameters.layer2.conv(16).weights_1  = fscanf(file_id,"%f",[5,5])';
    parameters.layer2.conv(16).weights_2  = fscanf(file_id,"%f",[5,5])';
    parameters.layer2.conv(16).weights_3  = fscanf(file_id,"%f",[5,5])';
    parameters.layer2.conv(16).weights_4  = fscanf(file_id,"%f",[5,5])';
    parameters.layer2.conv(16).weights_5  = fscanf(file_id,"%f",[5,5])';
    fclose(file_id);
    
    %%% bias 16x1
    start = 4;
    bias = zeros(16,1);
    for i = 1:16
        file_name = ['./weights/float/' num2str(start) '_c3.convs.' num2str(i - 1) '.bias.txt'];
        file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
        % 检查文件是否成功打开
        if file_id == -1
            error(['无法打开文件,' file_name]);
        end
        bias(i,1) = fscanf(file_id,"%f",1);
        fclose(file_id);
        start = start +2;
    end
    parameters.layer2.bias = bias;
    
    %%%%%%%%%%%%% load third layer : 
    %%% fc weight 120x256
    file_name = './weights/float/35_fc1.weight.txt';
    file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' file_name]);
    end
    % parameters.layer3.weights = fscanf(file_id,"%f",[120,256]);
    parameters.layer3.weights = fscanf(file_id,"%f",[256,120])';
    fclose(file_id);
    %%% fc bias 120 x 1
    file_name = './weights/float/36_fc1.bias.txt';
    file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' file_name]);
    end
    parameters.layer3.bias = fscanf(file_id,"%f",[120,1]);
    fclose(file_id);
   
    %%%%%%%%%%%%% load fourth layer : 
    %%% fc weight 84x120
    file_name = './weights/float/37_fc2.weight.txt';
    file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' file_name]);
    end
    % parameters.layer4.weights = fscanf(file_id,"%f",[84,120]);
    parameters.layer4.weights = fscanf(file_id,"%f",[120,84])';
    fclose(file_id);
    %%% fc bias 84 x 1
    file_name = './weights/float/38_fc2.bias.txt';
    file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' file_name]);
    end
    parameters.layer4.bias = fscanf(file_id,"%f",[84,1]);
    fclose(file_id);
    
    %%%%%%%%%%%%% load fifth layer : 
    %%% fc weight 10x84
    file_name = './weights/float/39_fc3.weight.txt';
    file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' file_name]);
    end
    % parameters.layer5.weights = fscanf(file_id,"%f",[10,84]);
    parameters.layer5.weights = fscanf(file_id,"%f",[84,10])';
    fclose(file_id);
    %%% fc bias 10 x 1
    file_name = './weights/float/40_fc3.bias.txt';
    file_id = fopen(file_name, 'r');  % 'r' 表示只读模式
    % 检查文件是否成功打开
    if file_id == -1
        error(['无法打开文件,' file_name]);
    end
    parameters.layer5.bias = fscanf(file_id,"%f",[10,1]);
    fclose(file_id);
end

