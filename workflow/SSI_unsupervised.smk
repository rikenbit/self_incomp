# SSI_unsupervised
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

# min_version("6.5.3")
container: 'docker://koki/tensor-projects-self-incompatible:20221217'

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

U_MODELS = ['Model-1-A1G', 'Model-8-A1GLGR']

# gene LRpair patterm
r1 = ["10","40"]
# siteLR patterm
r2 = ["10","40"]
# aminoacid patterm
r3 =  ["10","20"]
# gene_pair_L
r1L = ["5","20"]
# gene_pair_R
r1R = ["5","20"]
# site_ligand_L
r2L = ["5","20"]
# site_ligand_R
r2R = ["5","20"]
# aminoacid L
r3L =  ["5","10"]
# aminoacid R
r3R =  ["5","10"]


#### paramspace########################################################################################
comb_para = list(it.product(U_MODELS, r1, r2, r3, r1L, r1R, r2L, r2R, r3L, r3R))
df_para = pd.DataFrame(comb_para)
df_para = df_para.set_index(0)
df_para = df_para.set_axis(['r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], axis=1)
model_nrow =len(df_para) // len(U_MODELS)
df_para_trim=df_para

#### trim Model-1-A1G####
l_bool = [False, False, False, True, True, True, True, True, True]
df_para_trim.loc['Model-1-A1G', l_bool]="xx"
#### trim Model-8-A1GLGR####
l_bool = [False, True, False, True, True, False, False, True, True]
df_para_trim.loc['Model-8-A1GLGR', l_bool]="xx"
#### trim Model-11-A1A4####
# l_bool = [True, True, True, False, False, False, False, False, False]
# df_para_trim.loc['Model-11-A1A4', l_bool]="xx"
########################

df_test=df_para_trim[~df_para_trim.duplicated()]
df_test.index.name = 'MODELS'
df_test.reset_index(inplace=True)

paramspace = Paramspace(df_test, filename_params=['MODELS', 'r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R'], param_sep="_")
############################################################################################################

rule all:
    input:
        expand('output/X_Tensor/{params}.RData', params = paramspace.instance_patterns),
        expand('output/X_Tensor/{params}.csv', params = paramspace.instance_patterns)
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
    log:
        'logs/preprocess.log'
    shell:
        'src/preprocess.sh {input} {output} >& {log}'

rule u_models:
    input:
        'output/inputTensors.RData'
    output:
        # 'output/X_Tensor/{u_model}.RData',
        # 'output/X_Tensor/X_{u_model}.csv'
        expand('output/X_Tensor/{params}.RData', params = paramspace.wildcard_pattern),
        expand('output/X_Tensor/{params}.csv', params = paramspace.wildcard_pattern)
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
        f'benchmarks/X_Tensor/{paramspace.wildcard_pattern}.txt'
    resources:
        mem_gb=200
    log:
        f'logs/X_Tensor/{paramspace.wildcard_pattern}.log'
    shell:
        'src/{params.args0}.sh {input} {output} {params.args1} {params.args2} {params.args3} {params.args4} {params.args5} {params.args6} {params.args7} {params.args8} {params.args9} >& {log}'

# rule all:
#     input:
#         expand('output/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.RData',
#             range=time_range,
#             dist=dist_data,
#             N_cls=N_CLUSTERS,
#             Re_cls=ReClustering_method
#             )

# rule SSI_unsupervised:
#     input:
#         Mem_matrix = 'output/WTS4/normalize_1/{range}/{dist}/Membership/k_Number_{N_cls}.RData'
#     output:
#         m_data = 'output/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.RData'
#     benchmark:
#         'benchmarks/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.txt'
#     container:
#         "docker://docker_images"
#     resources:
#         mem_gb=200
#     log:
#         'logs/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.log'
#     shell:
#         'src/SSI_unsupervised.sh {wildcards.Re_cls} {input.Mem_matrix} {output.m_data}>& {log}'

# rule SSI_scikit_rf:
#     input:
#         x = 'output/SSI/X_Tensor/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.csv',
#         y = 'output/SSI/y_r.csv'
#     output:
#         'output/SSI/LOOCV_rf/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.csv'
#     benchmark:
#         'benchmarks/SSI/LOOCV_rf/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.txt'
#     container:
#         "docker://yamaken37/ssi_sklearn_env:202212141249"
#     resources:
#         mem_gb=200
#     log:
#         'logs/SSI/LOOCV_rf/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.log'
#     shell:
#         'source .bashrc && conda activate sklearn-env && python src/SSI_scikit_rf.py {input.x} {input.y} {output} >& {log}'