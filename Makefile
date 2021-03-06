# Proxy to CMake

all:
	@test -f build/Makefile || (mkdir -p build && cd build && cmake .. && cd .. && ./script/download_resource.sh); cd build && make

debug:
	@rm -rf build && mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && cd .. && make

profile:
	@rm -rf build && mkdir -p build && cd build && cmake -DCMAKE_CXX_FLAGS=-pg .. && cd .. && make

verbose:
	cd build && make VERBOSE=1

clean:
	@rm -rf build

purge:
	@rm -rf build
	@rm -rf bin
	@rm -rf res
	@rm -rf tmp
	@rm -rf include/res

test: all
	@find bin -regex "bin/[a-z]*" -type f -exec ./{} \;

# for filename in bin/*; do;./${filename}|diff test/$(echo ${filename} | cut -d/ -f2).log -;done

output: all
	@find bin -regex "bin/[a-z]*" -type f -exec bash -c './{} > test/$(echo {} | cut -d/ -f2).log' \;

format:
	@find . -iname "*.h" -o -iname "*.cc" -o -iname "*.cu" | xargs clang-format --style=Google -i

# for i in "LLVM" "Google" "Chromium" "Mozilla" "WebKit"; do; git reset --hard; echo $i; find . -iname "*.h" -o -iname "*.cc" | xargs clang-format --style=$i -i; git diff --shortstat | cat; done

%:
	cd build && make $@
