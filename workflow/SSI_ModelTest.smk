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
'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx_row',
'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx_row',
'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx_row',
'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx_row',
'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20_row',
'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10_row',
'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10_row',
'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8_row',
'MODELS_Model-PCA_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row'
]

# rule all:
#     input:
#         # 'output/MT_test_X/predict_df.csv'
#         expand('output/MT_test_X/predict_df/{list_l}.csv', list_l=list_LOOCV)

# rule SSI_ModelTest:
#     input:
#         expand('output/MT_test_X/predict/{list_l}_{p_row}.csv', list_l=list_LOOCV, p_row=pullout_row)
#     output:
#         'output/MT_test_X/predict_df/{list_l}.csv'
#     params:
#         'output/MT_test_X/predict',
#         'output/MT_test_X/predict/',
#         'output/y_r.csv'
#     benchmark:
#         'benchmarks/MT_test_X/predict_df/{list_l}.txt'
#     container:
#         "docker://yamaken37/biostrings_tidy:2023020717"
#     resources:
#         mem_gb=200
#     log:
#         'logs/MT_test_X/predict_df/{list_l}.log'
#     shell:
#         'src/SSI_ModelTest.sh {output} {params} {wildcards.list_l} >& {log}'

rule all:
    input:
        expand('output/toy/MT_test_X/predict_df/{list_l}.csv', list_l=list_LOOCV)

rule SSI_ModelTest:
    input:
        expand('output/toy/MT_test_X/predict/{list_l}_{p_row}.csv', list_l=list_LOOCV, p_row=pullout_row)
    output:
        'output/toy/MT_test_X/predict_df/{list_l}.csv'
    params:
        'output/toy/MT_test_X/predict',
        'output/toy/MT_test_X/predict/',
        'data/y_r.csv'
    benchmark:
        'benchmarks/MT_test_X/predict_df/{list_l}.txt'
    container:
        "docker://yamaken37/biostrings_tidy:2023020717"
    resources:
        mem_gb=200
    log:
        'logs/MT_test_X/predict_df/{list_l}.log'
    shell:
        'src/SSI_ModelTest.sh {output} {params} {wildcards.list_l} >& {log}'