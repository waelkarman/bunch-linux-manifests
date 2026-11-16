# Dependency of opencv (object-detector). The ptest distro feature would also build
# the ~340 oneTBB test programs, whose heavy templates run the host out of memory
# (cc1plus OOM-killed) alongside the other parallel tasks: not needed on target.
PTEST_ENABLED = "0"
