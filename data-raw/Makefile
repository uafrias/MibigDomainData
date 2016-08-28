# need
# system: hmmer3, GNU parallel
# python: click, Biopython, mibig-tools
# R: devtools, dplyr, Biostrings



# get the Mibig GBK Data
mibig_gbk/BGC0001310.gbk:
	wget http://mibig.secondarymetabolites.org/mibig_gbk_1.2.tar.gz
	tar -xvf mibig_gbk_1.2.tar.gz

# get the Mibig JSON Data
all_json/BGC0001310.json:
	wget http://mibig.secondarymetabolites.org/mibig_json_1.2.tar.gz
	tar -xvf mibig_json_1.2.tar.gz

# get the PFAM HMM data
PFAM-A.hmm:
	wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
	gunzip Pfam-A.hmm.gz
	hmmpress Pfam-A.hmm

#extract MibigProteins and genes
proteins/proteins.faa: mibig_gbk/BGC0001310.gbk
	mkdir -p genes proteins
	find mibig_gbk -type f -name *.gbk | parallel 'python parse_GBK.py --gbk {} --dnadir genes --proteindir proteins'

# run HMMER against the Mibig proteins
proteins/proteinhmmtbl.txt: proteins/proteins.faa
	hmmsearch  --domtblout $@ --domE 1e-30 --cpu 6 Pfam-A.hmm  $<

# create the Mibig Datatable
createmibigtable: proteins/proteinhmmtbl.txt
	R BATCH CMD make_mibig_table.R

# process the Mibig JSON Files to obtain metadata
clusters.csv: all_json/BGC0001310.json mibig_gbk/BGC0001310.gbk
	#from the mibig-tools package
	 mibig_process_folder --json_folder all_json --gbk_folder mibig_gbk

clean:
	rm -rf proteins genes

all: createmibigtable clusters.csv
