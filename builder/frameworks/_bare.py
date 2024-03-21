#
# Default flags for bare-metal programming (without any framework layers)
#

import sys
from SCons.Script import DefaultEnvironment

env = DefaultEnvironment()
board = env.BoardConfig()
cpu = board.get("build.cpu", "cortex-m4")

env.Append(
    ASFLAGS=["-x", "assembler-with-cpp"],

    CCFLAGS=[
        "-O3",                  # optimize for speed
        "-ffunction-sections",  # place each function in its own section
        "-fdata-sections",
        "-Wall",
        "-mthumb",
        "-mcpu=" + cpu,
    ],

    CXXFLAGS=[
        "-fno-rtti",
        "-fno-exceptions"
    ],

    CPPDEFINES=[
        ("F_CPU", "$BOARD_F_CPU")
    ],

    LINKFLAGS=[
        "-Wl,--gc-sections",
        "--specs=nano.specs",
        "--specs=nosys.specs",
        "-Wl,-Map,%s/linkmap.map" % env.get("BUILD_DIR"),
        "-Wl,--no-warn-rwx-segment",
    ],

    LIBS=["c", "gcc", "m", "stdc++"]
)

if "BOARD" in env:
    env.Append(
        CPPDEFINES=[
            env.BoardConfig().get("build.variant", "").upper()
        ]
    )

env.Append(ASFLAGS=env.get("CCFLAGS", [])[:])
env.Append(LINKFLAGS=env.get("CCFLAGS", [])[:])
