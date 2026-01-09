# tests/CMakeLists.txt - Test configuration for REFPROP
# Uses CTest for test discovery and execution

# Test utility library (shared assertions)
add_library(test_utils STATIC utils.FOR)
target_include_directories(test_utils PUBLIC ${CMAKE_SOURCE_DIR})

# ---------------------------------------------------------
# Test: Enthalpy calculations
# ---------------------------------------------------------
add_executable(test_enthalpy test_enthalpy.FOR)
target_link_libraries(test_enthalpy refprop_static test_utils)
target_include_directories(test_enthalpy PRIVATE ${CMAKE_SOURCE_DIR})
set_target_properties(test_enthalpy PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
add_test(
    NAME Enthalpy_Tests
    COMMAND test_enthalpy
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# ---------------------------------------------------------
# Test: REFPROP main subroutine
# ---------------------------------------------------------
add_executable(test_refprop test_refprop.FOR)
target_link_libraries(test_refprop refprop_static test_utils)
target_include_directories(test_refprop PRIVATE ${CMAKE_SOURCE_DIR})
set_target_properties(test_refprop PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
add_test(
    NAME REFPROP_Tests
    COMMAND test_refprop
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# ---------------------------------------------------------
# Set test properties
# ---------------------------------------------------------
# Mark tests that need REFPROP fluid files
set_tests_properties(Enthalpy_Tests REFPROP_Tests PROPERTIES
    LABELS "refprop"
    TIMEOUT 60
)
