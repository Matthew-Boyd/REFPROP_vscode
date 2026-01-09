# CMakeLists.txt for REFPROP FORTRAN Build
# Supports both Intel Fortran (ifort/ifx) and gfortran
cmake_minimum_required(VERSION 3.15)
project(REFPROP Fortran)

# Enable verbose output for debugging build issues
set(CMAKE_VERBOSE_MAKEFILE ON)

# Set Fortran standard
set(CMAKE_Fortran_STANDARD 95)

# Debug flags for stepping through code
if(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    # Intel Fortran debug flags
    set(CMAKE_Fortran_FLAGS_DEBUG "-g -traceback -check:all -warn:all -debug:full -Od")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
    message(STATUS "Using Intel Fortran compiler")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
    # GNU Fortran (gfortran) debug flags
    set(CMAKE_Fortran_FLAGS_DEBUG "-g -fbacktrace -fcheck=all -Wall -Wextra -O0 -ffree-line-length-none")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
    message(STATUS "Using GNU Fortran compiler")
endif()

# Default to Debug build
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Source files - Main REFPROP library
set(REFPROP_SOURCES
    CORE_ANC.FOR
    CORE_FEQ.FOR
    CORE_PR.FOR
    FLSH_SUB.FOR
    MIX_HMX.FOR
    PROP_SUB.FOR
    REFPROP.FOR
    SAT_SUB.FOR
    SETUP.FOR
    TRNS_TCX.FOR
    TRNS_VIS.FOR
    TRNSP.FOR
    UTILITY.FOR
)

# Include directories for .INC files
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Build static library
add_library(refprop_static STATIC ${REFPROP_SOURCES})

# Build shared library (DLL on Windows)
add_library(refprop SHARED 
    ${REFPROP_SOURCES}
    DLLFILES/PASS_FTN.FOR
)

# Test executable
add_executable(test_driver test_driver.FOR ${REFPROP_SOURCES})

# Set output directories
set_target_properties(refprop PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

set_target_properties(test_driver PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Windows-specific: export symbols for DLL
if(WIN32 AND CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    target_compile_definitions(refprop PRIVATE BUILD_DLL)
endif()
