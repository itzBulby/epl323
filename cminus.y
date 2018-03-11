/****************************************
*					*
* EPL323 - Compilers		        *
* Project - Part A		        *
*				        *
* Nikolas Pafitis - ID:1001442		*
* Giorgos Panayiotou - ID:927496	*
*					*
****************************************/
%{ /* C declarations used in actions */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int cDebug=0;
    char *errorMsg;
    int hasError=0;
    extern int yylineno;
    extern char *yytext; /*using flex */
                         /* use extern char yytext; with lex */
	//int yydebug=0;
	char* itoa(int i, char *b){
	    char const digit[] = "0123456789";
	    char* p = b;
	    if(i<0){
		*p++ = '-';
		i *= -1;
	    }
	    int shifter = i;
	    do{ //Move to where representation ends
		++p;
		shifter = shifter/10;
	    }while(shifter);
	    *p = '\0';
	    do{ //Move back, inserting digits as u go
		*--p = digit[i%10];
		i = i/10;
	    }while(i);
	    return b;
	}
	
%}

//function words need tokens
%locations
%union {int num; char buf[5000];}

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
/*
%left ID NUM
%left RELOP
%left VOID
%left INT
%left WHILE
%left IF RETURN
*/

%nonassoc ')'
%nonassoc ELSE
%%

program : declaration-list {
		//printf("program = %s\n",$1);
		if(!hasError)
			printf("\nProgram Accepted!\n");
		else
			printf("\nCompilation failed\n");
	}	
	;

declaration-list : declaration-list declaration {
		//strcat($$,$1);
		strcpy($$,$1);
		strcat($$,$2);
		if(cDebug)
		printf("declaration-list = %s\n",$$);
	}
	| declaration {
		//strcat($$,$1);
		strcpy($$,$1);
		if(cDebug)
		printf("declaration-list = %s\n",$$);
	}	
	;

declaration : var-declaration {
		//strcat($$,$1);
		strcpy($$,$1);
		if(cDebug)
		printf("declaration = %s\n",$$);
	}
	| fun-declaration {
		strcpy($$,$1);
		if(cDebug)
		printf("declaration = %s\n",$$);
	}
	;

var-declaration : type-specifier ID ';' {
		//strcat($$,$1);
		strcat($$," ");
		strcat($$,$2);
		strcat($$,";");
		strcat($$,"\n");
		if(cDebug)
		printf("var-declaration = %s\n",$$);
	}
	| type-specifier ID'['NUM']' ';' {
		char c[100];
		//strcat($$,$1);
		strcat($$," ");
		strcat($$,$2);
		strcat($$,"[");
		itoa($1,c);
		strcat($$,c);
		strcat($$,"]");
		strcat($$,";");
		strcat($$,"\n");
		if(cDebug)
		printf("var-declaration = %s\n",$$);
	}
	| type-specifier error';' {
		hasError=1;
		printError("\nExpected identifier before ';'");
	}
	| type-specifier ID '['error']' ';'{
		hasError=1;
		printError("\nExpected Num between '[' and ']' of array declaration\n");
	}
	;

type-specifier : INT {
		//strcat($$,$1);
		strcat($$," ");
		if(cDebug)
		printf("type-specifier = %s\n",$$);
	}
	| VOID {
		//strcat($$,$1);
		strcat($$," ");
		if(cDebug)
		printf("type-specifier = %s\n",$$);
	}
	;

fun-declaration : type-specifier ID '('params')' compound-stmt {
		strcpy($$,$1);
		strcat($$,$2);
		strcat($$,"(");
		strcat($$,$4);
		strcat($$,")");
		strcat($$,$6);
		if(cDebug)
		printf("fun-declaration = %s\n",$$);
	}
	| error ID '('params')' compound-stmt {
		hasError=1;
		printError("\nExpected type specifier before Function Declaration");
	}
	;

params : param-list {
		//strcat($$,$1);
		if(cDebug)
		printf("params = %s\n",$$);
	}
	| VOID {
		//strcat($$,$1);
		if(cDebug)
		printf("params = %s\n",$$);
	}
	| error {
		hasError=1;
		printError("\nExpected parameters or 'void' in Function declaration\n");
	}
	;

