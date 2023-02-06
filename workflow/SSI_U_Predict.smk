# SSI_U_Predict
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

####################################paramspace dataframe##########################################################
# Setting dataframe BEST
####################
list_LOOCV = [
# 'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx'
,
# 'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx',
# 'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx',
# 'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx',
# 'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx',
# 'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20',
# 'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10',
# 'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10',
# 'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8',
# 'MODELS_Model-PCA_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx'
]

df_Series= pd.Series(list_LOOCV)

df = df_Series.str.split('_', expand=True)
df = df.iloc[:,1::2]

df_test=df.set_axis(['MODELS','r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], axis=1)
####################

# Setting dataframe ALL
####################
# Unsupervised Models
# U_MODELS = [
#     'Model-1-A1G', 'Model-1-A1',
#     'Model-2-A1G',
#     'Model-3-A1G', 'Model-3-A1',
#     'Model-4-A1G', 'Model-4-A1',
#     'Model-5-A1',
#     'Model-6-A1A3G',
#     'Model-7-A1A2G',
#     'Model-8-A1GLGR', 'Model-8-A1',
#     'Model-9-A1A4GLGR', 'Model-9-A1A4',
#     'Model-10-A1GLGR', 'Model-10-A1',
#     'Model-11-A1A4GLGR', 'Model-11-A1A4',
#     'Model-PCA']

# gene LRpair 1patterm test
# r1 = ["20"]
# # siteLR patterm
# r2 = ["100"]
# # aminoacid patterm
# r3 =  ["5"]
# # gene_pair_L
# r1L = ["10"]
# # gene_pair_R
# r1R = ["10"]
# # site_ligand_L
# r2L = ["10"]
# # site_ligand_R
# r2R = ["10"]
# # aminoacid L
# r3L =  ["10"]
# # aminoacid R
# r3R =  ["10"]
# comb_para = list(it.product(U_MODELS, r1, r2, r3, r1L, r1R, r2L, r2R, r3L, r3R))
# df_para = pd.DataFrame(comb_para)
# df_para = df_para.set_index(0)
# df_para = df_para.set_axis(['r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], axis=1)
# df_para_trim=df_para

#### trim Model-1-A1G####
# l_bool = [False, False, False, True, True, True, True, True, True]
# df_para_trim.loc['Model-1-A1G', l_bool]="xx"
########################
# #### trim Model-8-A1GLGR####
# l_bool = [False, True, False, True, True, False, False, True, True]
# df_para_trim.loc['Model-8-A1GLGR', l_bool]="xx"
# ########################
# #### trim Model-1-A1####
# l_bool = [False, False, False, True, True, True, True, True, True]
# df_para_trim.loc['Model-1-A1', l_bool]="xx"
# ########################
# #### trim Model-2-A1G####
# l_bool = [True, False, False, True, True, True, True, True, True]
# df_para_trim.loc['Model-2-A1G', l_bool]="xx"
# ########################
# #### trim Model-3-A1G####
# l_bool = [False, True, False, True, True, True, True, True, True]
# df_para_trim.loc['Model-3-A1G', l_bool]="xx"
# ########################
# #### trim Model-3-A1####
# l_bool = [False, True, False, True, True, True, True, True, True]
# df_para_trim.loc['Model-3-A1', l_bool]="xx"
# ########################
# #### trim Model-4-A1G####
# l_bool = [False, False, True, True, True, True, True, True, True]
# df_para_trim.loc['Model-4-A1G', l_bool]="xx"
# ########################
# #### trim Model-4-A1####
# l_bool = [False, False, True, True, True, True, True, True, True]
# df_para_trim.loc['Model-4-A1', l_bool]="xx"
# ########################
# #### trim Model-5-A1####
# l_bool = [False, True, True, True, True, True, True, True, True]
# df_para_trim.loc['Model-5-A1', l_bool]="xx"
# #######################
# #### trim Model-6-A1A3G####
# l_bool = [True, False, True, True, True, True, True, True, True]
# df_para_trim.loc['Model-6-A1A3G', l_bool]="xx"
# #######################
# #### trim Model-7-A1A2G####
# l_bool = [True, True, False, True, True, True, True, True, True]
# df_para_trim.loc['Model-7-A1A2G', l_bool]="xx"
# ########################
# #### trim Model-8-A1####
# l_bool = [False, True, False, True, True, False, False, True, True]
# df_para_trim.loc['Model-8-A1', l_bool]="xx"
# ########################
# #### trim Model-9-A1A4GLGR####
# l_bool = [True, True, False, False, False, False, False, True, True]
# df_para_trim.loc['Model-9-A1A4GLGR', l_bool]="xx"
# ########################
# #### trim Model-9-A1A4####
# l_bool = [True, True, False, False, False, False, False, True, True]
# df_para_trim.loc['Model-9-A1A4', l_bool]="xx"
# ########################
# #### trim Model-10-A1GLGR####
# l_bool = [False, True, True, True, True, False, False, False, False]
# df_para_trim.loc['Model-10-A1GLGR', l_bool]="xx"
# ########################
# #### trim Model-10-A1####
# l_bool = [False, True, True, True, True, False, False, False, False]
# df_para_trim.loc['Model-10-A1', l_bool]="xx"
# ########################
# #### trim Model-11-A1A4GLGR####
# l_bool = [True, True, True, False, False, False, False, False, False]
# df_para_trim.loc['Model-11-A1A4GLGR', l_bool]="xx"
# ########################
# #### trim Model-11-A1A4####
# l_bool = [True, True, True, False, False, False, False, False, False]
# df_para_trim.loc['Model-11-A1A4', l_bool]="xx"
# #######################
# #### trim Model-PCA####
# l_bool = [True, False, True, True, True, True, True, True, True]
# df_para_trim.loc['Model-PCA', l_bool]="xx"
# #######################
# df=df_para_trim
# df.index.name = 'MODELS'
# df.reset_index(inplace=True)
# df_test=df[~df.duplicated()]
####################
####################################paramspace dataframe##########################################################

# paramspace
paramspace = Paramspace(df_test, filename_params=['MODELS', 'r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], param_sep="_")
############################################################################################################

rule all:
    input:
        # expand('output/FINISH_X_{u_model}', u_model=U_MODELS)
        # 'data/train_Tensors.RData',
        # 'data/test_Tensors.RData'
        # expand('output/train_X/{params}.RData', params = paramspace.instance_patterns),
        # expand('output/train_X/{params}.csv', params = paramspace.instance_patterns),
        # expand('output/test_X_Tensor/{params}.csv', params = paramspace.instance_patterns)
        expand('output/FINISH_X/{params}', params = paramspace.instance_patterns)


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

# rule train_u_models:
#     input:
#         'data/train_Tensors.RData'
#     output:
#         'output/train_{u_model}.RData',
#         'output/train_X_{u_model}.csv'
#     resources:
#         mem_gb=50
#     benchmark:
#         'benchmarks/{u_model}.txt'
#     log:
#         'logs/{u_model}.log'
#     shell:
#         'src/train_{wildcards.u_model}.sh {input} {output} >& {log}'
rule train_u_models:
    input:
        'data/train_Tensors.RData'
    output:
        expand('output/train_X/{params}.RData', params = paramspace.wildcard_pattern),
        expand('output/train_X/{params}.csv', params = paramspace.wildcard_pattern)
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
        args9 = lambda w: w["r3R"]
    benchmark:
        f'benchmarks/train_X/{paramspace.wildcard_pattern}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        f'logs/train_X/{paramspace.wildcard_pattern}.log'
    shell:
        'src/{params.args0}.sh {input} {output} {params.args1} {params.args2} {params.args3} {params.args4} {params.args5} {params.args6} {params.args7} {params.args8} {params.args9} >& {log}'


# rule test_u_models:
#     input:
#         'data/test_Tensors.RData',
#         'output/train_{u_model}.RData'
#     output:
#         'output/test_X_{u_model}.csv'
#     resources:
#         mem_gb=50
#     benchmark:
#         'benchmarks/{u_model}.txt'
#     log:
#         'logs/{u_model}.log'
#     shell:
#         'src/test_{wildcards.u_model}.sh {input} {output} >& {log}'
rule test_u_models:
    input:
        'data/test_Tensors.RData',
        expand('output/train_X/{params}.RData', params = paramspace.wildcard_pattern)
    output:
        expand('output/test_X/{params}.csv', params = paramspace.wildcard_pattern)
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
        args9 = lambda w: w["r3R"]
    benchmark:
        f'benchmarks/test_X/{paramspace.wildcard_pattern}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        f'logs/test_X/{paramspace.wildcard_pattern}.log'
    shell:
        'src/test_{params.args0}.sh {input} {output} >& {log}'

rule check_size:
    input:
        # 'output/train_X_{u_model}.csv',
        # 'output/test_X_{u_model}.csv'
        expand('output/train_X/{params}.csv', params = paramspace.wildcard_pattern),
        expand('output/test_X/{params}.csv', params = paramspace.wildcard_pattern)
    output:
        expand('output/FINISH_X/{params}', params = paramspace.wildcard_pattern)
    resources:
        mem_gb=50
    benchmark:
        f'benchmarks/FINISH_X/{paramspace.wildcard_pattern}.txt'
    log:
        f'logs/FINISH_X/{paramspace.wildcard_pattern}.log'
    shell:
        'src/check_size.sh {input} {output} >& {log}'