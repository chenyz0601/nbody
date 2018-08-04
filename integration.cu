#include<stdio.h>
#include<nbody.h>

__global__
void velocities(void *A, void *V){
  //input: pointers to acceleration and velocity
  //output: update velocity
        float3 *a = (float3 *)A;
        float3 *v = (float3 *)V;
        int id = blockIdx.x*blockDim.x+threadIdx.x;
        v[id].x += dt*a[id].x;
        v[id].y += dt*a[id].y;
        v[id].z += dt*a[id].z;
}

__global__
void positions(void *V, void *P){
  //input: pointers to velocity and position
  //output: update position
        float4 *pos = (float4 *)P;
        float3 *v = (float3 *)V;
        int id = blockIdx.x*blockDim.x+threadIdx.x;
        pos[id].x += dt*v[id].x;
        pos[id].y += dt*v[id].y;
        pos[id].z += dt*v[id].z;
        printf("%d's position is (%f, %f, %f)\n", id, pos[id].x, pos[id].y, pos[id].z);

}

