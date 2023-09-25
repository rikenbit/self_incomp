# SSI_MT_py
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version

# MODEL_Parameter = ['']
n_pca_dim = list(map(str, range(5, 11)))

rule all:
    input:
        # expand('output/MT_py_X/matrix/{MODEL_P}.csv', MODEL_P=MODEL_Parameter)
        # 'output/MT_py_X/matrix/X_180_LR.csv'
        expand('output/MT_py_X/accuracy/Model-PCA_{npdim}.csv', 
            npdim=n_pca_dim
            )
        
rule SSI_MT_py:
    input:
        'data/train_Tensors.RData'
    output:
        'output/MT_py_X/matrix/X_180_LR.csv'
    benchmark:
        'benchmarks/MT_py_X/matrix/X_180_LR.txt'
    container:
        "docker://koki/tensor-projects-self-incompatible:20221217"
    resources:
        mem_gb=200
    log:
        'logs/MT_py_X/matrix/X_180_LR.log'
    shell:
        'src/SSI_MT_py.sh {input} {output}>& {log}'

rule SSI_MT_py_pre:
    input:
        'output/MT_py_X/matrix/X_180_LR.csv',
        'output/y_r.csv'
    output:
        'output/MT_py_X/accuracy/Model-PCA_{npdim}.csv'
    benchmark:
        'benchmarks/MT_py_X/accuracy/Model-PCA_{npdim}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/MT_py_X/accuracy/Model-PCA_{npdim}.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_MT_py_pre.py {input} {wildcards.npdim} {output} >& {log}'