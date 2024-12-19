################################
# @ filename    : lenet5.py
# @ author      : yyrwkk
# @ create time : 2024/12/17 14:16:59
# @ version     : v1.0.0
################################
import torch
import torch.nn as nn
from layerc3 import layerc3
from torchinfo import summary
fm_mapping = [
    [0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 0], [5, 0, 1],       # C3[0] C3[1] C3[2] C3[3] C3[4] C3[5]    
    [0, 1, 2, 3],[1, 2, 3, 4],[2, 3, 4, 5],[3, 4, 5, 0],  [4, 5, 0, 1], [5, 0, 1, 2],[0, 2, 4, 1], [1, 3, 5, 0],[2, 4, 0, 1], 
    [0, 1, 2, 3, 4, 5],  # C3[15]
]

class lenet5(nn.Module):
    def __init__(self):
        super(lenet5, self).__init__()
        # c1 1x28×28 -> 6x24x24
        self.conv1 = nn.Conv2d(1, 6, kernel_size=5)
        # s2 6x24x24 -> 6x12x12
        self.pool1 = nn.MaxPool2d(kernel_size=2, stride=2) 
        # c3 6x12x12 -> 16x8x8
        self.c3 = layerc3(fm_maps=fm_mapping, kernel_size=5) 
        # s4 6x8x8 -> 16x4x4      
        self.pool2 = nn.MaxPool2d(kernel_size=2, stride=2) 
        # equally fc layers: 256 -> 120 
        # self.conv5 = nn.Conv2d(16, 120, kernel_size=5) 
        self.fc1 = nn.Linear(256, 120) 
        self.fc2 = nn.Linear(120, 84) 
        self.fc3 = nn.Linear(84, 10) 
    
    def forward(self, x):
        x = self.conv1(x)
        x = nn.functional.relu(x)
        # for i in range(6):
        #     for j in range(24):
        #         for k in range(24):
        #             print("%.3f" % (x[0][i][j][k].item()),end=' ')
        #         print()
        #     print()
        
        x = self.pool1(x)
        # for i in range(6):
        #     for j in range(12):
        #         for k in range(12):
        #             print("%.6f" % (x[0][i][j][k].item()),end=' ')
        #         print()
        #     print()
        x = self.c3(x)
        x = nn.functional.relu(x)
        # for i in range(16):
        #     for j in range(8):
        #         for k in range(8):
        #             print("%.3f" % (x[0][i][j][k].item()),end=' ')
        #         print()
        #     print()
        x = self.pool2(x)
        # for i in range(16):
        #     for j in range(4):
        #         for k in range(4):
        #             print("%.3f" % (x[0][i][j][k].item()),end=' ')
        #         print()
        #     print()
        # for i in range(256):
        #     print("%.3f" % (x.view(x.size(0), -1)[0][i].item()),end=' ')
        x = nn.functional.relu(self.fc1(x.view(x.size(0), -1)))
        
        # print(x)
        x = nn.functional.relu(self.fc2(x))
        x = self.fc3(x)
        return x

if __name__ == '__main__':
    model = lenet5()
    summary(model, input_size=(32,1, 28, 28))
    torch.onnx.export(model, torch.randn(1, 1, 28, 28), "./model/lenet5.onnx", verbose=False)
    # print(model.state_dict())