all := libqhnsw

CFLAGS := -Iusr/local/include
LDFLAGS := -Lusr/local/lib
LDLIBS := -lfaiss -lstdc++

faiss := submodules/faiss/build

src/libqhnsw.o: ${faiss}/faiss/libfaiss.a

$(faiss)/faiss/libfaiss.a: ${faiss}
	cd ${faiss} && \
		make -j4 && make install DESTDIR=../../..

$(faiss):
	mkdir -p $@ 2>/dev/null || true
	cd ${faiss} && \
		export CC=/usr/bin/gcc-12 && \
		export CXX=/usr/bin/g++-12 && \
		export CUDAHOSTCXX=/usr/bin/g++-12 && \
		cmake .. -DFAISS_ENABLE_PYTHON=OFF \
			-DFAISS_ENABLE_TEST=OFF \
			-DFAISS_ENABLE_BENCHMARK=OFF \
			-DFAISS_ENABLE_PERF_TESTS=OFF \
			-DFAISS_ENABLE_EXAMPLES=OFF \
			-DFAISS_ENABLE_GPU=ON

include ./../mk/include.mk
