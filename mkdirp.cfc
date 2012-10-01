/**
*
* @file  /home/likewise-open/UCADS/slamkajs/Sites/foundry/mkdirp.cfc
* @author  Justin Slamka
* @description Mimics mkdir -p
*
*/

component output="false" displayname="mkdirp" extends="foundry.core"  {
	variables.path = require('path');
	variables.fs = require('fs');
	variables._ = require('util').init();

	public void function mkdirp (p, mode, f, made) {
	    if (_.isFunction(mode) || mode EQ '') {
	        f = mode;
	        mode = 0777; // & (~process.umask());
	    }

	    if (!structKeyExists(arguments, 'made')) made = '';

	    var noop = function() {}

	    var cb = (_.isFunction(f)) ? f : noop;
	    //if (!isNumeric(mode)) mode = FormatBaseN(LSParseNumber(mode), 8);
	    p = path.resolve(p);

	    fs.mkdir(p, mode, function(er) {
	        if (!structKeyExists(arguments, 'er') || _.isEmpty(arguments.er)) {
	            made = (!_.isEmpty(made)) ? made : p;
	            cb("", made);
	            return false;
	        }

	        switch (er.errorCode) {
	            case 'ENOENT':
	                mkdirp(path.dirname(p), mode, function (er, made) {
	                    if (er) cb(er, made);
	                    else mkdirP(p, mode, cb, made);
	                });
	                break;

	            default:
	                fs.stat(p, function(er2, stat) {
	                    if (structKeyExists(arguments, 'er2') || !directoryExists(stat)) {
	                    	cb(er, made);
	                    } else {
	                    	cb("", made);
	                    }
	                });
	                break;
	        }
	    });
	}

	public any function sync(p, mode, made) {
	    if (mode EQ null) {
	        mode = 0777; // & (~process.umask());
	    }
	    if (!made) made = null;

	    if (!isNumeric(mode)) mode = FormatBaseN(LSParseNumber(mode), 8);
	    p = path.resolve(p);

	    try {
	        fs.mkdir(p, mode);
	        made = made || p;
	    } catch (err0) {
	        switch (err0.code) {
	            case 'ENOENT':
	                made = sync(path.dirname(p), mode, made);
	                sync(p, mode, made);
	                break;

	            // In the case of any other error, just see if there's a dir
	            // there already. If so, then hooray! If not, then something
	            // is borked.
	            default:
	                var stat = '';
	                try {
	                    stat = fs.statSync(p);
	                }
	                catch (err1) {
	                    throw err0;
	                }
	                if (!directoryExists(stat)) throw err0;
	                break;
	        }
	    }

	    return made;
	};
}