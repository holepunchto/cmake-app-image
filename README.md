# cmake-app-image
CMake functions for packaging Pear applications into AppImages for Linux.

## API

### `download_app_image_run(DESTINATION <path>)`
Downloads the essential AppRun runtime component, required for executing AppImages.

#### Options
##### `DESTINATION <path>`
The desired location to save the downloaded AppRun file.

### `download_app_image_tool(DESTINATION <path>)`
Fetches the appimagetool utility, used to create and package AppImages.

#### Options
##### `DESTINATION <path>`
The directory where the appimagetool file will be saved.

### `add_app_image`
The core function to define and generate an AppImage for the application.

```cmake
add_app_image(
    <target> 
    [DESTINATION <path>] 
    NAME <string> 
    DESCRIPTION <string> 
    [ICON <path>] 
    [CATEGORY <string>]
    [TARGET <target>]
    [EXECUTABLE <path>]
    [APP_DIR <path>]
    [RESOURCES 
        [FILE|DIR <from> <to>]... 
    ]
    [DEPENDS <target...>]
)
```

#### Options
##### `<target>` 
The name of the CMake application target.

##### `DESTINATION <path>`
The output path for the generated AppImage file (defaults to '<app_name>.AppImage').

##### `NAME <string>`
User-friendly name for the AppImage.

##### `DESCRIPTION <string>`
A short description of the application.

##### `ICON <path>`
Path to the application icon file.

##### `CATEGORY <string>`
The category for the app in Linux application menus.

##### `TARGET <target>`
An existing CMake target to execute as the main application entry point (if not provided, defaults to the target named in the function call).

##### `EXECUTABLE <path>`
The direct path to the executable file (use if not using the TARGET option).

##### `APP_DIR <path>`
The base directory to use for the AppImage contents (defaults to '<app_name>.AppDir').

##### `RESOURCES [FILE|DIR <from> <to>]...`
Additional files or directories to include in the AppImage.

##### `FILE <from> <to>`
Copies a single file from <from> to <to> inside the AppImage.

##### `DIR <from> <to>`
Copies an entire directory from <from> to <to> inside the AppImage.

##### `DEPENDS <target...>`
CMake targets the AppImage build depends on.

## License

Apache-2.0
