using BinaryBuilder

version_mapping = Dict(
    v"4.19.108" => ("2fab54c74bf956951e61c6d4fe473995e8d07010", "bc92c569bbdb53744dee458827c64119a16ee5267cdcba851e1832c3a174571c"),
    v"5.5.8"   => ("487388338282edd6fd4132504bbe9e1494f14593", "c09461fe685b446f4ce9fd5c952763affe60a8dc42c38a631bba7d6ff238f699"),
)

name = "Linux"
#version = v"4.19.108"
version = v"5.5.8"

include("../common.jl")

# Collection of sources required to build linux
sources = [
    ArchiveSource("https://github.com/raspberrypi/linux/archive/$(version_mapping[version][1]).tar.gz",
                  version_mapping[version][2]),
    DirectorySource("./sources"),
]

# Build the given platforms using the given sources
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; skip_audit=true)

