# SSI_toy_MT_Accuracy
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

# N_row
pullout_row = list(map(str, range(1, 181)))
# pullout_row = list(map(str, range(1, 4)))

list_LOOCV = [
'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx',
'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx',
'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx',
'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx',
'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20',
'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10',
'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10',
'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8',
'MODELS_Model-PCA_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx'
]

list_join = list(it.product(list_LOOCV,pullout_row))
list_LOOCV_row = ['_row_'.join(v) for v in list_join]


df_Series= pd.Series(list_LOOCV_row)
df = df_Series.str.split('_', expand=True)
df = df.iloc[:,1::2]
df_test=df.set_axis(['MODELS','r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R', 'row'], axis=1)
paramspace = Paramspace(df_test, filename_params=['MODELS', 'r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R', 'row'], param_sep="_")

rule all:
    input:
        expand('output/toy/MT_test_X/predict/{params}.csv', params = paramspace.instance_patterns)

rule preprocess:
    output:
        'data/toy/inputTensors.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/toy/inputTensors.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    log:
        'logs/toy/inputTensors.log'
    shell:
        'src/SSI_toy_Accuracy.sh {output} >& {log}'

rule train_u_models:
    input:
        'data/toy/inputTensors.RData'
    output:
        expand('output/toy/MT_train_X/tensor/{params}.RData', params = paramspace.wildcard_pattern),
        expand('output/toy/MT_train_X/tensor/{params}.csv', params = paramspace.wildcard_pattern),
        expand('output/toy/MT_train_X/one_slice_tensor/{params}.RData', params = paramspace.wildcard_pattern)
    params:
        args0 = lambda w: w["MODELS"],
        args1 = lambda w: w["r1"],
        args2 = lambda w: w["r2"],
        args3 = lambda w: w["r3"],
        args4 = lambda w: w["r1L"],
        args5 = lambda w: w["r1R"],
        args6 = lambda w: w["r2L"],
        args7 = lambda w: w["r2R"],
        args8 = lambda w: w["r3L"],
        args9 = lambda w: w["r3R"],
        args10 = lambda w: w["row"]
    benchmark:
        f'benchmarks/MT_train_X/tensor/{paramspace.wildcard_pattern}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        f'logs/MT_train_X/tensor/{paramspace.wildcard_pattern}.log'
    shell:
        'src/train_{params.args0}.sh {params.args1} {params.args2} {params.args3} {params.args4} {params.args5} {params.args6} {params.args7} {params.args8} {params.args9} {params.args10} {input} {output}  >& {log}'

rule SSI_scikit_rf_fit_MT:
    input:
        expand('output/toy/MT_train_X/tensor/{params}.csv', params = paramspace.wildcard_pattern),
        'data/y_r.csv'
    output:
        expand('output/toy/MT_train_X/fit/{params}.pickle', params = paramspace.wildcard_pattern)
    params:
        args10 = lambda w: w["row"]
    benchmark:
        f'benchmarks/MT_train_X/fit/{paramspace.wildcard_pattern}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        f'logs/MT_train_X/fit/{paramspace.wildcard_pattern}.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_scikit_rf_fit_MT.py {input} {output} {params.args10} >& {log}'

rule test_u_models:
    input:
        expand('output/toy/MT_train_X/one_slice_tensor/{params}.RData', params = paramspace.wildcard_pattern),
        expand('output/toy/MT_train_X/tensor/{params}.RData', params = paramspace.wildcard_pattern)
    output:
        expand('output/toy/MT_test_X/tensor/{params}.csv', params = paramspace.wildcard_pattern)
    params:
        args0 = lambda w: w["MODELS"]
    benchmark:
        f'benchmarks/MT_test_X/tensor/{paramspace.wildcard_pattern}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        f'logs/MT_test_X/tensor/{paramspace.wildcard_pattern}.log'
    shell:
        'src/test_{params.args0}.sh {input} {output} >& {log}'

rule SSI_U_Predict:
    input:
        expand('output/toy/MT_train_X/fit/{params}.pickle', params = paramspace.wildcard_pattern),
        expand('output/toy/MT_test_X/tensor/{params}.csv', params = paramspace.wildcard_pattern)
    output:
        expand('output/toy/MT_test_X/predict/{params}.csv', params = paramspace.wildcard_pattern)
    benchmark:
        f'benchmarks/MT_test_X/predict/{paramspace.wildcard_pattern}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        f'logs/MT_test_X/predict/{paramspace.wildcard_pattern}.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_U_Predict.py {input} {output} >& {log}'