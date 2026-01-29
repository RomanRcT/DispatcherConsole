@echo off
set TC_ROOT=c:\Siemens\Teamcenter\teamcenter_root
set TC_DATA=c:\Siemens\Teamcenter\tc_data
call %TC_DATA%\tc_profilevars
import_uiconfig -file=ui_config_awtcdispatcher.xml -action=merge
aws2_install_tilescollections -u=infodba -p=infodba -g=dba -mode=add -file=DispatcherConsole_Tiles_install.xml
robocopy "aws2" "%TC_ROOT%\aws2" /E /R:0 /W:0
cd %TC_ROOT%\aws2\stage\src\solution
powershell -NoProfile -Command "$j=Get-Content 'kit.json' -Raw | ConvertFrom-Json; if ($j.modules -notcontains 'dispatcherconsole') { $j.modules=@('dispatcherconsole')+$j.modules }; $utf8NoBom = New-Object System.Text.UTF8Encoding($false); [System.IO.File]::WriteAllText('kit.json', ($j | ConvertTo-Json -Depth 20), $utf8NoBom)"
%TC_ROOT%\aws2\stage\awbuild.cmd
pause

