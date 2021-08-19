path1=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files_10.pipeline_2/01_files/
old=1
new=2
path2=$(echo ${path1}|sed "s|0${old}_|0${new}_|g")
echo $path2

