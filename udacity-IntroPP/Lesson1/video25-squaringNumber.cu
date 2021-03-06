#include <stdio.h>

__global__ void square(float * d_out, float * d_in) {
int idx = threadIdx.x;
float f = d_in[idx];
d_out[idx] = f * f;
}


int main(int argc, char ** argv) {
   const int ARRAY_SIZE = 64;
   const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);
   //"Declare the size of the arrange in constant ARRAY_SIZE 
   //and determine how many bytes it uses declaring constant
   //ARRAY_BYTES."

   int i;
   

   // generate the input array on the host
   // As an convention the host variables carry an initial letter h, and the 
   // device variables carry an initial letter d
   float h_in[ARRAY_SIZE];
   for (i=0; i< ARRAY_SIZE; i++) {
   h_in[i] = float(i);
   }

   float h_out[ARRAY_SIZE];

   //declare GPU memory pointers
   float * d_in;
   float * d_out;

   cudaMalloc((void **) &d_in, ARRAY_BYTES);
   cudaMalloc((void **) &d_out, ARRAY_BYTES);

   //transfer the array to the GPU
   cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

  //lunch the kernel
   square<<<1, ARRAY_SIZE>>>(d_out, d_in);

   //copy back the result array to the CPU
   cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

   //print out the resulting array
   for (int i=0; i < ARRAY_SIZE; i++) {
      printf("%f", h_out[i]);
      printf(((i % 4) != 3) ? "\t" : "\n");
   }

   //free GPU memory allocation
   cudaFree(d_in);
   cudaFree(d_out);

   return 0;

}