param-list : param-list',' param {
		//strcat($$,$1);
		strcat($$,",");
		strcat($$,$3);
		if(cDebug)
		printf("param-list = %s\n",$$);
	}
	| param {
		//strcat($$,$1);
		if(cDebug)
		printf("param-list = %s\n",$$);
	}
	| param-list error param {
		hasError=1;
		printError("\n Expected ',' between parameters in function declaration\n");
	}
	| param-list ',' error {
		hasError=1;
		printError("\nExpected parameter after ',' in function declaration\n");
	}
	;

param : type-specifier ID {
		//strcat($$,$1);
		strcat($$,$2);
		if(cDebug)
		printf("param = %s\n",$$);
	}
	| type-specifier ID'['']' {
		//strcat($$,$1);
		strcat($$,$2);
		strcat($$,"[");
		strcat($$,"]");
		if(cDebug)
		printf("param = %s\n",$$);
	}
	| error ID {
		hasError=1;
		printError("\nExpected type-specifier before identifier in param\n");
	}
	| error ID '['']' {
		hasError=1;
		printError("\nExpected type-specifier before identifier in param\n");
	}
	| type-specifier ID'['error']'{
		hasError=1;
		printError("\nCannot declare array size in params\n");
	}
	;

compound-stmt : '{' local-declarations statement-list '}' {
		strcpy($$,"{");
		strcat($$,$2);
		strcat($$,$3);
		strcat($$,"}");
		if(cDebug)
		printf("compound-stmt = %s\n",$$);
	}
	;

local-declarations : local-declarations var-declaration {
		//strcat($$,$1);
		strcat($$,$2);
		if(cDebug)
		printf("local-declarations = %s\n",$$);
	}
	|  {
		strcpy($$,"");
	}

	;

statement-list : statement-list statement {
		//strcat($$,$1);
		strcat($$,$2);
		if(cDebug)
		printf("statement-list = %s\n",$$);
	}
	|  {
		strcpy($$,"");
		//printf("statement-list = **EMPTY**\n");
	}
	;

statement : expression-stmt {
		//strcat($$,$1);
		if(cDebug)
		printf("statement = %s\n",$$);
	}
	| compound-stmt {
		//strcat($$,$1);
		if(cDebug)
		printf("statement = %s\n",$$);
	}
	| selection-stmt {
		//strcat($$,$1);
		if(cDebug)
		printf("statement = %s\n",$$);
	}
	| iteration-stmt {
		//strcat($$,$1);
		if(cDebug)
		printf("statement = %s\n",$$);
	}
	| return-stmt {
		//strcat($$,$1);
		if(cDebug)
		printf("statement = %s\n",$$);
	}
	;

expression-stmt : expression';' {
		//strcat($$,$1);
		strcat($$,";");
		strcat($$,"\n");
		if(cDebug)
		printf("expression-stmt = %s\n",$$);
	}
	| ';' {
		strcat($$,";");
		strcat($$,"\n");
	}
	| expression error {
		hasError=1;
		printError("\nExpected ';' after an expression\n");
	}
	;

selection-stmt : IF '('expression')' statement ELSE statement {
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		strcat($$,$6);
		strcat($$," ");
		strcat($$,$7);
		if(cDebug)
		printf("selection-smtm = %s\n",$$);
	}
	| IF '('expression')' statement {
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		if(cDebug)
		printf("selection-smtm = %s\n",$$);
	}
	| error '('expression')' statement {
		hasError=1;
		printError("\nExpected 'IF' before expression in selection-statement\n");
	}
	;
iteration-stmt : WHILE '('expression')' statement {
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		if(cDebug)
		printf("iteration-smtm = %s\n",$$);
	}
	| WHILE '('error')' statement {
		hasError=1;
		printError("\nExpected expression in WHILE statement\n");
	}
	;

return-stmt : RETURN ';' {
		//strcat($$,$1);
		strcat($$," ");
		strcat($$,";");
		strcat($$,"\n");
		if(cDebug)
		printf("return-smtm = %s\n",$$);
	}
	| RETURN expression ';' {
		//strcat($$,$1);
		strcat($$," ");
		strcat($$,$2);
		strcat($$,";");
		strcat($$,"\n");
		if(cDebug)
		printf("return-smtm = %s\n",$$);
	}
	;

