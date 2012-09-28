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
	variables.dir = "";

	variables.ps = ['','tmp'];

	for (i = 0; i < 25; i++) {
	    dir = formatBaseN(int(rand() * (16^4)), 16).toString();
	    ps.append(dir);
	}

	variables.file = arrayToList(ps, '/');

	public void function chmod_pre() {
	    var mode = 'rw';
	    var mkdirp = new mkdirp();
	    var collectedPerms = [];

	    mkdirp.mkdirp(file, mode, function (er) {
	        fs.stat(file, function (er, stat) {
	        	collectedPerms.append(stat.mode);
        		assertTrue(stat && stat.isDirectory(), 'should be directory');
        		assertEquals(stat && stat.mode, mode, 'should be 0744');
	        });
	    });
        // 
	}

	// public void function chmod() {
	//     var mode = 0755

	//     mkdirp(file, mode, function (er) {
	//         fs.stat(file, function (er, stat) {
	//             t.ok(stat && stat.isDirectory(), 'should be directory');
	//             t.end();
	//         });
	//     });
	// }

	public void function setUp() {    
		console.log("========START========");
	}
	public void function tearDown() {
		console.log("=========END=========");
	}
}