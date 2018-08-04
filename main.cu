#include <stdio.h>
#include <nbody.h>

int main(){

        int size4 = sizeof(float4)*N;
        int size3 = sizeof(float3)*N;
        float4 *c_bodies;
        cudaMalloc((void**)&c_bodies,size4);
        float3 *c_vel;
        cudaMalloc((void**)&c_vel,size3);
        float3 *c_a;
        float4 bodies[N];
        float3 vel[N], a[N] = {0.0f};
        initialization(bodies, vel, N);
        //allocate variables in cuda memory
        cudaMalloc((void**)&c_a,size3);
        cudaMemcpy( c_bodies, bodies, size4, cudaMemcpyHostToDevice );
        cudaMemcpy( c_vel, vel, size3, cudaMemcpyHostToDevice );
        cudaMemcpy( c_a, a, size3, cudaMemcpyHostToDevice );
        //do the time integration
        for (int i = 0; i < MAX; i ++){
                printf("frame is: %d\n", i);
                accelerations<<<BLOCK, BLOCKDIM, sizeof(float4)*BLOCKDIM>>>(c_bodies, c_a);
                velocities<<<BLOCK, BLOCKDIM>>>(c_a, c_vel);
                positions<<<BLOCK, BLOCKDIM>>>(c_vel, c_bodies);
        }
        //copy the results from cuda memory to cup memory
        cudaMemcpy( bodies, c_bodies, size4, cudaMemcpyDeviceToHost );
        cudaMemcpy( vel, c_vel, size3, cudaMemcpyDeviceToHost );
        cudaMemcpy( a, c_a, size3, cudaMemcpyDeviceToHost );
        for (int i = 0; i < N; i ++){
          printf("ax is %f\n", a[i].x);
        }
        cudaFree(c_bodies);
        cudaFree(c_vel);
        cudaFree(c_a);  
        return EXIT_SUCCESS;
}

