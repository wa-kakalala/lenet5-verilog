################################
# @ filename    : save_weigth.py
# @ author      : yyrwkk
# @ create time : 2024/12/19 15:32:37
# @ version     : v1.0.0
################################

def save_weights(model, save_dir):
    print("model weights:")
    layers = 1
    for key,value in model.state_dict().items():
        print(key, value.shape)
        with open( save_dir  + str(layers) + "_" + key+".txt", "w") as f:
            if( len(value.shape) == 1):
                for i in range(value.shape[0]):
                    f.write(str(value[i].item()) + " ")
            elif (len(value.shape) == 2):
                for i in range(value.shape[0]):
                    for j in range(value.shape[1]):
                        f.write(str(value[i][j].item()) + " ")
                    f.write("\n")
            elif (len(value.shape) == 4):
                for i in range(value.shape[0]):
                    for j in range(value.shape[1]):
                        for k in range(value.shape[2]):
                            for l in range(value.shape[3]):
                                f.write(str(value[i][j][k][l].item()) + " ")
                            f.write("\n")
                        f.write("\n")
                    f.write("\n")
            else:
                print("unsupported shape")
        layers += 1

