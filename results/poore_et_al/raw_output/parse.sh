for i in sam_files/*
do
	for j in $i/*
	do
		mv $j $j.sam
	done
done
