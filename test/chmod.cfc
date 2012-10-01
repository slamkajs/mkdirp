/**
*
* @file  /home/likewise-open/UCADS/slamkajs/Sites/mkdirp/tests/chmod.cfc
* @author  Justin Slamka
* @description Tests the chmod functionality of mkdirp
*
*/

component output="false" displayname="chmod  test" extends="mxunit.framework.TestCase"  {
	variables.path = new foundry.core.path();
	variables.fs = new foundry.core.fs();
	variables.console = new foundry.core.console();
	variables._ = new foundry.core.util().init();
	variables.dir = "";

	variables.ps = ['','tmp'];

	for (i = 0; i < 25; i++) {
	    dir = formatBaseN(int(rand() * (16^4)), 16).toString();
	    ps.append(dir);
	}

	variables.file = arrayToList(ps, '/');

	public void function chmod_pre() {
	    var mode = 0744;
	    var mkdirp = new mkdirp();
	    var collectedPerms = [];

	    mkdirp.mkdirp(file, mode, function (er) {
	        fs.stat(file, function (er, stat) {
	        	collectedPerms.append(stat.mode);

        		assertTrue(structKeyExists(arguments, 'stat') && stat.isDirectory, 'should be directory');
        		assertEquals(true, structKeyExists(arguments, 'stat') && !_.isEmpty(stat.mode), 'should exist');
        		assertEquals(true, stat.mode EQ 'rw', 'should be rw');
	        })
;	    });

	    dump(collectedPerms);
	}

	public void function chmod() {
	    var mode = 0755;
	    var mkdirp = new mkdirp();
	    var collectedDirs = [];

	    mkdirp.mkdirp(file, mode, function (er) {
	        fs.stat(structKeyExists(arguments, 'file'), function (er, stat) {
	        	collectedDirs.append(stat.isDirectory);

	            assertTrue(structKeyExists(arguments, 'stat') && stat.isDirectory, 'should be directory');
	        });
	    });

	    dump(collectedDirs);
	}

	public void function setUp() {    
		console.log("========START========");
	}
	public void function tearDown() {
		console.log("=========END=========");
	}
}