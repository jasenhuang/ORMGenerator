
%lex

%%

"/*"([*]*(([^*/])+([/])*)*)*"*/"                    {/* skip comment */};
"//".*\n 		 				                    {/* skip comment */};
[ \t\r\n]                                           {/* skip whitespace */};
"@"													{return '@';}
"interface"											{return 'interface';}
"end"												{return 'end';}
"property"											{return 'property';}
"setter"											{return 'setter';}
"getter"											{return 'getter';}
"const"												{return 'const';}
"signed"											{return 'signed';}
"unsigned"											{return 'unsigned';}
"int"												{return 'int';}
"long"												{return 'long';}
"float"												{return 'float';}
"double"											{return 'double';}
"char"												{return 'char';}
"ORMDataBase"										{return 'database';}
"ORMTable"											{return 'table';}
"datafield"											{return 'datafield';}
"primary"											{return 'primary';}
[a-zA-Z_][a-zA-Z0-9_]* 								{return 'TIDENTIFIER'; /*不能以数字作为变量的开头*/}
[0-9]+("."[0-9]+)?\b								{return 'TINTEGER';}
"-"													{return '-';}
"+"													{return '+';}
"="													{return '=';}
"<"													{return '>';}
">"													{return '<';}
"{"													{return '{';}
"}"													{return '}';}
"("													{return '(';}
")"													{return ')';}
","													{return ',';}
":"													{return ':';}
";"													{return ';';}
.													{/**/}


/lex

%{

function Statements() {
	this.statements = new Array();
}
function InheriteDeclaration() {
	//this.name
	//this.protocols
}
function ClassDeclaration() {
	//this.name
	//this.block
	//this.properties
}
function BlockDeclaration() {
	//this.variables
}
function DecoratorDeclaration(){
	//this.name
	//this.getter
	//this.setter
}
function PropertyDeclaration(){
	//this.variable
	//this.decorators
}
function FunctionDeclaration() {
	//this.name
}
function FunctionParameter() {
	//this.name
}
function DatabaseDeclaration(){
	
}
function TableDeclaration(){
	
}
function VarDeclaration() {
	//this.type
	//this.name
}
function TypeDeclaration() {
	//this.name
	//this.is_ptr
	//this.is_const;
	//this.pointers
}
function PointerDeclaration(){
	//this.is_const;
}

%}

%start program

%%
program:/*empty*/
	|stmts {global.models = $1;}
	;
stmts:stmts stmt 
	{
		$1.statements.push($2);
	}
	|stmt 
	{
		$$ = new Statements();
		$$.statements.push($1);
	}
	;
stmt:'@' 'interface' name ':' inherite properties '@' 'end' 
	{
		$$ = new ClassDeclaration();
		$$.name = $3;
		$$.inherite = $5;
		$$.properties = $6;

	}
	|'@' 'interface' name block ':' inherite properties  '@' 'end' 
	{
		$$ = new ClassDeclaration();
		$$.name = $3;
		$$.block = $4;
		$$.inherite = $6;
		$$.properties = $7;
	}
	;
inherite: name '<' names '>' 
	{
		$$ = new InheriteDeclaration()
		$$.name = $1;
		$$.protocols = $3;
	}
	|name
	{
		$$ = new InheriteDeclaration()
		$$.name = $1;
		$$.protocols = new Array();
	}
	;

block: '{' '}'
	{
		$$ = new BlockDeclaration();
	}
	|'{' variables '}'
	{
		$$ = new BlockDeclaration();
		$$.variables = $2;
	}
	;

variables: variables ';' variable
	{
		$1.push($3);
	}
	|variable
	{
		$$ = new Array();
		$$.push($1);
	}
	;

properties:properties propertyitem
	{
		$1.push($2);
	}
	|propertyitem
	{
		$$ = new Array(); $$.push($1);
	}
	;
propertyitem:'@' 'property' '(' decorators ')' variable ';'
	{
		$$ = new PropertyDeclaration();
		$$.variable = $6;
		$$.decorators = $4;
	}
	|functionItem ';'
	{
		$$ = $1;
	}
	|'database' '(' name ')'
	{
		$$ = new DatabaseDeclaration();
		$$.type = 'database';
		$$.name = $3;
	}
	|'table' '(' name ')'
	{
		$$ = new TableDeclaration();
		$$.type = 'table';
		$$.name = $3;
	}
	;
functionItem: '-' '(' type ')' params
	{
		$$ = new FunctionDeclaration();
		$$.name = 'instance function'
		$$.params = $5;
	}
	| '+' '(' type ')' params
	{
		$$ = new FunctionDeclaration();	
		$$.name = 'class function'
		$$.params = $5;
	}
	;
params: params param 
	{
		$1.push($2);
	}
	| param 
	{
		$$ = new Array(); 
		$$.push($1);
	}
	;
param: name ':' '(' type ')' name
	{
		$$ = new FunctionParameter();
		$$.prefix = $1;
		$$.type = $4;
		$$.name = $6;
	}
	| name
	{
		$$ = new FunctionParameter();
		$$.prefix = $1;
	}
	;

decorators:decorators ',' decorator
	{
		$1.push($3);
	}
	|decorator
	{
		$$ = new Array(); $$.push($1);
	}
	;
decorator: 'setter' '=' name {$$ = new DecoratorDeclaration();$$.setter = $1;}
	|'getter' '=' name {$$ = new DecoratorDeclaration();$$.getter = $1;}
	| 'datafield' {$$ = new DecoratorDeclaration();$$.name = $1;}
	| 'primary' {$$ = new DecoratorDeclaration();$$.name = $1;}
	| name {$$ = new DecoratorDeclaration();$$.name = $1;}
	;

names: names ',' name 
	{ 
		$1.push($3); 
	}
	| name 
	{
		$$ = new Array();
		$$.push($1);
	}
	;

variable: type name
	{
		$$ = new VarDeclaration();
		$$.type = $1;
		$$.name = $2;
	}
	;

type: typename pointers
	{
		$$ = new TypeDeclaration();
		$$.name = $1;
		$$.pointers = $2;
	}
	| typename 
	{
		$$ = new TypeDeclaration();
		$$.name = $1;
	}
	;
typename:typedecorator basetype {$$ = $1 + ' ' + $2;}
	|typedecorator { $$ = $1;}
	|'const' basetype {$$ = $1 + ' ' + $2;}
	|basetype { $$ = $1;}
	| name {$$ = $1;}
	;
typedecorator:'signed' {$$ = $1;}
	|'unsigned' {$$ = $1;}
	;

basetype:'int' {$$ = $1;}
	|'float' {$$ = $1;}
	|'char' {$$ = $1;}
	|'double' {$$ = $1;}
	|'long' {$$ = $1;}
	|'long' 'long' {$$ = $1 + ' ' + $2;}
	;

pointers:pointers pointer {$1.push($2);}
	|pointer {$$ = new Array();$$.push($1);}
	;
pointer:'*' {$$ = new PointerDeclaration();$$.is_const = false;}
	|'*' 'const'{$$ = new PointerDeclaration();$$.is_const = true;}
	;

name:TIDENTIFIER { $$ = yytext;}
	;
numeric: TINTEGER {/**/}
	;


