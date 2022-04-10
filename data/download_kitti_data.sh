#!/bin/bash



FILES=(
    "data_object_image_2"
    "data_object_velodyne"
    "data_object_calib"
    "data_object_label_2"
)



# ~25min just to curl zips
for f in ${FILES[@]}; do

    echo "File: ${f}"
    
    if [ ! -f "${f}.zip" ]; then 
        echo -e "\tdownloading..."
        curl -s "https://s3.eu-central-1.amazonaws.com/avg-kitti/${f}.zip" -o "${f}.zip"
    fi
    
    echo -e "\tunzipping..."
    unzip -q -n "${f}.zip" -d "${f}"
    
    echo -e "\tdone"

done

