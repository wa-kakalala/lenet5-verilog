################################
# @ filename    : layerc3.py
# @ author      : yyrwkk
# @ create time : 2024/12/17 14:01:02
# @ version     : v1.0.0
################################
import torch
import torch.nn as nn  

# fm_mapping = [
#             [0, 1, 2],           # C3[0]
#             [1, 2, 3],           # C3[1]
#             [2, 3, 4],           # C3[2]
#             [3, 4, 5],           # C3[3]
#             [4, 5, 0],           # C3[4]
#             [5, 0, 1],           # C3[5]
#             [0, 1, 2, 3],        # C3[6]
#             [1, 2, 3, 4],        # C3[7]
#             [2, 3, 4, 5],        # C3[8]
#             [3, 4, 5, 0],        # C3[9]
#             [4, 5, 0, 1],        # C3[10]
#             [5, 0, 1, 2],        # C3[11]
#             [0, 2, 4, 1],        # C3[12]
#             [1, 3, 5, 0],        # C3[13]
#             [2, 4, 0, 1],        # C3[14]
#             [0, 1, 2, 3, 4, 5],  # C3[15]
# ]

class layerc3(nn.Module):
    def __init__(self, fm_maps, kernel_size, stride=1, padding=0,bias=True):
        super(layerc3, self).__init__()
        # feature mapping
        self.fm_maps = fm_maps 
       
        self.convs = nn.ModuleList([
            nn.Conv2d(
                in_channels=len(fm_map),
                out_channels= 1,
                kernel_size=kernel_size,
                stride=stride,
                padding=padding,
                bias=bias
            )

            for fm_map in self.fm_maps
        ])

    def forward(self, x):
        outputs = [] 
        for i, fm_map in enumerate(self.fm_maps):
            in_feature = torch.cat([x[:,idx:idx+1,:,:] for idx in fm_map], dim=1)
            outputs.append(self.convs[i](in_feature))
        return torch.cat(outputs, dim=1)