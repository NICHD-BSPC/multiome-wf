# create env (assumes mamba installed)
mamba env create --prefix ./env --file docs.env.yaml

# activate env
conda activate ./env

# build docs
make html

# root document found at '_build/html/index.html'

