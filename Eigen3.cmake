include_guard(GLOBAL)
option(USE_INSTALLED_EIGEN3 "Use installed Eigen3" OFF)
option(USE_EIGEN3_WITH_MKL "use intel mkl library if installed" ON)
find_package(MKL)
# set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_COMPILE_DEFINITIONS "EIGEN_NO_MALLOC")
if (NOT MKL_FOUND)
    message("No intel mkl library found")
    set(USE_EIGEN3_WITH_MKL OFF)
endif()
if (USE_INSTALLED_EIGEN3)
    set(Eigen3_DIR ${USE_INSTALLED_EIGEN3}/share/eigen3/cmake)
    if (EXISTS ${Eigen3_DIR})
        message("Use Eigen3 from ${USE_INSTALLED_EIGEN3}")
    else()
        message("Use Eigen3 from default location")
        unset(Eigen3_DIR)
    endif()
    find_package(Eigen3 REQUIRED
        NO_MODULE
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_BUILDS_PATH)
    message("Found Eigen3 in ${EIGEN3_INCLUDE_DIR}")
else()
    include(FetchContentHelper)
    FetchContentHelper(eigen HG "https://bitbucket.org/eigen/eigen" "default"
        ADD_SUBDIR CONFIG_SUBDIR
            BUILD_TESTING=OFF
        PATCH_SUBDIR
            ${FCH_PATCH_DIR}/patch.sh "eigen3*.patch"
        REGISTER_PACKAGE
            Eigen3 INCLUDE_CONTENT
                "set(EIGEN3_FOUND TRUE)\nset(EIGEN3_INCLUDE_DIR \${eigen_SOURCE_DIR})"
        )
endif()
set_property(
    TARGET eigen
    APPEND PROPERTY
    INTERFACE_COMPILE_OPTIONS -march=native
)
if (USE_EIGEN3_WITH_MKL)
    message("Enable mkl libraries for eigen")
    set_property(
        TARGET eigen
        APPEND PROPERTY
        INTERFACE_COMPILE_DEFINITIONS EIGEN_USE_MKL_ALL
    )
    set_property(
        TARGET eigen
        APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES ${MKL_LIBRARIES}
    )
endif()
include(PrintProperties)
print_target_properties(Eigen3::Eigen)
add_library(cmake_utils::Eigen ALIAS eigen)
