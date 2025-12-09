# -*-Mode: cmake;-*-

#****************************************************************************
# DataFlowDrs - Top-level CMake Configuration
#****************************************************************************
# A comprehensive suite of tools for performance optimization of HPC
# workflows with focus on data flow and storage bottlenecks.
#
# This is a monorepo structure inspired by LLVM's approach with Qt-style
# git submodules for component organization.
#****************************************************************************

cmake_minimum_required(VERSION 3.15)
project(DataFlowDrs VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#****************************************************************************
# Build Options - LLVM-style component selection
#****************************************************************************

# Individual component options
# To add a new component, add a BUILD_<COMPONENT> option here
option(BUILD_DATALIFE "Build DataLife (Measurement & DFL analysis)" ON)
option(BUILD_DAYU "Build DaYu (Semantic dataflow analysis for HDF5/netCDF)" ON)

# Meta-option to build all available components
option(BUILD_ALL "Build all available DataFlowDrs components" OFF)

# Build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
      "Choose the type of build: Debug Release RelWithDebInfo MinSizeRel" FORCE)
endif()

# Installation prefix
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH
      "Install path prefix" FORCE)
endif()

#****************************************************************************
# Global Configuration
#****************************************************************************

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Add cmake module path for shared configurations
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

#****************************************************************************
# Component Dependencies & Build Order
#****************************************************************************

# Track which components are actually available (submodule checked out)
set(DATAFLOWDRS_AVAILABLE_COMPONENTS "")

# Helper macro to check if a component's submodule exists
macro(check_component_available COMPONENT_NAME COMPONENT_PATH)
  if(EXISTS "${CMAKE_SOURCE_DIR}/components/${COMPONENT_PATH}/CMakeLists.txt")
    list(APPEND DATAFLOWDRS_AVAILABLE_COMPONENTS ${COMPONENT_NAME})
    set(${COMPONENT_NAME}_AVAILABLE TRUE)
  else()
    set(${COMPONENT_NAME}_AVAILABLE FALSE)
  endif()
endmacro()

# Check availability of each component
# To add a new component, add a check_component_available() call here
check_component_available(DATALIFE "datalife")
check_component_available(DAYU "dayu")

# Display available components
message(STATUS "DataFlowDrs Configuration")
message(STATUS "=========================")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")
message(STATUS "Available Components:")
foreach(COMP ${DATAFLOWDRS_AVAILABLE_COMPONENTS})
  message(STATUS "  - ${COMP}")
endforeach()
message(STATUS "")

#****************************************************************************
# Add Components (in dependency order)
#****************************************************************************

# DataLife (Measurement & DFL analysis)
if((BUILD_ALL OR BUILD_DATALIFE) AND DATALIFE_AVAILABLE)
  message(STATUS "Building: DataLife")
  add_subdirectory(components/datalife)
elseif(BUILD_DATALIFE AND NOT DATALIFE_AVAILABLE)
  message(WARNING "DataLife requested but submodule not available. Run: ./init-repository.sh")
endif()

# DaYu (Semantic dataflow analysis)
if((BUILD_ALL OR BUILD_DAYU) AND DAYU_AVAILABLE)
  message(STATUS "Building: DaYu")
  add_subdirectory(components/dayu)
elseif(BUILD_DAYU AND NOT DAYU_AVAILABLE)
  message(WARNING "DaYu requested but submodule not available. Run: ./init-repository.sh")
endif()

# To add a new component, add a similar block here:
#
# if((BUILD_ALL OR BUILD_NEWCOMPONENT) AND NEWCOMPONENT_AVAILABLE)
#   message(STATUS "Building: NewComponent")
#   add_subdirectory(components/newcomponent)
# elseif(BUILD_NEWCOMPONENT AND NOT NEWCOMPONENT_AVAILABLE)
#   message(WARNING "NewComponent requested but submodule not available. Run: ./init-repository.sh")
# endif()

#****************************************************************************
# Summary
#****************************************************************************

message(STATUS "")
message(STATUS "Configuration Summary")
message(STATUS "=====================")
message(STATUS "Components to build:")
if(BUILD_DATALIFE AND DATALIFE_AVAILABLE)
  message(STATUS "  [✓] DataLife")
endif()
if(BUILD_DAYU AND DAYU_AVAILABLE)
  message(STATUS "  [✓] DaYu")
endif()
message(STATUS "")
message(STATUS "To build:")
message(STATUS "  cmake -DBUILD_DATALIFE=ON ..")
message(STATUS "  or")
message(STATUS "  cmake -DBUILD_ALL=ON ..")
message(STATUS "")

#****************************************************************************
# Installation
#****************************************************************************

# Install scripts
install(PROGRAMS
  scripts/build-all.sh
  scripts/build-component.sh
  DESTINATION bin
  OPTIONAL
)

# Install documentation
install(FILES
  README.md
  BUILD.md
  DESTINATION share/doc/dataflowdrs
  OPTIONAL
)
