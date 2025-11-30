all := libqhnsw

faiss := submodules/faiss/build

uname := $(shell uname)

arch := $(shell uname -m)
arch != uname -m

prefix-Darwin-arm64  := /opt/homebrew
prefix-Darwin-x86_64 := /usr/local
prefix-Darwin := ${prefix-Darwin-${arch}}
omp := ${prefix-Darwin}/Cellar/libomp/
omp-version := $(shell ls ${omp} | head -n 1)
omp := ${omp}/${omp-version}

LDLIBS := -lfaiss -lstdc++
CFLAGS := -Iusr/local/include -I${omp}/include -I${faiss}/../faiss
CFLAGS-Darwin := -std=c++14 -framework Accelerate
LDLIBS-Darwin := -lomp
LDFLAGS := -Lusr/local/lib -L${omp}/lib -L${faiss}/faiss
LDFLAGS-Darwin := -framework Accelerate

OMP_FLAGS := -Xpreprocessor -fopenmp -I${omp}/include
OMP_LIB_NAMES := omp
OMP_LIBRARY := ${omp}/lib/libomp.dylib
OMP_LDFLAGS := -L${omp}/lib -lomp

CMAKE-Darwin := -DOpenMP_C_FLAGS="${OMP_FLAGS}" \
	-DOpenMP_CXX_FLAGS="${OMP_FLAGS}" \
	-DOpenMP_CXX_LIB_NAMES="${OMP_LIB_NAMES}" \
	-DOpenMP_C_LIB_NAMES="${OMP_LIB_NAMES}" \
	-DOpenMP_omp_LIBRARY=${OMP_LIBRARY} \
        -DCMAKE_CXX_FLAGS="$(OMP_FLAGS)" \
	-DCMAKE_EXE_LINKER_FLAGS="$(OMP_LDFLAGS)"

src/libqhnsw.o: ${faiss}/faiss/libfaiss.a

$(faiss)/faiss/libfaiss.a: ${faiss}
	cd ${faiss} && \
		make -j4 && make install DESTDIR=../../..

$(faiss):
	@echo OMP ${omp}
	mkdir -p $@ 2>/dev/null || true
	cd ${faiss} && \
		cmake .. -DFAISS_ENABLE_PYTHON=OFF \
			-DFAISS_ENABLE_TEST=OFF \
			-DFAISS_ENABLE_BENCHMARK=OFF \
			-DFAISS_ENABLE_PERF_TESTS=OFF \
			-DFAISS_ENABLE_EXAMPLES=OFF \
			-DBUILD_TESTING=OFF \
			-DFAISS_BUILD_TESTING=OFF \
			-DFAISS_ENABLE_GPU=OFF ${CMAKE-${uname}}

include ./../mk/include.mk
