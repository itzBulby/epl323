%{ /* C declarations used in actions */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern char *yytext; /*using flex */
                         /* use extern char yytext; with lex */
	//int yydebug=0;
	
%}

//function words need tokens

%union {int num; char buf[100];}

%start program

%token <num> NUM
%token <buf> ID
%token <buf> RELOP
%token <buf> IF
%token <buf> ELSE
%token <buf> INT
%token <buf> RETURN
%token <buf> VOID
%token <buf> WHILE
%token <buf> EMPTY


%type <buf> declaration-list
%type <buf> declaration
%type <buf> var-declaration
%type <buf> type-specifier
%type <buf> fun-declaration
%type <buf> params
%type <buf> param-list
%type <buf> param
%type <buf> compound-stmt
%type <buf> local-declarations
%type <buf> statement-list
%type <buf> statement
%type <buf> expression-stmt
%type <buf> selection-stmt

//%type <buf> else-stmt
%type <buf> iteration-stmt
%type <buf> return-stmt
%type <buf> expression
%type <buf> var
%type <buf> simple-expression
//%type <buf> relop
%type <buf> additive-expression
%type <buf> addop
%type <buf> term
%type <buf> mulop
%type <buf> factor
%type <buf> call
%type <buf> args
%type <buf> arg-list
//%type <buf> empty
%nonassoc "empty"
%left ELSE
%%

program : declaration-list {
		printf("program = %s\n",$1);
	}	
	;

declaration-list : declaration-list declaration {
		strcat($$,$1);
		strcat($$,$2);
		printf("declaration-list = %s\n",$$);
	}
	| declaration {
		strcat($$,$1);
		printf("declaration-list = %s\n",$$);
	}	
	;

declaration : var-declaration {
		strcat($$,$1);
		printf("declaration = %s\n",$$);
	}
	| fun-declaration {
		strcat($$,$1);
		printf("declaration = %s\n",$$);
	}
	;

var-declaration : type-specifier ID ';' {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,";");
		printf("var-declaration = %s\n",$$);
	}
	| type-specifier ID'['NUM']' ';' {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,"[");
		strcat($$,$4);
		strcat($$,"]");
		strcat($$,";");
		printf("var-declaration = %s\n",$$);
	}
	;

type-specifier : INT {
		strcat($$,$1);
		printf("type-specifier = %s\n",$$);
	}
	| VOID {
		strcat($$,$1);
		printf("type-specifier = %s\n",$$);
	}
	;

fun-declaration : type-specifier ID '('params')' compound-stmt {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,"(");
		strcat($$,$4);
		strcat($$,")");
		strcat($$,$6);
		printf("fun-declaration = %s\n",$$);
	}
	;

params : param-list {
		strcat($$,$1);
		printf("params = %s\n",$$);
	}
	| VOID {
		strcat($$,$1);
		printf("params = %s\n",$$);
	}
	;

param-list : param-list param {
		strcat($$,$1);
		strcat($$,$2);
		printf("param-list = %s\n",$$);
	}
	| param {
		strcat($$,$1);
		printf("param-list = %s\n",$$);
	}
	;

param : type-specifier ID {
		strcat($$,$1);
		strcat($$,$2);
		printf("param = %s\n",$$);
	}
	| type-specifier ID'['']' {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,"[");
		strcat($$,"]");
		printf("param = %s\n",$$);
	}

	;

compound-stmt : '{' local-declarations statement-list '}' {
		strcat($$,"{");
		strcat($$,$2);
		strcat($$,$3);
		strcat($$,"}");
		printf("compound-stmt = %s\n",$$);
	}
	;

local-declarations : local-declarations var-declaration {
		strcat($$,$1);
		strcat($$,$2);
		printf("local-declarations = %s\n",$$);
	}
	|  {
		$$ = "";
	}
	;

statement-list : statement-list statement {
		strcat($$,$1);
		strcat($$,$2);
		printf("statement-list = %s\n",$$);
	}
	|  {
		$$ = "";
		printf("statement-list = **EMPTY**\n",$$);
	}
	;

