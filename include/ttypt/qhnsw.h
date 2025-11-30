#ifndef QHNSW_H
#define QHNSW_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined(__APPLE__) || defined(_WIN32) || defined(__ANDROID__) || defined(__MUSL__)
    typedef long long qhnsw_idx_t;
#else
    typedef long qhnsw_idx_t;  // Linux glibc
#endif


void *qhnsw_create(int dim, int M);
void  qhnsw_add(void *idx, int n, const float *vecs);
void  qhnsw_search(void *idx, int n, const float *query, int k,
		  float *dist, qhnsw_idx_t *labels);
void  qhnsw_set_ef(void *idx, int ef);
void  qhnsw_free(void *idx);

#ifdef __cplusplus
}
#endif

#endif
