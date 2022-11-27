#!/bin/bash

script_path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
luarocks_version="3.9.1"
luarocks_name="luarocks-${luarocks_version}"

cd $(mktemp -d)
curl "http://luarocks.github.io/luarocks/releases/${luarocks_name}.tar.gz" | tar -zx
cp -r "./${luarocks_name}/src/luarocks" "${script_path}/ext/pure_lua/luarocks"
