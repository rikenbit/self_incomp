# shuffled_col_aa_PCA
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version

dimention = ["5","10","100"]

rule all:
    input:
        expand('output/LOOCV_rf/shuffled_col_aa_PCA_{DIM}.csv', DIM=dimention,)

rule preprocess:
    input:
        'data/multi_align_gap/sp11alnfinal90seq.aln',
        'data/multi_align_gap/SRKfinal_90seq.aln'
    output:
        'output/inputTensors.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/preprocess.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    log:
        'logs/preprocess.log'
    shell:
        'src/preprocess.sh {input} {output} >& {log}'

rule u_models:
    input:
        'output/inputTensors.RData'
    output:
        'output/X_Tensor/shuffled_col_aa_PCA_{DIM}.RData',
        'output/X_Tensor/shuffled_col_aa_PCA_{DIM}.csv'
    benchmark:
        'benchmarks/X_Tensor/shufled_PCA_{DIM}.txt'
    container:
        'docker://yamaken37/shuffled_pca:20230801'
    resources:
        mem_gb=200
    log:
        'logs/X_Tensor/shuffled_col_aa_PCA_{DIM}.log'
    shell:
        'src/shuffled_col_aa_PCA.sh {input} {output} {wildcards.DIM}'

rule SSI_scikit_rf:
    input:
        'output/X_Tensor/shuffled_col_aa_PCA_{DIM}.csv',
        'output/SSI/y_r.csv'
    output:
        'output/LOOCV_rf/shuffled_col_aa_PCA_{DIM}.csv'
    benchmark:
        'benchmarks/LOOCV_rf/shuffled_col_aa_PCA_{DIM}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/LOOCV_rf/shuffled_col_aa_PCA_{DIM}.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_scikit_rf.py {input} {output} >& {log}'