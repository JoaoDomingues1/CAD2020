//
// Created by Hervé Paulino on 21/03/2020.
//


#ifndef CAD_CUDA_PROJECT_LOCATED_VALUE_HPP
#define CAD_CUDA_PROJECT_LOCATED_VALUE_HPP

#include <cstddef>
namespace cad {

    /**
     * A container value with associated one dimensional coordinate
     *
     * @tparam T Type of the value
     */
    template <typename T>
    struct located_value {
        const std::size_t coordinate;

        const T value;

        template <typename U>
        bool operator== (const located_value<U>& other) {
            return coordinate == other.coordinate && value == other.value;
        }
    };
}
#endif //CAD_CUDA_PROJECT_LOCATED_VALUE_HPP
