@echo off
rem To sign the Windows installer, set the `SIGN_WINDOWS_INSTALLER=true` environment variable.
rem This will download the Kolibri Windows installer artifact at the windows-2016 Buildkite agent.
rem After the installer successfully sign it will upload the installer at the Sign Windows Installer pipeline artifact.

IF NOT "%SIGN_WINDOWS_INSTALLER%" == "true" (GOTO DONT_SIGN)

set current_path=%cd%
buildkite-agent.exe artifact download "dist/*.exe" . --step "Build Windows installer" --build %BUILDKITE_BUILD_ID% --agent-access-token %BUILDKITE_AGENT_ACCESS_TOKEN%
%WINDOWS_SIGN_SCRIPT_PATH% "%current_path%\dist" && cd "%current_path%\dist\" && ren *.exe *-.exe && buildkite-agent.exe artifact upload "*.exe"
GOTO END

:DONT_SIGN
echo Set the SIGN_WINDOWS_INSTALLER=true environment variable to sign the Windows installer.

:END
