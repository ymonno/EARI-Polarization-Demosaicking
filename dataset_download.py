import os
import shutil
import wget
import argparse
import glob
import torch
from load_mat_as_tensor import *

def sample_download(path_to_dataset=None, download_only=False):
    # Get the directory of this script
    install_dir = os.path.dirname(os.path.abspath(__file__))

    # Use the script directory if no argument is provided
    if path_to_dataset is None:
        path_to_dataset = install_dir

    # Create the directory if it does not exist
    os.makedirs(path_to_dataset, exist_ok=True)

    # URL of the sample dataset
    url = "http://www.ok.sc.e.titech.ac.jp/res/PolarDem/data/Dataset.zip"

    # Download the zip file to a temporary location
    print( f"Downloading {url} ..." )
    tmp_zip_file = os.path.join( path_to_dataset, "tmp.zip" )
    wget.download(url, tmp_zip_file)

    # Extract the zip file
    print(f"Extracting to {path_to_dataset} ...")
    shutil.unpack_archive( tmp_zip_file, path_to_dataset )

    # Remove the temporary file
    os.remove(tmp_zip_file)

    if not download_only:
        # Converting mat to pth
        mat_files = glob.glob( os.path.join( path_to_dataset, "Dataset/mat/*.mat" ) )
        os.makedirs(os.path.join( path_to_dataset, "Dataset/pth" ), exist_ok=True)
        for mat_file in mat_files:
            title = os.path.basename(mat_file).split('.', 1)[0]
            print(f" {title}")
            pth_file = os.path.join( path_to_dataset, "Dataset/pth/{title}.pth" )
            tensor = load_mat_as_tensor( mat_file )
            torch.save( tensor, pth_file )

    print("Done.")

# Run when executed as a standalone script
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='')

    parser.add_argument('--path', default="TokyoTech" )
    parser.add_argument('--download_only', action='store_true', default=False)
    args = parser.parse_args()

    sample_download( args.path, args.download_only )
