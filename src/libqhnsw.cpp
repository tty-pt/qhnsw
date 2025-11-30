#include "./../include/ttypt/qhnsw.h"
#include <faiss/IndexHNSW.h>

extern "C" {

void *qhnsw_create(int dim, int M)
{
	// M é o nº de ligações por nó (típico: 16, 32)
	return new faiss::IndexHNSWFlat(dim, M);
}

void qhnsw_add(void *idx, int n, const float *vecs)
{
	static_cast<faiss::IndexHNSWFlat*>(idx)->add(n, vecs);
}

void qhnsw_search(void *idx, int n, const float *query, int k,
		 float *dist, qhnsw_idx_t *labels)
{
	static_cast<faiss::IndexHNSWFlat*>(idx)->search(n, query, k, dist, labels);
}

void qhnsw_set_ef(void *idx, int ef)
{
	static_cast<faiss::IndexHNSWFlat*>(idx)->hnsw.efSearch = ef;
}

void qhnsw_free(void *idx)
{
	delete static_cast<faiss::IndexHNSWFlat*>(idx);
}

}
