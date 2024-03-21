Import("env")

name = env.get("PIOENV", "program")
env.Replace(PROGNAME=name)
