# SSI_fixPredict_R_PCA
n_pca_dim = ['5']

#### import####
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

n_pca_dim = ['5']

rule all:
    input:
        expand('output/R_PCA_scaled/test_X/predict/dim_{npdim}.csv', npdim=n_pca_dim)

rule preprocess_train:
    input:
        'data/multi_align_gap/sp11alnfinal90seq.aln',
        'data/multi_align_gap/SRKfinal_90seq.aln'
    output:
        'data/train_Tensors.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/preprocess_train.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    log:
        'logs/preprocess_train.log'
    shell:
        'src/preprocess_train.sh {input} {output} >& {log}'

rule preprocess_test:
    input:
        'data/multi_align_gap/ArabiLigand_all_final_190seq.aln',
        'data/multi_align_gap/ArabiReceptorFinal.aln'
    output:
        'data/test_Tensors.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/preprocess_test.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    log:
        'logs/preprocess_test.log'
    shell:
        'src/preprocess_test.sh {input} {output} >& {log}'


rule train_u_models:
    input:
        'data/train_Tensors.RData'
    output:
        'output/R_PCA_scaled/train_X/tensor/dim_{npdim}.RData',
        'output/R_PCA_scaled/train_X/tensor/dim_{npdim}.csv'
    benchmark:
        'benchmarks/R_PCA_scaled/train_X/tensor/dim_{npdim}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        'logs/R_PCA_scaled/train_X/tensor/dim_{npdim}.log'
    shell:
        'src/train_Model-PCA_scale_180.sh {input} {wildcards.npdim} {output}  >& {log}'

rule SSI_scikit_rf_fit_MT:
    input:
        'output/R_PCA_scaled/train_X/tensor/dim_{npdim}.csv',
        'output/SSI/y_r.csv'
    output:
        'output/R_PCA_scaled/train_X/fit/dim_{npdim}.pickle'
    benchmark:
        'benchmarks/R_PCA_scaled/train_X/fit/dim_{npdim}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/R_PCA_scaled/train_X/fit/dim_{npdim}.log'
    shell:
        'source /opt/conda/etc/profile.d/conda.sh && conda activate sklearn-env && python src/SSI_scikit_rf_fit_MT.py {input} {output} >& {log}'

rule test_u_models:
    input:
        'data/test_Tensors.RData',
        'output/R_PCA_scaled/train_X/tensor/dim_{npdim}.RData'
    output:
        'output/R_PCA_scaled/test_X/tensor/dim_{npdim}.csv'
    benchmark:
        'benchmarks/R_PCA_scaled/test_X/tensor/dim_{npdim}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        'logs/R_PCA_scaled/test_X/tensor/dim_{npdim}.log'
    shell:
        'src/test_Model-PCA_scale_180.sh {input} {output} >& {log}'

rule SSI_U_Predict:
    input:
        'output/R_PCA_scaled/train_X/fit/dim_{npdim}.pickle',
        'output/R_PCA_scaled/test_X/tensor/dim_{npdim}.csv'
    output:
        'output/R_PCA_scaled/test_X/predict/dim_{npdim}.csv'
    benchmark:
        'benchmarks/R_PCA_scaled/test_X/predict/dim_{npdim}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/R_PCA_scaled/test_X/predict/dim_{npdim}.log'
    shell:
        'source /opt/conda/etc/profile.d/conda.sh && conda activate sklearn-env && python src/SSI_U_Predict.py {input} {output} >& {log}'