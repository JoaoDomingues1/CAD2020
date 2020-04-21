/**
 * Tests for functions
 */


#include "../cad_test.h"

#include <array>
#include <algorithm>

#include <skeletons.hpp>

using namespace cad;


template<typename T>
T add(T a, T b) {
    return a + b;
}

TEST(Map, C1000_C1000) {

    constexpr unsigned size = 1000;

    std::array<int, size> a;
    std::array<int, size> b;
    std::fill(a.begin(), a.end(), 1);
    std::fill(b.begin(), b.end(), 2);

    std::array<int, size> result;
    map(add<int>, result, a, b);

    std::array<int, size> expected;
    std::fill(expected.begin(), expected.end(), 3);
    expect_container_eq(result, expected);
}

TEST(Map, C1000_F) {

    constexpr unsigned size = 1000;

    std::array<int, size> a;
    std::fill(a.begin(), a.end(), 1);

    std::array<int, size> result;
    map(add<int>, result, a, 2);

    std::array<int, size> expected;
    std::fill(expected.begin(), expected.end(), 3);
    expect_container_eq(result, expected);
}