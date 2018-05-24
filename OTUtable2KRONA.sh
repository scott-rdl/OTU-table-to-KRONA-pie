# !/bin/bash
# by Scott RIDEL
# v1.1

# NEEDED:
#  - leadcosme_otu_table_rarefied.tsv
#  - KronaTools 
#     * How to install KronaTools
#       - Download KronaTools from github
#       - Go into file :  cd xxx/xxx/KronaTools-x.x
#       - Type :          install.pl --prefix /home/UR/myfile

OTU_TABLE="leadcosme_otu_table_rarefied.tsv"

# Preparing file to cut
cp $OTU_TABLE tmp1
sed -i -e "s/\.0//g" tmp1
sed -i -e "s/\t/:/g" tmp1
sed 1d tmp1 -i
sed 1d tmp1 -i
sed -i -e "s/\t/:/g" tmp1
cut -d: -f2- tmp1>tmp2
sed -i "s/;\s*/:/g" tmp2

# Parsing column (header and number)
sed -n "2 p" $OTU_TABLE>tmp3
sed -i -e "s/ /_/g" tmp3
sed -i -e "s/\t/:/g" tmp3
cut -d: -f2- tmp3>tmp4
nbcol=$(grep -o ':' tmp4|wc -l)

mkdir KRONA KRONA/OTU
samples = ""

for i in $(seq 1 1 $nbcol)
do
	name=$(head -1 tmp4|cut -d: -f$i)
	taxo=$(($nbcol+2))
	cut -d: -f$i,$taxo- tmp2>KRONA/OTU/$name.tsv
	sed -i -e "s/:/\t/g" KRONA/OTU/$name.tsv
	samples="$samples KRONA/OTU/$name.tsv"
done

# Suppr tmp files
rm tmp1 tmp2 tmp3 tmp4
echo $samples

# create 
ktImportText -n ' ' -o KRONA/results.html $samples
