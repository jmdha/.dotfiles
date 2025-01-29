alias downward="~/Programs/downward/fast-downward.py"
alias VAL="~/Programs/VAL/build/bin/Validate"

gc() {
    git clone --recurse-submodules git@github.com:jmdha/$1.git
}

lama() {
    downward --alias lama-first $1 $2
}
