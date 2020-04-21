/**
 * Tests for functions
 */


#include "../cad_test.h"

#include <array>
#include <functional>
#include <algorithm>
#include <type_traits>

#include <skeletons.hpp>
#include <marrow/timer.hpp>

using namespace cad;


template<typename T>
bool bigger_than(T x, T val) {
    return x > val;
}


TEST(Filter1, BT10_1000) {

    constexpr unsigned size = 1000;
    std::array<int, size> a;

    std::fill(a.begin(), a.end(), 1);
    a[100] = 20;

    auto result = filter1(999, bigger_than<int>,  a, 10);

    std::array<int, size> expected;
    std::fill(expected.begin(), expected.end(), 999);
    expected[100] = 20;
    expect_container_eq(result, expected);
}

TEST(Filter2, BT10_1000) {

    constexpr unsigned size = 1000;
    std::array<int, size> a;

    std::fill(a.begin(), a.end(), 0);
    a[100] = 20;
    a[101] = 11;
    a[102] = 12;

    auto result = filter2(bigger_than<int>,  a, 10);

    expect_container_eq(result,
           std::array<located_value<int>, 3> {{ { 100, 20 }, {101, 11}, {102, 12} }});
}


