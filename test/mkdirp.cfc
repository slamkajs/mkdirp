/**
*
* @file  /home/likewise-open/UCADS/slamkajs/Sites/mkdirp/test/mkdirp.cfc
* @author  Justin Slamka
* @description
*
*/

component output="false" displayname="mkdirp test" extends="mxunit.framework.TestCase" {
	variables.path = new foundry.lib.path();
	variables.fs = new foundry.lib.fs();
	variables.console = new foundry.lib.console();
	variables._ = new foundry.lib.util().init();

	public any function woo() {
		var mkdirp = new mkdirp.mkdirp();
		var file = "";

	   	for(i=1; i <= 2; i++) {
	   		console.log("Test run ##" & i);
		    
		    file = '/tmp/' & arrayToList(
		    	[formatBaseN(int(rand() * (16^4)), 16).toString(),
		    	formatBaseN(int(rand() * (16^4)), 16).toString(),
		    	formatBaseN(int(rand() * (16^4)), 16).toString()], '/');

		    mkdirp.mkdirp(file, 0755, function (err) {
		        if(structKeyExists(arguments, 'err') && !_.isEmpty(err)) fail(err);
		        else fs.exists(file, function(ex) {
			            if(!structKeyExists(arguments, 'ex') || !ex) fail('file not created');
			            else fs.stat(file, function (err, stat) {
				                if (structKeyExists(arguments, 'err') && !_.isEmpty(err)) fail(err);
				                else {
				                    assertEquals(stat.mode, "rw", "Should be equal.");
				                    assertTrue(stat.isDirectory, "target not a directory.");
				                }
			            	});
		        	});
		    });
		}
	}

	public void function setUp() {    
		console.log("========START========");
	}
	public void function tearDown() {
		console.log("=========END=========");
	}
}