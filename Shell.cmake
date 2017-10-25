include(CMakeParseArguments)

function(add_shell_command customTargetName)
	cmake_parse_arguments(THIS "" "" "OUTPUT;DEPENDS;COMMAND" ${ARGN})

	if (NOT DEFINED THIS_OUTPUT OR NOT DEFINED THIS_COMMAND OR NOT DEFINED THIS_DEPENDS)
		message(FATAL_ERROR "Invalid arguments given to add_shell_command(newTargetName OUTPUT output DEPENDS generatedDependencies COMMAND shell_command")
	endif()


	if (MSVC)
		get_filename_component(BIN_DIR ${FFMPEG_BASH_EXE} DIRECTORY)
		file(TO_NATIVE_PATH "${BIN_DIR}" BIN_DIR)

		add_custom_target(${customTargetName} ALL DEPENDS ${THIS_OUTPUT}) 
		add_custom_command(OUTPUT ${THIS_OUTPUT}
					COMMAND BatchBridgeToShell ARGS ${BIN_DIR} ${THIS_COMMAND}
					DEPENDS "${THIS_DEPENDS}"
					WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
	else()
		add_custom_target(${customTargetName} ALL DEPENDS ${THIS_OUTPUT}) 
		add_custom_command(OUTPUT ${THIS_OUTPUT}
					COMMAND bash ARGS -c \"${THIS_COMMAND}\"
					DEPENDS "${THIS_DEPENDS}"
					WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
	endif()
endfunction(add_shell_command)
