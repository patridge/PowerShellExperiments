# Clear Plex settings in case it stopped showing a window correctly (e.g., on the wrong display but can't be moved).
Remove-Item "${Env:\LOCALAPPDATA}\Plex\plex.ini"