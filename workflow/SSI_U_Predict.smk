# SSI_U_Predict
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace
#
# Setting
#
# min_version("6.5.3")
# container: 'docker://koki/tensor-projects-self-incompatible:20221217'

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
U_MODELS = ['Model-1-A1G']

# gene LRpair 1patterm test
r1 = ["20"]
# siteLR patterm
r2 = ["100"]
# aminoacid patterm
r3 =  ["5"]
# gene_pair_L
r1L = ["10"]
# gene_pair_R
r1R = ["10"]
# site_ligand_L
r2L = ["10"]
# site_ligand_R
r2R = ["10"]
# aminoacid L
r3L =  ["10"]
# aminoacid R
r3R =  ["10"]

################################################
#### paramspace####
comb_para = list(it.product(U_MODELS, r1, r2, r3, r1L, r1R, r2L, r2R, r3L, r3R))
df_para = pd.DataFrame(comb_para)
df_para = df_para.set_index(0)
df_para = df_para.set_axis(['r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], axis=1)
df_para_trim=df_para
####################

#### trim Model-1-A1G####
l_bool = [False, False, False, True, True, True, True, True, True]
df_para_trim.loc['Model-1-A1G', l_bool]="xx"
########################

df=df_para_trim
df.index.name = 'MODELS'
df.reset_index(inplace=True)
df_test=df[~df.duplicated()]

paramspace = Paramspace(df_test, filename_params=['MODELS', 'r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], param_sep="_")
################################################

rule all:
    input:
        # expand('output/FINISH_X_{u_model}', u_model=U_MODELS)
        'data/train_Tensors.RData',
        'data/test_Tensors.RData'

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

# rule check_size:
#     input:
#         'output/train_X_{u_model}.csv',
#         'output/test_X_{u_model}.csv'
#     output:
#         'output/FINISH_X_{u_model}'
#     resources:
#         mem_gb=50
#     benchmark:
#         'benchmarks/check_size_{u_model}.txt'
#     log:
#         'logs/check_size_{u_model}.log'
#     shell:
#         'src/check_size.sh {input} {output} >& {log}'