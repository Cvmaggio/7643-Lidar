#!/bin/bash



FILES=(
    "data_object_image_2"
    "data_object_velodyne"
    "data_object_calib"
    "data_object_label_2"
)



# ~25min to curl zips
# ~10min to unzip
# ~80GB total storage needed after unzipping
for f in ${FILES[@]}; do

    echo "File: ${f}"
    
    if [ ! -f "${f}.zip" ]; then 
        echo -e "\tdownloading..."
        curl -s "https://s3.eu-central-1.amazonaws.com/avg-kitti/${f}.zip" -o "${f}.zip"
    fi
    
    
    if [ ! -d "${f}" ]; then
        echo -e "\tunzipping..."
        unzip -q -n "${f}.zip" -d "${f}"
    fi
    
    echo -e "\tdone"

done





mkdir -p kitti/ImageSets kitti/training kitti/testing



wget -c https://raw.githubusercontent.com/traveller59/second.pytorch/master/second/data/ImageSets/test.txt --no-check-certificate --content-disposition -O kitti/ImageSets/test.txt
wget -c https://raw.githubusercontent.com/traveller59/second.pytorch/master/second/data/ImageSets/train.txt --no-check-certificate --content-disposition -O kitti/ImageSets/train.txt
wget -c https://raw.githubusercontent.com/traveller59/second.pytorch/master/second/data/ImageSets/val.txt --no-check-certificate --content-disposition -O kitti/ImageSets/val.txt
wget -c https://raw.githubusercontent.com/traveller59/second.pytorch/master/second/data/ImageSets/trainval.txt --no-check-certificate --content-disposition -O kitti/ImageSets/trainval.txt




mv data_object_calib/training/calib kitti/training/
mv data_object_calib/testing/calib kitti/testing/

mv data_object_image_2/training/image_2 kitti/training/
mv data_object_image_2/testing/image_2 kitti/testing/

mv data_object_velodyne/training/velodyne kitti/training/
mv data_object_velodyne/testing/velodyne kitti/testing/

mv data_object_label_2/training/label_2 kitti/training/



# # delete now empty unzipped dirs
# for f in ${FILES[@]}; do
#     rm -rf "${f}"
# fi