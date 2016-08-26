import click
import os
from Bio import SeqIO


@click.command()
@click.option('--gbk', type=click.Path(exists=True), help='Input GBK file')
@click.option('--dnadir', default = ".", help='where to put ORF files')
@click.option('--proteindir', default = ".", help='where to put protein sequence files')
def parse_GBK(gbk, dnadir, proteindir):
    """Parser for Mibig GBK Files that outputs CDS files as well as gene sequences."""


    gbkname = os.path.basename(gbk)
    gbkname = gbkname.split(".")[0]
    dnafile = "{}/genes.fna".format(dnadir)
    proteinfile = "{}/proteins.faa".format(proteindir)

    print("Processing {} ....".format(gbkname))
    recs = SeqIO.parse(open(gbk, 'r'), "genbank")

    for rec in recs:
        cdss = (feat for feat in rec.features if feat.type=="CDS")
        for idx, cds in enumerate(cdss):

            ## get protein/ORF inforamtion
            featurekeys = set(cds.qualifiers.keys())

            # protein sequence
            try:
                protseq = cds.qualifiers['translation'][0]
            except:
                raise ValueError("No protein sequence found in this CDS record")

            # protein accession
            try:
                proteinid = cds.qualifiers['protein_id'][0]
            except:
                print("no protein ID found in the translation slot")
                proteinid = "CDS_{}".format(idx)

            # gene name
            if "gene" in featurekeys:
                genename = cds.qualifiers['gene'][0]
            elif "locus_tag" in featurekeys:
                print("no gene identifier found. using the locus_tag")
                genename = cds.qualifiers['locus_tag'][0].replace("_", "-")
            elif "note" in featurekeys and "orf" in cds.qualifiers['note'][0].lower():
                print("no gene identifier found. using the ORF ID in the 'note' slot")
                genename = cds.qualifiers['note'][0].replace(" ", "-")
            elif "product" in featurekeys:
                print("no gene identifier found. using the product slot")
                genename = cds.qualifiers['product'][0].replace(" ", "-")
            elif "note" in featurekeys and "orf" in cds.qualifiers['note'][0].lower():
                print("no gene identifier found. using the 'note'")
                genename = cds.qualifiers['note'][0]
                genename = genename.replace(" ", "-")

            else:
                genename = "CDS_{}".format(idx)
                print("no gene name identified  - creating one, {},  based off of the CDS number".format(genename))


            # DNA sequence
            try:
                dnaseq = cds.extract(rec).seq
            except:
                raise ValueError("No Sequence Available for this Protein")


            # write CDS to file
            try:
                with open(proteinfile, "a") as f:
                    f.write(">{}_{}_{}\n{}\n".format(gbkname, genename, proteinid, protseq))
            except:
                pass
            # write ORF to file
            try:
                with open(dnafile, "a") as f:
                    f.write(">{}_{}_{}\n{}\n".format(gbkname, genename, proteinid, dnaseq))
            except:
                pass





if __name__ == '__main__':
    parse_GBK()
