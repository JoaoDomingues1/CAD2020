
add_executable(benchmark ${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cu)
target_link_libraries(benchmark ${GTEST_BOTH_LIBRARIES})

