# This codebase is only allowed to be used by the developer team of Halmos.
# Don't copy this code/idea to be used in academia/industry artifacts without permission.

# Cache folder:
```bash
mkdir .cache
```

# Trigger the BUG:
Please try those two commands:
```bash
halmos -vvvvv --function check_gt --contract MUMUGTest --forge-build-out .cache --print-potential-counterexample --solver-timeout-branching 1000
halmos -vvvvv --function check_cand2 --contract MUMUGTest --forge-build-out .cache --print-potential-counterexample --solver-timeout-branching 1000
```
