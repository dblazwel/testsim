
# DBG - Script para ejecutar la pipeline
# Comandos que solo deben ejecutarse una vez:

# Obtener el genoma
 mkdir -p res/genome
 wget -O res/genome/ecoli.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
 gunzip -k res/genome/ecoli.fasta.gz

# Obtener el índice
 echo "Running STAR index..."
 mkdir -p res/genome/star_index
 STAR --runThreadN 4 --runMode genomeGenerate \
 --genomeDir res/genome/star_index/ \
 --genomeFastaFiles res/genome/ecoli.fasta \
 --genomeSAindexNbases 9

# Controlador: Analizar cada una de las muestras
for sampleid in $(ls data/*fastq.gz | cut -d'_' -f1 |cut -d'/' -f2 | sort | uniq);
do
	echo "Running analysis for sample: "$sampleid;
        bash scripts/analyse_sample.sh $sampleid;
done

# Finalmente ejecutar MultiQC
export WD=$(pwd)
multiqc -o out/multiqc $WD
