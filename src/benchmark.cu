#include <cstdio>
#include <vector>
#include <string>
#include <iostream>

#include <skeletons.hpp>
#include <skeletons_gpu.hpp>
#include <marrow/timer.hpp>

using namespace std;


/////////////////
// The filter functions
/////////////////

template<typename... Ts>
using filter_func = bool (*) (Ts...);


template<typename T>
__device__  bool basic_op(T x, unsigned granularity) {

    int val = 0;
    for (unsigned i = 0; i < granularity; i++)
        val += i;

    return x > val;
}

template <typename T>
__device__ filter_func<T, unsigned> p_basic_op = basic_op<T>;

template<typename T>
__device__  bool sfu_op(T x, unsigned granularity) {

    int val = 0;
    for (unsigned i = 0; i < granularity; i++)
        val += sqrtf(i)/i;

    return x > val;
}

template <typename T>
__device__ filter_func<T, unsigned> p_sfu_op = sfu_op<T>;


/////////////////
// The main function
//   the benchmark receives four arguments
//      function: (0 - basic_op, 1 - special op)
//      nelems: Memory size - size of the container to process
//      granularity: Computational weight - number of iterations to be executed by each GPU thread.
//      nruns -- Number of times the benchmark is executed (optional, default is 1)
/////////////////

int main(int argc, char* argv[]) {
    if (argc < 4 || argc > 5) {
        printf("usage: %s function (0 - basic_op, 1 - special op) nelems granularity [nruns]\n", argv[0]);
        return 1;
    }

    unsigned char function = static_cast< unsigned char>(stoul (argv[1], nullptr,0));
    size_t nelems = stoul (argv[2], nullptr,0);
    unsigned granularity = stoul (argv[3], nullptr,0);
    unsigned nruns = argc == 3 ? 1 : stoul (argv[4], nullptr,0);

    auto in = make_shared<vector<float>>(nelems);

    marrow::timer<std::chrono::microseconds> t;

    if (function == 0) {
        for (unsigned i = 0; i < nruns; i++) {
            printf ("Run number %u\n", i);
            std::fill(in->begin(), in->end(), 1);

            t.start();
            auto out = cad::filter1_gpu(999.0f, p_basic_op<float>, *in, granularity);
            // cad::filter2_gpu(p_basic_op<float>, *in, granularity);
            t.stop();
        }
    }
    else {
        for (unsigned i = 0; i < nruns; i++) {
            printf ("Run number %u\n", i);
            std::fill(in->begin(), in->end(), 1);

            t.start();
            auto out = cad::filter1_gpu(999.0f, p_sfu_op<float>, *in, granularity);
            // cad::filter2_gpu(p_sfu_op<float>, *in, granularity);
            t.stop();
        }
    }

    t.average();
    t.std_deviation();
    t.output_stats(cout, marrow::main_stage, false);
}
