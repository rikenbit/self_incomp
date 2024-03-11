# SSI_aln_to_onehot
###################################################

rule all:
    input:
        'output/SSI/x_r.csv',
        'output/SSI/y_r.csv'
        
rule SSI_aln_to_onehot:
    input:
        'data/multi_align_gap/sp11alnfinal90seq.aln',
        'data/multi_align_gap/SRKfinal_90seq.aln'
    output:
        'output/SSI/x_r.csv',
        'output/SSI/y_r.csv'
        
    benchmark:
        'benchmarks/SSI.txt'
    container:
        "docker://yamaken37/ssi_tensor:20221212"
    resources:
        mem_gb=200
    log:
        'logs/SSI.log'
    shell:
        'src/SSI_aln_to_onehot.sh {input} {output} >& {log}'