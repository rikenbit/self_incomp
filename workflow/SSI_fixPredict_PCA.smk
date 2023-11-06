# MODEL_Parameter = ['']
n_pca_dim = list(map(str, range(5, 12)))

#### import####
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace
###################################################

rule all:
    input:
        expand('output/SSI_fixPredict_PCA/predict/Model-PCA_{npdim}.csv', 
            npdim=n_pca_dim
            )

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

rule SSI_fixPredict_toCSV: #テスト&訓練データのCSV変換
    input:
        'data/train_Tensors.RData',
        'data/test_Tensors.RData'
    output:
        'output/SSI_fixPredict_PCA/X_train.csv',
        'output/SSI_fixPredict_PCA/X_test.csv'
    benchmark:
        'benchmarks/SSI_fixPredict_PCA/X_train.txt'
    container:
        "docker://koki/tensor-projects-self-incompatible:20221217"
    resources:
        mem_gb=200
    log:
        'logs/SSI_fixPredict_PCA/X_train.log'
    shell:
        'src/SSI_fixPredict_toCSV.sh {input} {output}>& {log}'

rule SSI_fixPredict_PCA:
    input:
        'output/SSI_fixPredict_PCA/X_train.csv',
        'output/y_r.csv',
        'output/SSI_fixPredict_PCA/X_test.csv'
    output:
        'output/SSI_fixPredict_PCA/predict/Model-PCA_{npdim}.csv'
    benchmark:
        'benchmarks/SSI_fixPredict_PCA/predict/Model-PCA_{npdim}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/SSI_fixPredict_PCA/predict/Model-PCA_{npdim}.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_fixPredict_PCA.py {input} {wildcards.npdim} {output} >& {log}'        
