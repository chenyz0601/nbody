const int eps2 = 3;//softening number^2
const int BLOCK = 1;//#blocks 
const int BLOCKDIM= 10;//#dimension of each block
const int N = 10;//#bodies
const float G = 6.66;//gravity constant
const float dt = 0.1;//size of timestep
const int MAX = 20;//maximum step 
__global__
void accelerations(void *X, void *A);
__global__
void velocities(void *A, void *V);
__global__
void positions(void *V, void *P);
void initialization(float4 *P, float3 *V, int num);
