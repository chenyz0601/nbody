#include<stdio.h>
#include<nbody.h>

void initialization(float4 *P, float3 *V, int num){
        float4 *pos = (float4 *)P;
        float3 *v = (float3 *)V;
        int id;
        for (id = 0; id < num; id ++){
          pos[id].w = 1.0;//POS.w;
          pos[id].x = 1.0*id;//POS.x*id;
          pos[id].y = 1.0*id;//POS.y*id;
          pos[id].z = 1.0*id;//POS.z*id;
          v[id].x = 1.0;//VEL.x;
          v[id].y = 1.0;//VEL.y;
          v[id].z = 1.0;//VEL.z;
          printf("%d's initialize: pos = (%f, %f, %f,) vel = (%f, %f, %f)\n", id, pos[id].x, pos[id].y, pos[id].z, v[id].x, v[id].y, v[id].z);
        }
}

