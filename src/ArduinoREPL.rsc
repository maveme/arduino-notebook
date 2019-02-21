module ArduinoREPL

import IO;
import String;
import Exception;
import Message;
import ParseTree;
import bacata::util::Util;
import bacata::util::Proposer;
import util::ShellExec;
import bacata::salix::Bridge;
import salix::App;
import salix::HTML;
import salix::Core;
import salix::Node;


REPL myRepl() {
  
 CommandResult myHandler(str line) {
    try {
    	writeFile(|tmp:///johnny-five/eg/hola.js|, createScript(line));
    	rs = executeScript(|tmp:///hola.js|);
    	return commandResult( rs, messages = []);
    }
    catch ParseError(loc l):
		return commandResult("", messages = [error("Parse error", l)]);
	}

	util::REPL::Completion myCompletor(str prefix, int offset)
    =  <0, [ prefix ]>; 

  return repl(myHandler, myCompletor, visualization = makeSalixMultiplexer(|http://localhost:3438|, |tmp:///|));
}

str executeScript(loc path) {
	PID result = createProcess("/usr/local/bin/node", args =["<resolveLocation(|tmp:///johnny-five/eg/hola.js|).path>"]);
	err = readLineFromErr(result); 
	as = readEntireStream(result);	
	return 	as;
}

str createScript(str line)
	="
	'var five = require(\"../lib/johnny-five.js\");
	'var board = new five.Board();
	'
	'board.on(\"ready\", function() {
  	'console.log(\"Ready event. Repl instance auto-initialized!\");
	'
  	'var led = new five.Led(13);
	'
  	'this.repl.inject({
   	' // Allow limited on/off control access to the
    '// Led instance from the REPL.
   	' on: function() {
   	'   led.on();
   	' },
   	' off: function() {
   	'   led.off();
  	'  }
 	' });
	'});
	'
	";