# template
###################################################
# No. of Clusters
N_CLUSTERS = list(map(str, range(2, 21)))
# N_CLUSTERS = ["3"]

# Distance Data
dist_data = ["EUCL","SBD_abs"]

# data time range
time_range = ["stimAfter"]

# ReClustering method
ReClustering_method = ["CSPA","OINDSCAL","MCMIHOOI"]

rule all:
    input:
        expand('output/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.RData',
            range=time_range,
            dist=dist_data,
            N_cls=N_CLUSTERS,
            Re_cls=ReClustering_method
            )
        
rule template:
    input:
        Mem_matrix = 'output/WTS4/normalize_1/{range}/{dist}/Membership/k_Number_{N_cls}.RData'
    output:
        m_data = 'output/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.RData'
    benchmark:
        'benchmarks/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.txt'
    container:
        "docker://docker_images"
    resources:
        mem_gb=200
    log:
        'logs/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.log'
    shell:
        'src/template.sh {wildcards.Re_cls} {input.Mem_matrix} {output.m_data}>& {log}'