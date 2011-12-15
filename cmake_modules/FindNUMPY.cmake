if(NOT NUMPY_INCLUDE_DIR)
  exec_program ("${PYTHON_EXECUTABLE}" 
       ARGS "-c 'import numpy; print numpy.get_include()'"
       OUTPUT_VARIABLE NUMPY_INCLUDE_DIR
       RETURN_VALUE NUMPY_NOT_FOUND)
endif(NOT NUMPY_INCLUDE_DIR)

FIND_PATH(NUMPY_PATH
ndarrayobject.h
HINTS $ENV{NUMPY_INCLUDE}
PATHS ${PYTHON_INCLUDE_DIRS}/numpy ${PYTHON_INCLUDE_PATH}/numpy ${NUMPY_INCLUDE_DIR}/numpy 
)

FIND_PATH(NUMPY_PATH_DEP1
endian.h
PATHS ${PYTHON_INCLUDE_DIRS}/numpy ${PYTHON_INCLUDE_PATH}/numpy ${NUMPY_INCLUDE_DIR}/numpy 
)

STRING(REGEX REPLACE "include" "lib" NUMPY_LIBS_INTERMEDIATE "${NUMPY_PATH}")
STRING(REGEX REPLACE "numpy$" "" NUMPY_LIBS_BASE "${NUMPY_LIBS_INTERMEDIATE}")

STRING(REGEX REPLACE "include" "lib/pyshared" NUMPY_LIBS_INTERMEDIATE_2 "${NUMPY_PATH}")
STRING(REGEX REPLACE "numpy$" "" NUMPY_LIBS_BASE_2 "${NUMPY_LIBS_INTERMEDIATE_2}")

STRING(REGEX REPLACE "include" "lib/pymodules" NUMPY_LIBS_INTERMEDIATE_3 "${NUMPY_PATH}")
STRING(REGEX REPLACE "numpy$" "" NUMPY_LIBS_BASE_3 "${NUMPY_LIBS_INTERMEDIATE_3}")

FIND_LIBRARY(NUMPY_LIBS_1
NAMES multiarray multiarray.so
HINTS $ENV{NUMPY_LIBS}
PATHS ${NUMPY_LIBS_BASE}dist-packages/numpy/core
      ${NUMPY_LIBS_BASE_2}numpy/core
      ${NUMPY_LIBS_BASE_3}numpy/core
      ${NUMPY_INCLUDE_DIR}/..
)

SET(NUMPY_LIBS "${NUMPY_LIBS_1}")
SET(NUMPY_INCLUDED_DIRS "${NUMPY_PATH};${NUMPY_PATH_DEP1}")

IF(NUMPY_PATH)
SET(NUMPY_FOUND TRUE)
MESSAGE(STATUS "Numpy path found: ${NUMPY_PATH}")
MESSAGE(STATUS "Python libs: ${PYTHON_LIBRARIES}")
MESSAGE(STATUS "Numpy includes: ${NUMPY_INCLUDED_DIRS}")
MESSAGE(STATUS "Numpy libs: ${NUMPY_LIBS}")
ELSE()
MESSAGE(STATUS "Numpy not found")
ENDIF()
