set(app_image_module_root ${CMAKE_CURRENT_LIST_DIR})

if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
  file(
    DOWNLOAD
      https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-aarch64.AppImage
      "${CMAKE_CURRENT_BINARY_DIR}/appimagetool.AppImage"
    EXPECTED_HASH SHA256=334e77beb67fc1e71856c29d5f3f324ca77b0fde7a840fdd14bd3b88c25c341f
  )
else()
  file(
    DOWNLOAD
      https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
      "${CMAKE_CURRENT_BINARY_DIR}/appimagetool.AppImage"
    EXPECTED_HASH SHA256=df3baf5ca5facbecfc2f3fa6713c29ab9cefa8fd8c1eac5d283b79cab33e4acb
  )
endif()

file(CHMOD "${CMAKE_CURRENT_BINARY_DIR}/appimagetool.AppImage" PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)

set(app_image_tool "${CMAKE_CURRENT_BINARY_DIR}/appimagetool.AppImage")

function(add_app_image target)
  cmake_parse_arguments(
    PARSE_ARGV 1 ARGV "" "DESTINATION;NAME;ICON;TARGET;EXECUTABLE" "CATEGORIES"
  )

	if(NOT ARGV_DESTINATION)
		set(ARGV_DESTINATION ${ARGV_NAME}.AppDir)
	endif()

  cmake_path(ABSOLUTE_PATH ARGV_DESTINATION BASE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}" NORMALIZE)

	if(ARGV_ICON)
	  cmake_path(ABSOLUTE_PATH ARGV_ICON NORMALIZE)
	endif()

  if(ARGV_TARGET)
    set(ARGV_EXECUTABLE $<TARGET_FILE:${ARGV_TARGET}>)

		set(ARGV_EXECUTABLE_NAME $<TARGET_FILE_NAME:${ARGV_TARGET}>)
	else()
	  cmake_path(ABSOLUTE_PATH ARGV_EXECUTABLE NORMALIZE)

		cmake_path(GET ARGV_EXECUTABLE FILENAME ARGV_EXECUTABLE_NAME)
  endif()

	if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
	  file(
	    DOWNLOAD
	      https://github.com/AppImage/AppImageKit/releases/download/13/AppRun-aarch64
	      "${ARGV_DESTINATION}/AppRun"
	    EXPECTED_HASH SHA256=9214c4c1f7a3cdd77f8d558c2039230a322469f8aaf7c71453eeaf1f2f33d204
	  )
	else()
	  file(
	    DOWNLOAD
	      https://github.com/AppImage/AppImageKit/releases/download/13/AppRun-x86_64
	      "${ARGV_DESTINATION}/AppRun"
	    EXPECTED_HASH SHA256=fd0e2c14a135e7741ef82649558150f141a04c280ed77a5c6f9ec733627e520e
	  )
	endif()

	list(JOIN ARGV_CATEGORIES ";" ARGV_CATEGORIES)

  file(READ "${app_image_module_root}/App.desktop" template)

  string(CONFIGURE "${template}" template)

  file(GENERATE OUTPUT "${ARGV_DESTINATION}/${ARGV_NAME}.desktop" CONTENT "${template}" NEWLINE_STYLE UNIX)

	if(ARGV_ICON)
		configure_file("${ARGV_ICON}" "${ARGV_DESTINATION}/icon.png" COPYONLY)
	endif()

	add_custom_target(
		${target}_bin
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${ARGV_EXECUTABLE}" "${ARGV_DESTINATION}/usr/bin/${ARGV_EXECUTABLE_NAME}"
	)

	list(APPEND ARGV_DEPENDS ${target}_bin)

	add_custom_target(
		${target}
		ALL
		COMMAND "${app_image_tool}" "${ARGV_DESTINATION}"
		DEPENDS ${ARGV_DEPENDS}
	)
endfunction()
