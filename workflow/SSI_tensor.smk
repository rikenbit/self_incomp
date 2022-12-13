# SSI_tensor
###################################################
# Distance Data
model = ["1","2","3","4"]

# aminoacid patterm
aminoacid = ["10"] # max 21

# n_gene patterm
# n_gene = ["5","10","50","100"]
n_gene = ["10"] # max 180

# site_ligand patterm
# site_ligand = ["5","10","50","100"]
site_ligand = ["10"]

# site_receptor patterm
# site_receptor = ["5","10","50","100"]
site_receptor = ["10"]

rule all:
    input:
        expand('output/SSI/X_Tensor/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.csv',
            MOD=model,
            AA=aminoacid,
            GE=n_gene,
            sL=site_ligand,
            sR=site_receptor
            )

rule SSI_tensor:
    input:
        sp = 'data/multi_align_gap/sp11alnfinal90seq.aln',
        srk = 'data/multi_align_gap/SRKfinal_90seq.aln'
    output:
        'output/SSI/X_Tensor/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.csv'
    benchmark:
        'benchmarks/SSI/X_Tensor/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.txt'
    container:
        "docker://yamaken37/ssi_tensor:20221212"
    resources:
        mem_gb=200
    log:
        'logs/SSI/X_Tensor/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.log'
    shell:
        'src/SSI_tensor.sh {input.sp} {input.srk} {output} {wildcards.MOD} {wildcards.AA} {wildcards.GE} {wildcards.sL} {wildcards.sR} >& {log}'