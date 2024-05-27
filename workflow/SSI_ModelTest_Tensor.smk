# SSI_ModelTest_Tensor
###################################################
#### import####
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

# N_row
pullout_row = list(map(str, range(1, 181)))

# Model-1-A1 _row追加
list_LOOCV = [
'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row'
]

rule all:
    input:
        expand('output/Tensor_scale/test_X/predict_df/{list_l}.csv', list_l=list_LOOCV)

rule SSI_ModelTest:
    input:
        expand('output/Tensor_scale/test_X/predict/{list_l}_{p_row}.csv', list_l=list_LOOCV, p_row=pullout_row)
    output:
        'output/Tensor_scale/test_X/predict_df/{list_l}.csv'
    params:
        'output/Tensor_scale/test_X/predict',
        'output/Tensor_scale/test_X/predict/',
        'output/SSI/y_r.csv'
    benchmark:
        'benchmarks/Tensor_scale/test_X/predict_df/{list_l}.txt'
    container:
        "docker://yamaken37/biostrings_tidy:2023020717"
    resources:
        mem_gb=200
    log:
        'logs/Tensor_scale/test_X/predict_df/{list_l}.log'
    shell:
        'src/SSI_ModelTest.sh {output} {params} {wildcards.list_l} >& {log}'