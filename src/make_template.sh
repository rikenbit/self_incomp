#!/bin/bash

cp src/template.sh src/$@.sh
sed -i -e 's/temp_r_name/'$@'/g' src/$@.sh

cp src/template.R src/$@.R
sed -i -e 's/template/'$@'/g' src/$@.R

cp src/functions_template.R src/functions_$@.R

cp workflow/template.smk workflow/$@.smk
sed -i -e 's/template/'$@'/g' workflow/$@.smk