import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.5.3")
container: 'docker://koki/tensor-projects-self-incompatible:20221217'

# Unsupervised Models
U_MODELS = [
    'Model-1-A1G', 'Model-1-A1',
    'Model-2-A1G',
    'Model-3-A1G', 'Model-3-A1',
    'Model-4-A1G', 'Model-4-A1',
    'Model-5-A1',
    'Model-6-A1A3G',
    'Model-7-A1A2G',
    'Model-8-A1GLGR', 'Model-8-A1',
    'Model-9-A1A4GLGR', 'Model-9-A1A4',
    'Model-10-A1GLGR', 'Model-10-A1',
    'Model-11-A1A4GLGR', 'Model-11-A1A4',
    'Model-PCA']

# Supervised Models
S_MODELS = ['Model-LDA', 'Model-PCALDA', 'Model-2DLDA']

rule all:
    input:
        expand('output/{u_model}.RData', u_model=U_MODELS),
        expand('output/X_{u_model}.csv', u_model=U_MODELS),
        expand('output/{s_model}.RData', s_model=S_MODELS),
        expand('output/X_train_{s_model}.csv', s_model=S_MODELS),
        expand('output/X_test_{s_model}.csv', s_model=S_MODELS)

rule preprocess:
    input:
        'data/sp11alnfinal90seq.aln',
        'data/SRKfinal_90seq.aln'
    output:
        'data/inputTensors.RData'
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
        'data/inputTensors.RData'
    output:
        'output/{u_model}.RData',
        'output/X_{u_model}.csv'
    wildcard_constraints:
        u_model='|'.join([re.escape(x) for x in U_MODELS])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{u_model}.txt'
    log:
        'logs/{u_model}.log'
    shell:
        'src/{wildcards.u_model}.sh {input} {output} >& {log}'

rule s_models:
    input:
        'data/inputTensors.RData'
    output:
        'output/{s_model}.RData',
        'output/X_train_{s_model}.csv',
        'output/X_test_{s_model}.csv'
    wildcard_constraints:
        s_model='|'.join([re.escape(x) for x in S_MODELS])
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/{s_model}.txt'
    log:
        'logs/{s_model}.log'
    shell:
        'src/{wildcards.s_model}.sh {input} {output} >& {log}'