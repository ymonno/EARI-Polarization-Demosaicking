import torch
import scipy.io as sio

# load as pytorch tensor from tokyo tech data mat file http://www.ok.sc.e.titech.ac.jp/res/PolarDem/index.html

def load_mat_as_tensor( mat_file ):
    data = sio.loadmat( mat_file )
    t000 = torch.from_numpy( data["RGB_0"] )
    t045 = torch.from_numpy( data["RGB_45"] )
    t090 = torch.from_numpy( data["RGB_90"] )
    t135 = torch.from_numpy( data["RGB_135"] )
    t = torch.stack( [t000, t045, t090, t135], dim=0 )
    t = t.permute( 0, 3, 1, 2 )
    return t

if __name__ == "__main__" :
    t = load_mat_as_tensor( "apple.mat" )
    print( t.shape )
