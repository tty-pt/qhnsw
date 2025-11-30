#ifndef QHNSW_H
#define QHNSW_H

#ifdef __cplusplus
extern "C" {
#endif

void *qhnsw_create(int dim, int M);
void  qhnsw_add(void *idx, int n, const float *vecs);
void  qhnsw_search(void *idx, int n, const float *query, int k,
		  float *dist, long *labels);
void  qhnsw_set_ef(void *idx, int ef);
void  qhnsw_free(void *idx);

#ifdef __cplusplus
}
#endif

#endif
