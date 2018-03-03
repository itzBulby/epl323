%{ /* C declarations used in actions */
    #include <stdio.h>
    extern char *yytext; /*using flex */
                         /* use extern char yytext; with lex */
	int yydebug=0; 
%}

//function words need tokens

%union {int num; char buf[100];}

%start program

%token <num> NUM
%token <buf> ID

%type <void> declaration-list
%type <void> declaration
%type <void> var-declaration
%type <void> type-specifier
%type <void> fun-declaration
%type <void> params
%type <void> param-list
%type <void> param
%type <void> compound-stmt
%type <void> local-declarations
%type <void> statement-list
%type <void> statement
%type <void> expression-stmt
%type <void> selection-stmt
%type <void> iteration-stmt
%type <void> return-stmt
%type <void> expression
%type <void> var
%type <void> simple-expression
%type <void> relop
%type <void> additive-expression
%type <void> addop
%type <void> term
%type <void> mulop
%type <void> factor
%type <void> call
%type <void> args
%type <void> arg-list

%%

program : declaration-list {

}	
	;

declaration-list : declaration-list declaration {

}
	| declaration {

}
	;

declaration : var-declaration {

}
	| fun-declaration {

}
	;

var-declaration : type-specifier ID ';' {
	
}
	| type-specifier ID[NUM] ';' {

}
	;

type-specifier : int {

}
	| void {

}
	;

fun-declaration : type-specifier ID '('params')' compound-stmt {

}
	;

params : param-list {

}
	| void {

}
	;

param-list : param-list param {

}
	| param {

}
	;

param : type-specifier ID {

}
	| type-specifier ID[] {

}

	;

compound-stmt : "{" local-declarations statement-list "}" {

}
	;

local-declarations : local-declarations var-declaration {

}
	| empty {

}
	;

statement-list : statement-list statement {

}
	| empty {

}
	;

statement : expression-stmt {

}
	| compound-stmt {

}
	| selection-stmt {

}
	| iteration-stmt {

}
	| return-stmt {

}
	;

expression-stmt : expression";" {

}
	| ";" {

}
	;

selection-stmt : if (expression) statement {

}
	| if (expression) statement else statement {

}
	;

iteration-stmt : while (expression) statement {

}
	;

return-stmt : return ";" {

}
	| return expression ";" {

}
	;

expression : var = expression {

}
	| simple-expression {

}
	;

var : ID {

}
	| ID [expression] {

}
	;

simple-expression : additive-expression relop additive-expression {

}
	| additive-expression {

}
	;

relop : "<=" {

}
	| "<" {

}
	| ">" {

}
	| ">=" {

}
	| "==" {

}
	| "!=" {

}
	;

additive-expression : additive-expression addop term {

}
	| term {

}
	;

addop : "+" {

}
	| "-" {

}
	;

term : term mulop factor {

}
	| factor {

}
	;

mulop : "*" {

}
	| "/" {

}
	;

factor : ( expression ) {

}
	| var {

}
	| call {

}
	| NUM {

}
	;

call : ID (args) {

}
	;

args : arg-list {

}
	| empty {

}
	;

arg-list : arg-list , expression {

}
	| expression {

}
	;
 
%%

int main (void) {
    yydebug= 1;
    return yyparse ();
}

int yyerror (char* s) {/* Called by yyparse on error */
  printf ("%s\n", s);
}
