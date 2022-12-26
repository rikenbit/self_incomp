# SSI_unsupervised
###################################################
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

min_version("6.5.3")
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

U_MODELS = ['Model-1-A1G', 'Model-8-A1GLGR', 'Model-11-A1A4']
# Model-1-A1G r1 r2 r3

# gene LRpair patterm
# gene_pair = ["5","10","50"]
r1 = ["5","10","50"]
# siteLR patterm
# site_ligand = ["10","50","120"]
r2 = ["10","50","120"]
# aminoacid patterm
# aminoacid = ["5","10"]
r3 =  ["5","10"]

# gene_pair_L
r1_L = ["5","10","50"]
# gene_pair_R
r1_R = ["5","10","50"]
# site_ligand_L
r2_L = ["10","50","120"]
# site_ligand_R
r2_R = ["10","50","120"]
# aminoacid L
r3_L =  ["5","10"]
# aminoacid R
r3_R =  ["5","10"]

# comb_para = list(it.product(U_MODELS, aminoacid, gene_LR))
# df_para = pd.DataFrame(comb_para)
# df_para = df_para.set_index(0)
# df_para = df_para.set_axis(['aminoacid', 'gene_LR'], axis=1)
# # trim Model-1-A1G
# df_para.at['Model-1-A1G', 'gene_LR']=np.repeat("xxx", len(df_para.at['Model-1-A1G', 'gene_LR']))
# df_test=df_para[~df_para.duplicated()]

comb_para = list(it.product(U_MODELS, r1, r2, r3, r1_L, r1_R, r2_L, r2_R, r3_L, r3_R))
df_para = pd.DataFrame(comb_para)
df_para = df_para.set_index(0)
df_para = df_para.set_axis(['r1', 'r2', 'r3', 'r1_L', 'r1_R', 'r2_L', 'r2_R', 'r3_L', 'r3_R'], axis=1)
model_nrow =len(df_para) // len(U_MODELS)

#### trim Model-1-A1G####
df_para_trim = df_para
l_bool = [True, False, False, True, True, True, True, True, True]

# df_para_trim.loc['Model-1-A1G', 'r1':'r3']=np.repeat("xxx", model_nrow)
df_para_trim.loc['Model-1-A1G', l_bool]="xxx"
df_test=df_para[~df_para.duplicated()]
########################

rule all:
    input:
        expand('output/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.RData',
            range=time_range,
            dist=dist_data,
            N_cls=N_CLUSTERS,
            Re_cls=ReClustering_method
            )

rule SSI_unsupervised:
    input:
        Mem_matrix = 'output/WTS4/normalize_1/{range}/{dist}/Membership/k_Number_{N_cls}.RData'
    output:
        m_data = 'output/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.RData'
    benchmark:
        'benchmarks/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.txt'
    container:
        "docker://docker_images"
    resources:
        mem_gb=200
    log:
        'logs/WTS4/normalize_1/{range}/{dist}/{Re_cls}/Merged_data/k_Number_{N_cls}.log'
    shell:
        'src/SSI_unsupervised.sh {wildcards.Re_cls} {input.Mem_matrix} {output.m_data}>& {log}'

rule SSI_scikit_rf:
    input:
        x = 'output/SSI/X_Tensor/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.csv',
        y = 'output/SSI/y_r.csv'
    output:
        'output/SSI/LOOCV_rf/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.csv'
    benchmark:
        'benchmarks/SSI/LOOCV_rf/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/SSI/LOOCV_rf/Model{MOD}_AA{AA}_Gene{GE}_sL{sL}_sR{sR}.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_scikit_rf.py {input.x} {input.y} {output} >& {log}'