expression : var '=' expression {
		//strcat($$,$1);
		strcat($$,"=");
		strcat($$,$3);
		if(cDebug)
		printf("expression = %s\n",$$);
	}
	| simple-expression {
		//strcat($$,$1);
		if(cDebug)
		printf("expression = %s\n",$$);
	}
	;

var : ID {
		//strcat($$,$1);
		if(cDebug)
		printf("Var = %s\n",$$);
	}
	| ID '['expression']' {
		//strcat($$,$1);
		strcat($$,"[");
		strcat($$,$3);
		strcat($$,"]");
		if(cDebug)
		printf("Var = %s\n",$$);
	}
	| ID '['error']'{
		hasError=1;
		printError("\nExpected expression as array index");
	}
	;

simple-expression : additive-expression RELOP additive-expression {
		//strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		if(cDebug)
		printf("Simple-Expression: %s\n",$$);
	}	
	| additive-expression {
		//strcat($$,$1);
		if(cDebug)
		printf("Simple-Expression: %s\n",$$);
	}
	| additive-expression RELOP error {
		hasError=1;
		printError("\nExpected expression after relational operator\n");
	}
	| error RELOP additive-expression {
		hasError=1;
		printError("\nExpected expression before relational operator\n");
	}
	;


additive-expression : additive-expression addop term {
		//strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		if(cDebug)
		printf("Additive-expression: %s\n",$$);
	}
	| term {
		//strcat($$,$1);
		if(cDebug)
		printf("Additive-expression: %s\n",$$);
	}
	| additive-expression addop error {
		hasError=1;
		printError("\nExpected term after additive operator\n");
	}
	;

addop : '+' 	{
		strcpy($$,"+");
	}
	| '-' 	{
		strcpy($$,"-");
	}
	;

term : term mulop factor {
		strcpy($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		if(cDebug)
		printf("Term = %s\n",$$);
	}
	| factor {
		//strcat($$,$1);
		if(cDebug)
		printf("Term = %s\n",$$);
	}
	| term mulop error {
		hasError=1;
		printError("\nExpected factor after multiplicational operator\n");
	}
	;

mulop : '*' {
		strcpy($$,"*");
	}
	| '/' {
		strcpy($$,"/");
	}
	;

factor : '(' expression ')' {
		strcat($$,"(");
		strcat($$,$2);
		strcat($$,")");
		if(cDebug)
		printf("Factor = %s\n",$$);
	}
	| var {	
		//strcat($$,$1);
		if(cDebug)
		printf("Factor = %s\n",$$);
	}
	| call {
		//strcat($$,$1);
		if(cDebug)
		printf("Factor = %s\n",$$);
	}
	| NUM {
		char c[30];
		itoa($1,c);
		strcpy($$,c);
		if(cDebug)
		printf("Factor = %s\n",$$);
	}
	| '(' error ')' {
		hasError=1;
		printError("\nExpected expression between '(' and ')' of factor\n");
	}
	;

call : ID '('args')' {
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		if(cDebug)
		printf("Call = %s\n",$$);
	}
	| ID '('error')' {
		hasError=1;
		printError("\nExpected arguments or empty in Function call\n");
	}
	;

args : arg-list {
		//strcat($$,$1);
		if(cDebug)
		printf("Args = %s\n",$$);
	}
	|  {
		strcat($$,"");
		if(cDebug)
		printf("Args = %s\n",$$);
	}
	;

arg-list : arg-list ',' expression {
		//strcat($$,$1);
		strcat($$,",");
		strcat($$,$3);		
		if(cDebug)
		printf("Arg-list = %s\n",$$);	
	}
	| expression {
		//strcat($$,$1);
		if(cDebug)
		printf("Arg-list = %s\n",$$);	
	}
	| arg-list ',' error {
		hasError=1;
		printf("\nExpected expression after ',' in arguments\n");
	}
	;
 
%%
void printError(char *s){
	printf("%s in line %d\n",s,yylloc.first_line);
}
int main (void) {
    //yydebug= 1;
    return yyparse ();
}


