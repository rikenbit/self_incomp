# SSI_ModelTest
###################################################
#### import####
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

# N_row
pullout_row = list(map(str, range(1, 181)))

list_LOOCV = [
'MODELS_Model-PCA_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row'
]

# rule all:
#     input:
#         expand('output/PCA/MT_test_X/predict_df/{list_l}.csv', list_l=list_LOOCV)

# rule SSI_ModelTest:
#     input:
#         expand('output/PCA/MT_test_X/predict/{list_l}_{p_row}.csv', list_l=list_LOOCV, p_row=pullout_row)
#     output:
#         'output/PCA/MT_test_X/predict_df/{list_l}.csv'
#     params:
#         'output/PCA/MT_test_X/predict',
#         'output/PCA/MT_test_X/predict/',
#         'data/y_r.csv'
#     benchmark:
#         'benchmarks/PCA/MT_test_X/predict_df/{list_l}.txt'
#     container:
#         "docker://yamaken37/biostrings_tidy:2023020717"
#     resources:
#         mem_gb=200
#     log:
#         'logs/PCA/MT_test_X/predict_df/{list_l}.log'
#     shell:
#         'src/SSI_ModelTest.sh {output} {params} {wildcards.list_l} >& {log}'
########

rule all:
    input:
        expand('output/PCA_scale/MT_test_X/predict_df/{list_l}.csv', list_l=list_LOOCV)

rule SSI_ModelTest:
    input:
        expand('output/PCA_scale/MT_test_X/predict/{list_l}_{p_row}.csv', list_l=list_LOOCV, p_row=pullout_row)
    output:
        'output/PCA_scale/MT_test_X/predict_df/{list_l}.csv'
    params:
        'output/PCA_scale/MT_test_X/predict',
        'output/PCA_scale/MT_test_X/predict/',
        'data/y_r.csv'
    benchmark:
        'benchmarks/PCA_scale/MT_test_X/predict_df/{list_l}.txt'
    container:
        "docker://yamaken37/biostrings_tidy:2023020717"
    resources:
        mem_gb=200
    log:
        'logs/PCA_scale/MT_test_X/predict_df/{list_l}.log'
    shell:
        'src/SSI_ModelTest.sh {output} {params} {wildcards.list_l} >& {log}'