statement : expression-stmt {
		strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| compound-stmt {
		strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| selection-stmt {
		strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| iteration-stmt {
		strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| return-stmt {
		strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	;

expression-stmt : expression';' {
		strcat($$,$1);
		strcat($$,";");
		printf("expression-stmt = %s\n",$$);
	}
	| ';' {
		$$ = ";";
	}
	;

selection-stmt : IF '('expression')' statement ELSE statement %prec {
		strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		strcat($$,$6);
		strcat($$,$7);
		printf("selection-smtm = %s\n",$$);
	}
	| IF '('expression')' statement {
		strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		printf("selection-smtm = %s\n",$$);
	}
/*
	|IF '('expression')' statement unmatched-stmt {
		strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		strcat($$,$6);
		printf("selection-smtm = %s\n",$$);
	}*/
	;
/*
else-stmt: {
		$$ = "";
	} 
	|ELSE statement {
		strcat($$,$1);
		strcat($$,$2);
	}
	;
*/
iteration-stmt : WHILE '('expression')' statement {
		strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		printf("iteration-smtm = %s\n",$$);
	}
	;

return-stmt : RETURN ';' {
		strcat($$,$1);
		strcat($$,";");
		printf("return-smtm = %s\n",$$);
	}
	| RETURN expression ';' {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,";");
		printf("return-smtm = %s\n",$$);
	}
	;

expression : var '=' expression {
		strcat($$,$1);
		strcat($$,"=");
		strcat($$,$3);
		printf("expression = %s\n",$$);
	}
	| simple-expression {
		strcat($$,$1);
		printf("expression = %s\n",$$);
	}
	;

var : ID {
		strcat($$,$1);
		printf("Var = %s\n",$$);
	}
	| ID '['expression']' {
		strcat($$,$1);
		strcat($$,"[");
		strcat($$,$3);
		strcat($$,"]");
		printf("Var = %s\n",$$);
	}
	;

simple-expression : additive-expression RELOP additive-expression {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		printf("Simple-Expression: %s\n",$$);
	}	
	| additive-expression {
		strcat($$,$1);
		printf("Simple-Expression: %s\n",$$);
	}
	;


additive-expression : additive-expression addop term {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		printf("Additive-expression: %s\n",$$);
	}
	| term {
		strcat($$,$1);
		printf("Additive-expression: %s\n",$$);
	}
	;

addop : '+' 	{
		$$ = "+";
	}
	| '-' 	{
		$$ = "-";
	}
	;

term : term mulop factor {
		strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		printf("Term = %s\n",$$);
	}
	| factor {
		strcat($$,$1);
		printf("Term = %s\n",$$);
	}
	;

mulop : '*' {
		$$ = "*";
	}
	| '/' {
		$$ = "/";
	}
	;

factor : '(' expression ')' {
		strcat($$,"(");
		strcat($$,$2);
		strcat($$,")");
		printf("Factor = %s\n",$$);
	}
	| var {	
		strcat($$,$1);
		printf("Factor = %s\n",$$);
	}
	| call {
		strcat($$,$1);
		printf("Factor = %s\n",$$);
	}
	| NUM {
		char c[30];
		ltoa($1,c,10);
		strcat($$,$1);
		printf("Factor = %s\n",$$);
	}
	;

call : ID '('args')' {
		strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		printf("Call = %s\n",$$);
	}
	;

args : arg-list {
		strcat($$,$1);
		printf("Args = %s\n",$$);
	}
	|  {
		$$ = "";
		printf("Args = %s\n",$$);
	}
	;

arg-list : arg-list ',' expression {
		strcat($$,$1);
		strcat($$,",");
		strcat($$,$3);		
		printf("Arg-list = %s\n",$$);	
	}
	| expression {
		strcat($$,$1);
		printf("Arg-list = %s\n",$$);	
	}
	;
 
%%

int main (void) {
    //yydebug= 1;
    return yyparse ();
}

int yyerror (char* s) {/* Called by yyparse on error */
  printf ("%s\n", s);
}
