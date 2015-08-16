module.paths.push('/usr/local/lib/node_modules')

args = process.argv
if (!args[2]) {
    console.log('Usage: '+ args[0]+ ' ' + args[1] + ' FILE');
    process.exit(1);
}

var fs = require('fs')
var path = require('path')
var parser = require("./orm").parser;
var swig  = require('swig');

var filesList = []

function readFile(dir,filesList){
	stat = fs.statSync(path.normalize(dir))
	if (stat.isDirectory()) {
		files = fs.readdirSync(dir);//需要用到同步读取
	 	files.forEach(walk);
	 	function walk(file) { 
	  		states = fs.statSync(dir+'/'+file);   
	  		if(states.isDirectory()){
	   			readFile(dir+'/'+file,filesList);
	  		}else { 
			   filesList.push(path.normalize(dir+'/'+file));
	  		}  
	 	}
	 }else{
	 	filesList.push(path.normalize(dir));
	 }
}

function parseFile (file) {
	var source = fs.readFileSync(path.normalize(file), "utf8");

	if (source.indexOf('ORMDataBase') != -1) {
		var parts = source.split('@interface')

		var data = new Array();
		for (var key in parts){
			var items = parts[key].split('@end')
			for (var index in items){
				data.push(items[index])
			}
		}
		var codes = '';
		for (var i in data){
			if (i % 2) {
				codes += '@interface' + data[i] + '@end';
			};
		}

		parser.parse(codes);

		headerTemplate = fs.readFileSync(path.normalize('orm.h.template'), "utf8")
		impTemplate = fs.readFileSync(path.normalize('orm.m.template'), "utf8")

		for (var i = 0; i < models.statements.length; i++) {
			model = models.statements[i];//orm model
			var database = 'orm.db';
			var table = model.name;
			var primary;
			var fields = [];
			for (var j = 0; j < model.properties.length; j++) {
				property = model.properties[j];
				if (property.decorators){
					for (var h = 0; h < property.decorators.length; h++) {
						decorator = property.decorators[h];
						if (decorator.name == 'datafield') {
							fields.push(property.variable.name);
						};
						if (decorator.name == 'primary') {
							primary = property.variable.name;
							fields.push(property.variable.name);
						};
					};
				}else if (property.type == 'database'){
					database = property.name + '.db';
				}else if (property.type == 'table'){
					table = property.name;
				}
				
			};

			if (!primary && model.properties.length > 0) {
				primary = model.properties[0].variable.name;
			};
			if (fields.length) {
				metadata = {database:database, table:table, model:model.name, primary:primary, fields:fields}
				metadatas.push(metadata)	
			};
		};
	};
}

readFile(args[2], filesList);

var metadatas = []

for (var i = 0; i < filesList.length; i++) {
	file = filesList[i];
	parseFile(file);
};

if (metadatas.length) {
	// console.log(metadatas)
	headerFile = swig.render(headerTemplate, {locals:{items:metadatas}});
	//console.log(headerFile);
	impFile = swig.render(impTemplate, {locals:{items:metadatas}})
	//console.log(impFile);
	fs.writeFileSync(path.normalize('orm.h'), headerFile)
	fs.writeFileSync(path.normalize('orm.m'), impFile)	
};








