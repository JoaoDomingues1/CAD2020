//
// Created by Hervé Paulino on 18/03/2020.
//

#ifndef CADPROJECT_CUDA_SKELETONS_HPP
#define CADPROJECT_CUDA_SKELETONS_HPP

#include <type_traits>

#include "located_value.hpp"

namespace cad {

    /**
     * Function that provides the means to obtain the element to applied in a elementary map application
     * Only supports fundamental types and containers
     * @tparam T The type of the value to process
     */
    template <typename T, std::enable_if_t<std::is_fundamental<T>::value>* = nullptr>
    constexpr T argument_get(T argument, std::size_t index) {
        return argument;
    }

    template <typename T, std::enable_if_t<not std::is_fundamental<T>::value>* = nullptr>
    constexpr typename std::remove_reference_t<T>::value_type argument_get(T&& argument, std::size_t index) {
       return argument[index];
    }

    /**
     * Map skeleton for C++ functions
     * @tparam Func  Type of the function to apply
     * @tparam ResultContainer The type of the result container
     * @tparam Ts Types of the arguments to pass to the function
     *
     * @param func The function to apply
     * @param result The result container
     * @param arguments Arguments to pass to the function
     */
    template <typename Func, typename ResultContainer, typename... Ts>
    void map(Func& func, ResultContainer& result, Ts&&... arguments) {

        for (std::size_t i = 0; i < result.size(); i++)
            result[i] = func(argument_get(std::forward<Ts>(arguments), i)...);

    }

    /**
     * Filter1 skeleton
     *
     * @tparam Func  Type of the function to apply
     * @tparam Container The type of the container to process
     * @tparam Ts Types of the arguments to pass to the function
     *
     * @param value Value to set
     * @param func The function to apply
     * @param container Container to process
     * @param arguments Arguments to pass to the function
     *
     * @return
     */
    template <typename Func, typename Container,  typename... Ts>
    auto filter1(typename Container::value_type value, Func& func, Container& container, Ts&&... arguments) {
        using ValueType = typename Container::value_type;

        const auto size = container.size();
        std::vector<ValueType> result (size);

        for (std::size_t i = 0; i < size; i++)
            result[i] = func(container[i], std::forward<Ts>(arguments)...) ? container[i] : value;

        return result;
    }

    /**
     * Filter2 skeleton
     *
     * @tparam Func  Type of the function to apply
     * @tparam Container The type of the container to process
     * @tparam Ts Types of the arguments to pass to the function
     *
     * @param func The function to apply
     * @param container Container to process
     * @param arguments Arguments to pass to the function
     *
     * @return
     */
    template <typename Func, typename Container,  typename... Ts>
    auto filter2(Func& func, Container& container, Ts&&... arguments) {
        using ValueType = typename Container::value_type;
        using LocatedValue = located_value<ValueType>;

        std::vector<LocatedValue> result;
        for (std::size_t i = 0; i < container.size(); i++) {
            if (func(container[i], std::forward<Ts>(arguments)...))
                result.push_back(LocatedValue { i, container[i] });
        };

        return result;
    }

}
#endif //CADPROJECT_CUDA_SKELETONS_HPP
