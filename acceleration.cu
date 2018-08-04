#include<stdio.h>
#include<nbody.h>

__device__
float3 acc(float4 pi, float4 pj, float3 ai){
   // input: positions of i-th an j-th body and the current acceleration of i-th body 
   // output: acceleration of i-th body
        float3 r;
        r.x = pj.x - pi.x;
        r.y = pj.y - pi.y;
        r.z = pj.z - pi.z;
        float distSqr = r.x*r.x+r.y*r.y+r.z*r.z+eps2;
        float dist = pow(distSqr, -1.5f);
        float temp = G*dist*pj.w;
        ai.x += temp*r.x;
        ai.y += temp*r.y;
        ai.z += temp*r.z;
        return ai;
}

__device__
float3 tile(float4 privateP, float3 a){
  //input: a thread's own position and its acceleration
  //output: acceleration
        int i;
        extern __shared__ float4 sharedP[];
        for (i = 0; i < blockDim.x; i ++) {
                a = acc(privateP, sharedP[i], a);
        }
        return a;
}

__global__
void accelerations(void *X, void *A){
  //input: pointers to position and acceleration in global memory
  //output: acceleration 
        extern __shared__ float4 sharedP[];//prepare shared datas
        float4 *globalX = (float4 *)X;
        float3 *globalA = (float3 *)A;
        float4 privateP;
        int i, t;//i the index of bodies; t the index of tiles
        float3 a = {0.0f,0.0f,0.0f};
        int id = blockIdx.x*blockDim.x+threadIdx.x;//id the index of thread
        privateP = globalX[id];
        for (i = 0, t = 0; i < N; i += BLOCKDIM, t ++){
                int idx = t*blockDim.x+threadIdx.x;
                sharedP[threadIdx.x]  = globalX[idx];
                __syncthreads();//joint all threads in one block after initializing shared datas 
                a = tile(privateP, a);
                __syncthreads();//joint all threads in one block before entering next tile
        }
        globalA[id]  = a;//assign acceleration to the global memory
        printf("%d's acc is (%f, %f, %f)\n", id, a.x, a.y, a.z);
}
