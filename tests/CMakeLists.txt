# tests/CMakeLists.txt - Test configuration for REFPROP
# Uses CTest for test discovery and execution
# Test files are auto-discovered: any file matching test_*.FOR

# Test utility library (shared assertions)
add_library(test_utils STATIC utils.FOR)
target_include_directories(test_utils PUBLIC ${CMAKE_SOURCE_DIR})

# ---------------------------------------------------------
# Auto-discover all test files matching test_*.FOR
# ---------------------------------------------------------
file(GLOB TEST_SOURCES "test_*.FOR")

foreach(TEST_SOURCE ${TEST_SOURCES})
    # Extract filename without extension (e.g., test_enthalpy)
    get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
    
    # Create a nice display name for CTest (e.g., Enthalpy_Tests from test_enthalpy)
    string(REPLACE "test_" "" TEST_LABEL ${TEST_NAME})
    string(SUBSTRING ${TEST_LABEL} 0 1 FIRST_CHAR)
    string(TOUPPER ${FIRST_CHAR} FIRST_CHAR_UPPER)
    string(SUBSTRING ${TEST_LABEL} 1 -1 REST_OF_STRING)
    set(TEST_DISPLAY_NAME "${FIRST_CHAR_UPPER}${REST_OF_STRING}_Tests")
    
    # Create the test executable
    add_executable(${TEST_NAME} ${TEST_SOURCE})
    target_link_libraries(${TEST_NAME} refprop_static test_utils)
    target_include_directories(${TEST_NAME} PRIVATE ${CMAKE_SOURCE_DIR})
    set_target_properties(${TEST_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
    
    # Register the test with CTest
    add_test(
        NAME ${TEST_DISPLAY_NAME}
        COMMAND ${TEST_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
    
    # Set test properties
    set_tests_properties(${TEST_DISPLAY_NAME} PROPERTIES
        LABELS "refprop"
        TIMEOUT 60
    )
    
    message(STATUS "Added test: ${TEST_NAME} -> ${TEST_DISPLAY_NAME}")
endforeach()
