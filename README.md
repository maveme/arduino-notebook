# arduino-notebook
This is a brief proof of concept to use Arduino with Jupyter + Rascal + Bacatá.

`k = kernel("Arduino", |home:///eclipse-workspace-bacata/Arduino/src|, "ArduinoREPL::myRepl", salixPath=|home:///Documents/Rascal/salix/src|);`


`nb = createNotebook(k);`


`nb.serve`
