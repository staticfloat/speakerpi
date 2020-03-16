using BinaryBuilder

name = "Linux"
version = v"5.5.0"

# Collection of sources required to build linux
sources = [
    ArchiveSource("https://github.com/torvalds/linux/archive/d5226fa6dbae0569ee43ecfc08bdcd6770fc4755.tar.gz",
                  "e2c3bc06da44f160e53312058b787c45834f9da8cfddb91b0dc3025bc54e85b9"),
    DirectorySource("./sources"),
]

include("../common.jl")

# Build the given platforms using the given sources
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; skip_audit=true)

