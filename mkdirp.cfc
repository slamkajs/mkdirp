/**
*
* @file  /home/likewise-open/UCADS/slamkajs/Sites/foundry/mkdirp.cfc
* @author  Justin Slamka
* @description Mimics mkdir -p
*
*/

component output="false" displayname="mkdirp" extends="foundry.core"  {
	var path = require('path');
	var fs = require('fs');
	var _ = require('util');

	function mkdirP (p, mode, f, made) {
	    if (_.isFunction(mode) || mode EQ null) {
	        f = mode;
	        mode = 0777 & (~process.umask());
	    }
	    if (!made) made = null;

	    var cb = f || function () {};
	    if (!isNumeric(mode)) mode = FormatBaseN(LSParseNumber(mode), 8);
	    p = path.resolve(p);

	    fs.mkdir(p, mode, function (er) {
	        if (!er) {
	            made = made || p;
	            return cb(null, made);
	        }
	        switch (er.code) {
	            case 'ENOENT':
	                mkdirP(path.dirname(p), mode, function (er, made) {
	                    if (er) cb(er, made);
	                    else mkdirP(p, mode, cb, made);
	                });
	                break;


	            // In the case of any other error, just see if theres a dir
	            // there already.  If so, then hooray!  If not, then something
	            // is borked.
	            default:
	                fs.stat(p, function (er2, stat) {
	                    // if the stat fails, then that's super weird.
	                    // let the original error be the failure reason.
	                    if (er2 || !directoryExists(stat)) {
	                    	cb(er, made);
	                    } else {
	                    	cb(null, made);
	                    }
	                });
	                break;
	        }
	    });
	}
}