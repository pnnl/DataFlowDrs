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
option(BUILD_LINUX_RESOURCE_DETECT "Build Linux Resource Detect (Storage resource discovery)" ON)
option(BUILD_DATALIFE "Build DataLife (Measurement & DFL analysis)" ON)
option(BUILD_DAYU "Build DaYu (Semantic dataflow analysis for HDF5/netCDF)" ON)
option(BUILD_FLOWFORECASTER "Build FlowForecaster (Workflow scaling model inference)" ON)
option(BUILD_SPM "Build SPM (Storage Performance Matcher)" ON)

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

# Helper macro to check if a component's submodule is initialized
# Checks for .git directory/file which is present in all initialized git submodules
macro(check_component_available COMPONENT_NAME COMPONENT_PATH)
  # Check if submodule is initialized by looking for .git
  if(EXISTS "${CMAKE_SOURCE_DIR}/components/${COMPONENT_PATH}/.git")
    list(APPEND DATAFLOWDRS_AVAILABLE_COMPONENTS ${COMPONENT_NAME})
    set(${COMPONENT_NAME}_AVAILABLE TRUE)
  else()
    set(${COMPONENT_NAME}_AVAILABLE FALSE)
  endif()
endmacro()

# Check availability of each component
# To add a new component, add a check_component_available() call here
check_component_available(LINUX_RESOURCE_DETECT "linux_resource_detect")
check_component_available(DATALIFE "datalife")
check_component_available(DAYU "dayu")
check_component_available(FLOWFORECASTER "flowforecaster")
check_component_available(SPM "spm")

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

# Linux Resource Detect (Storage resource discovery)
# Note: Shell script-based tool that doesn't require compilation
if((BUILD_ALL OR BUILD_LINUX_RESOURCE_DETECT) AND LINUX_RESOURCE_DETECT_AVAILABLE)
  message(STATUS "Setting up: Linux Resource Detect (Shell script-based)")

  # Check for bash
  find_program(BASH_EXECUTABLE bash)

  if(BASH_EXECUTABLE)
    message(STATUS "  Bash: ${BASH_EXECUTABLE}")
    message(STATUS "  ✓ Bash found (version check: bash --version)")
    message(STATUS "  Scripts available at: ${CMAKE_SOURCE_DIR}/components/linux_resource_detect")
  else()
    message(WARNING "  Bash not found. Linux Resource Detect requires bash 4.2.46+")
  endif()
elseif(BUILD_LINUX_RESOURCE_DETECT AND NOT LINUX_RESOURCE_DETECT_AVAILABLE)
  message(WARNING "Linux Resource Detect requested but submodule not available. Run: ./init-repository.sh")
endif()

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

# FlowForecaster (Workflow scaling model inference)
if((BUILD_ALL OR BUILD_FLOWFORECASTER) AND FLOWFORECASTER_AVAILABLE)
  message(STATUS "Setting up: FlowForecaster (Python-based)")

  # Find Python3
  find_package(Python3 COMPONENTS Interpreter)

  if(Python3_FOUND)
    message(STATUS "  Python: ${Python3_EXECUTABLE}")

    # Install Python dependencies
    execute_process(
      COMMAND ${Python3_EXECUTABLE} -m pip install --user numpy networkx matplotlib pandas sortedcontainers
      RESULT_VARIABLE PIP_INSTALL_RESULT
      OUTPUT_VARIABLE PIP_INSTALL_OUTPUT
      ERROR_VARIABLE PIP_INSTALL_ERROR
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE
    )

    if(PIP_INSTALL_RESULT EQUAL 0)
      message(STATUS "  ✓ Python dependencies installed successfully")
    else()
      message(WARNING "  Failed to install Python dependencies automatically")
      message(STATUS "  Please manually run: pip install numpy networkx matplotlib pandas sortedcontainers")
    endif()

    message(STATUS "  Scripts available at: ${CMAKE_SOURCE_DIR}/components/flowforecaster")
  else()
    message(WARNING "  Python3 not found. Please install Python dependencies manually:")
    message(STATUS "  pip install numpy networkx matplotlib pandas sortedcontainers")
  endif()
elseif(BUILD_FLOWFORECASTER AND NOT FLOWFORECASTER_AVAILABLE)
  message(WARNING "FlowForecaster requested but submodule not available. Run: ./init-repository.sh")
endif()

# SPM (Storage Performance Matcher)
if((BUILD_ALL OR BUILD_SPM) AND SPM_AVAILABLE)
  message(STATUS "Setting up: SPM (Python-based)")

  # Find Python3
  find_package(Python3 COMPONENTS Interpreter)

  if(Python3_FOUND)
    message(STATUS "  Python: ${Python3_EXECUTABLE}")

    # Install Python dependencies for SPM
    execute_process(
      COMMAND ${Python3_EXECUTABLE} -m pip install --user numpy pandas matplotlib scipy
      RESULT_VARIABLE PIP_INSTALL_RESULT
      OUTPUT_VARIABLE PIP_INSTALL_OUTPUT
      ERROR_VARIABLE PIP_INSTALL_ERROR
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE
    )

    if(PIP_INSTALL_RESULT EQUAL 0)
      message(STATUS "  ✓ Python dependencies installed successfully")
    else()
      message(WARNING "  Failed to install Python dependencies automatically")
      message(STATUS "  Please manually run: pip install numpy pandas matplotlib scipy")
    endif()

    message(STATUS "  Scripts available at: ${CMAKE_SOURCE_DIR}/components/spm/workflow_analysis")
  else()
    message(WARNING "  Python3 not found. Please install Python dependencies manually:")
    message(STATUS "  pip install numpy pandas matplotlib scipy")
  endif()
elseif(BUILD_SPM AND NOT SPM_AVAILABLE)
  message(WARNING "SPM requested but submodule not available. Run: ./init-repository.sh")
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
if(BUILD_LINUX_RESOURCE_DETECT AND LINUX_RESOURCE_DETECT_AVAILABLE)
  message(STATUS "  [✓] Linux Resource Detect (Shell)")
endif()
if(BUILD_DATALIFE AND DATALIFE_AVAILABLE)
  message(STATUS "  [✓] DataLife")
endif()
if(BUILD_DAYU AND DAYU_AVAILABLE)
  message(STATUS "  [✓] DaYu")
endif()
if(BUILD_FLOWFORECASTER AND FLOWFORECASTER_AVAILABLE)
  message(STATUS "  [✓] FlowForecaster (Python)")
endif()
if(BUILD_SPM AND SPM_AVAILABLE)
  message(STATUS "  [✓] SPM (Python)")
endif()
message(STATUS "")
message(STATUS "To build:")
message(STATUS "  ./scripts/build-component.sh <component>")
message(STATUS "  ./scripts/build-all.sh")
message(STATUS "")
message(STATUS "Or use CMake directly:")
message(STATUS "  cmake -DBUILD_<COMPONENT>=ON ..")
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
  DESTINATION share/doc/dataflowdrs
  OPTIONAL
)
