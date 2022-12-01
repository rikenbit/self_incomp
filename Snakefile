from snakemake.utils import min_version

#
# Setting
#
min_version("5.8.1")
configfile: "config.yaml"

SAMPLEs = ["iris",
    "sc_10x_2000hvg", "sc_10x_500hvg", "sc_10x_100hvg", "sc_10x_50hvg",
    "pbmc3k_2000hvg", "pbmc3k_500hvg", "pbmc3k_100hvg", "pbmc3k_50hvg",
    "usoskinbrain_2000hvg"]
SP2s = ["lda", "randomforest", "randomforest_gs", "lda_sss", "randomforest_sss", "randomforest_gs_sss"]
EXTs = [".RData", ".csv"]
Cs = [str(item+2) for item in list(range(8))]

rule all:
    input:
        # Dimension reduction plots
        expand('plot/{sample}/{c}.png',
            sample=SAMPLEs, c=Cs),
        # Error plots
        expand('plot/{sample}/spectral_{sp2}_test_error.png',
            sample=SAMPLEs, sp2=SP2s)

rule spectral_spectral:
    input:
        '../datasets/data/{sample}.csv'
    output:
        touch('output/{sample}/spectral_{c}.csv')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs])
    benchmark:
        'benchmarks/spectral_{sample}_{c}.txt'
    log:
        'logs/spectral_{sample}_{c}.log'
    shell:
       'src/spectral.sh {input} {wildcards.c} {output}>& {log}'

rule spectral_sp2:
    input:
        data1='../datasets/data/{sample}.csv',
        data2='output/{sample}/spectral_{c}.csv'
    output:
        touch('output/{sample}/{sp2}_{c}.csv')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs])
    benchmark:
        'benchmarks/{sp2}_{sample}_{c}.txt'
    log:
        'logs/{sp2}_{sample}_{c}.log'
    shell:
       'src/{wildcards.sp2}.sh {input.data1} {input.data2} {output} >& {log}'

rule spectral_plot_reddim:
    input:
        data="../datasets/data/{sample}.RData",
        spectral='output/{sample}/spectral_{c}.csv'
    output:
        touch('plot/{sample}/{c}.png')
    wildcard_constraints:
        c='|'.join([re.escape(x) for x in Cs]),    
        sample='|'.join([re.escape(x) for x in SAMPLEs])
    benchmark:
        'benchmarks/plot_reddim_spectral_{sample}_{c}.txt'
    log:
        'logs/plot_reddim_spectral_{sample}_{c}.log'
    shell:
       'src/plot_reddim.sh {input.data} {input.spectral} {output} >& {log}'

rule spectral_plot_spectral_randomforest_test_error:
    input:
        expand('output/{sample}/randomforest_{c}.csv', c=Cs, sample=SAMPLEs)
    output:
        touch('plot/{sample}/spectral_randomforest_test_error.png')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs]),
        c='|'.join([re.escape(x) for x in Cs])
    benchmark:
        'benchmarks/spectral_randomforest_{sample}_test_error.txt'
    log:
        'logs/spectral_randomforest_{sample}_test_error.log'
    shell:
        'src/plot_error_spectral_randomforest.sh {wildcards.sample} {Cs} {output} >& {log}'

rule spectral_plot_spectral_randomforest_gs_test_error:
    input:
        expand('output/{sample}/randomforest_gs_{c}.csv', c=Cs, sample=SAMPLEs)
    output:
        touch('plot/{sample}/spectral_randomforest_gs_test_error.png')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs]),
        c='|'.join([re.escape(x) for x in Cs])
    benchmark:
        'benchmarks/spectral_randomforest_gs_{sample}_test_error.txt'
    log:
        'logs/spectral_randomforest_gs_{sample}_test_error.log'
    shell:
        'src/plot_error_spectral_randomforest_gs.sh {wildcards.sample} {Cs} {output} >& {log}'

rule spectral_plot_spectral_lda_test_error:
    input:
        expand('output/{sample}/lda_{c}.csv', c=Cs, sample=SAMPLEs)
    output:
        touch('plot/{sample}/spectral_lda_test_error.png')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs]),
        c='|'.join([re.escape(x) for x in Cs])
    benchmark:
        'benchmarks/spectral_lda_{sample}_test_error.txt'
    log:
        'logs/spectral_lda_{sample}_test_error.log'
    shell:
        'src/plot_error_spectral_lda.sh {wildcards.sample} {Cs} {output} >& {log}'


rule spectral_plot_spectral_randomforest_sss_test_error:
    input:
        expand('output/{sample}/randomforest_sss_{c}.csv', c=Cs, sample=SAMPLEs)
    output:
        touch('plot/{sample}/spectral_randomforest_sss_test_error.png')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs]),
        c='|'.join([re.escape(x) for x in Cs])
    benchmark:
        'benchmarks/spectral_randomforest_sss_{sample}_test_error.txt'
    log:
        'logs/spectral_randomforest_sss_{sample}_test_error.log'
    shell:
        'src/plot_error_spectral_randomforest_sss.sh {wildcards.sample} {Cs} {output} >& {log}'

rule spectral_plot_spectral_randomforest_gs_sss_test_error:
    input:
        expand('output/{sample}/randomforest_gs_sss_{c}.csv', c=Cs, sample=SAMPLEs)
    output:
        touch('plot/{sample}/spectral_randomforest_gs_sss_test_error.png')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs]),
        c='|'.join([re.escape(x) for x in Cs])
    benchmark:
        'benchmarks/spectral_randomforest_gs_sss_{sample}_test_error.txt'
    log:
        'logs/spectral_randomforest_gs_sss_{sample}_test_error.log'
    shell:
        'src/plot_error_spectral_randomforest_gs_sss.sh {wildcards.sample} {Cs} {output} >& {log}'

rule spectral_plot_spectral_lda_sss_test_error:
    input:
        expand('output/{sample}/lda_sss_{c}.csv', c=Cs, sample=SAMPLEs)
    output:
        touch('plot/{sample}/spectral_lda_sss_test_error.png')
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLEs]),
        c='|'.join([re.escape(x) for x in Cs])
    benchmark:
        'benchmarks/spectral_lda_sss_{sample}_test_error.txt'
    log:
        'logs/spectral_lda_sss_{sample}_test_error.log'
    shell:
        'src/plot_error_spectral_lda_sss.sh {wildcards.sample} {Cs} {output} >& {log}'