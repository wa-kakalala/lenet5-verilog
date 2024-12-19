################################
# @ filename    : main.py
# @ author      : yyrwkk
# @ create time : 2024/12/17 14:39:47
# @ version     : v1.0.0
################################
import torch 
import torch.nn as nn   
import torchvision  
import matplotlib.pyplot as plt 
import numpy as np 
from lenet5 import lenet5
import argparse
import hiddenlayer as hl
from save_weights import save_weights
from PIL import Image
def get_data(path="./data",download=True,batch_size=32,show = False):
    # train dataset
    train_ds = torchvision.datasets.MNIST(
        root=path, 
        train=True, 
        transform=torchvision.transforms.ToTensor(), 
        download=download
    )
    
    # test dataset
    test_ds = torchvision.datasets.MNIST(
        root=path, 
        train=False, 
        transform=torchvision.transforms.ToTensor(), 
        download=True
    )

    # save test_dataset 
    # for idx, (img, label) in enumerate(test_ds):
    #     plt.imsave(f"./data/test_img/{label}/test_img_{idx}.png", img.numpy().squeeze(), cmap='gray')

    print("train_ds.data.shape:",train_ds.data.shape)
    print("test_ds.data.shape:",test_ds.data.shape)

    train_dataloder = torch.utils.data.DataLoader(
        train_ds,
        batch_size=batch_size,
        shuffle=True
    )

    test_dataloder = torch.utils.data.DataLoader(
        test_ds,
        batch_size=batch_size,
        shuffle=False
    )

    if show:
        # shape为：[batch_size, channel, height, weight]
        imgs, labels = next(iter(train_dataloder))
        print("imgs.shape:",imgs.shape)
        labels = labels.numpy()
        plt.figure(figsize=(20, 5)) 
        for i, img in enumerate(imgs[:20]):
            # squeeze dim
            npimg = np.squeeze(img.numpy())*255   # unnormalize
            # show 2x10 images
            plt.subplot(2, 10, i+1)
            plt.imshow(npimg, cmap=plt.cm.gray)
            plt.title(labels[i])
            plt.axis('off')
        plt.show()

    return train_dataloder, test_dataloder

def train_model(model, train_dl, test_dl, epochs=10, lr=0.001):
    # loss function
    criterion = nn.CrossEntropyLoss()
    # optimizer
    optimizer = torch.optim.Adam(model.parameters(), lr=lr)

    history = hl.History()
    canvas = hl.Canvas()

    # train
    model.train()
    for epoch in range(epochs):
        train_loss_epoch  = 0.0
        train_corrects = 0
        for _, (b_x, b_y) in enumerate(train_dl):
            output = model(b_x)
            pre_lab = torch.argmax(output,1)
            loss = criterion(output, b_y)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            train_loss_epoch += loss.item()* b_x.size(0)
            train_corrects += torch.sum(pre_lab == b_y.data)
        train_loss = train_loss_epoch/len(train_dl.dataset)
        train_acc = train_corrects.double() / len(train_dl.dataset)
        print('train: epoch [%d] loss: %.3f' % (epoch+1,train_loss))
        print('train: epoch [%d] acc: %.3f'% (epoch+1,train_acc))
        # save train loss an every epoch
        history.log(
            epoch,train_loss = train_loss,
            train_acc = train_acc.item(),
        )

    # test
    model.eval()
    corrects = 0

    for _, (b_x, b_y) in enumerate(test_dl):
        output = model(b_x)
        pred = torch.max(output, 1)[1]
        corrects += (pred == b_y).sum().item()

    print('test accuracy: %.3f' % (corrects/len(test_dl.dataset)))

    with canvas:
        canvas.draw_plot(history["train_loss"])
        canvas.draw_plot(history["train_acc"])

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--mode', type=str, default='test', help='train or test')
    args = parser.parse_args() 
    model = lenet5()
    if args.mode == 'train':
        train_dl, test_dl = get_data(download=False, show=False)
        train_model(model, train_dl, test_dl, epochs=10, lr=0.001)
        torch.save(model.state_dict(), "./model/model_weights.pth")
    else:
        model.load_state_dict(torch.load("./model/model_weights_acc0.99.pth"))
        _, test_dl = get_data(download=False, show=False)
        model.eval()
        # corrects = 0
        # for _, (b_x, b_y) in enumerate(test_dl):
        #     output = model(b_x)
        #     pred = torch.max(output, 1)[1]
        #     corrects += (pred == b_y).sum().item()

        # print('test accuracy: %.3f' % (corrects/len(test_dl.dataset)))
        # save_weights(model,"./weights/")
        img = Image.open('./data/test_img/test_img_9992.png').convert('L')
        img_array = np.array(img)
        print(img_array.shape)
        data = torch.from_numpy(img_array) / 255.0
        data = data.reshape(1,1,28,28)
        output = model(data)
        pred = torch.max(output, 1)[1]
        print(pred.item())

    
    


