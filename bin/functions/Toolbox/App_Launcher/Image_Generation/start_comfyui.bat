@echo off

:start_comfyui
cd /d "%comfyui_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda activate comfyui

REM Read modules-comfyui and find the comfyui_start_command line
set "comfyui_start_command="

for /F "tokens=*" %%a in ('findstr /I "comfyui_start_command=" "%comfyui_modules_path%"') do (
    set "%%a"
)

if not defined comfyui_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit comfyui Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit comfyui Modules menu.%reset%
    pause
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_comfyui_modules.bat" (
        call %editor_image_generation_dir%\edit_comfyui_modules.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_comfyui_modules.bat not found in: editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_comfyui_modules.bat not found in: %editor_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
)

set "comfyui_start_command=%comfyui_start_command:comfyui_start_command=%"

REM Start ComfyUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% ComfyUI launched in a new window.
start cmd /k "title comfyui && cd /d %comfyui_install_path% && %comfyui_start_command%"
goto :home
