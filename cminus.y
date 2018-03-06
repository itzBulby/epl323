%{ /* C declarations used in actions */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
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
%left '+' '-'
%left '*' '/'
%nonassoc ')'
%nonassoc ELSE
%%

program : declaration-list {
		printf("program = %s\n",$1);
	}	
	;

declaration-list : declaration-list declaration {
		//strcat($$,$1);
		strcat($$,$2);
		printf("declaration-list = %s\n",$$);
	}
	| declaration {
		//strcat($$,$1);
		printf("declaration-list = %s\n",$$);
	}	
	;

declaration : var-declaration {
		//strcat($$,$1);
		printf("declaration = %s\n",$$);
	}
	| fun-declaration {
		//strcat($$,$1);
		printf("declaration = %s\n",$$);
	}
	;

var-declaration : type-specifier ID ';' {
		//strcat($$,$1);
		strcat($$," ");
		strcat($$,$2);
		strcat($$,";");
		strcat($$,"\n");
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
		printf("var-declaration = %s\n",$$);
	}
	;

type-specifier : INT {
		//strcat($$,$1);
		strcat($$," ");
		printf("type-specifier = %s\n",$$);
	}
	| VOID {
		//strcat($$,$1);
		strcat($$," ");
		printf("type-specifier = %s\n",$$);
	}
	;

fun-declaration : type-specifier ID '('params')' compound-stmt {
		//strcat($$,$1);
		strcat($$,$2);
		strcat($$,"(");
		strcat($$,$4);
		strcat($$,")");
		strcat($$,$6);
		printf("fun-declaration = %s\n",$$);
	}
	;

params : param-list {
		//strcat($$,$1);
		printf("params = %s\n",$$);
	}
	| VOID {
		//strcat($$,$1);
		printf("params = %s\n",$$);
	}
	;

param-list : param-list',' param {
		//strcat($$,$1);
		strcat($$,",");
		strcat($$,$3);
		printf("param-list = %s\n",$$);
	}
	| param {
		//strcat($$,$1);
		printf("param-list = %s\n",$$);
	}
	;

param : type-specifier ID {
		//strcat($$,$1);
		strcat($$,$2);
		printf("param = %s\n",$$);
	}
	| type-specifier ID'['']' {
		//strcat($$,$1);
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
		//strcat($$,$1);
		strcat($$,$2);
		printf("local-declarations = %s\n",$$);
	}
	|  {
		//strcat($$,"");
	}
	;

statement-list :  {
		//strcat($$,"");
		//printf("statement-list = **EMPTY**\n");
	}
	| statement-list statement {
		//strcat($$,$1);
		strcat($$,$2);
		printf("statement-list = %s\n",$$);
	}
	;

statement : expression-stmt {
		//strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| compound-stmt {
		//strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| selection-stmt {
		//strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| iteration-stmt {
		//strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	| return-stmt {
		//strcat($$,$1);
		printf("statement = %s\n",$$);
	}
	;

expression-stmt : expression';' {
		//strcat($$,$1);
		strcat($$,";");
		strcat($$,"\n");
		printf("expression-stmt = %s\n",$$);
	}
	| ';' {
		strcat($$,";");
		strcat($$,"\n");
	}
	;

selection-stmt : IF '('expression')' statement ELSE statement {
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		strcat($$,$6);
		strcat($$,$7);
		printf("selection-smtm = %s\n",$$);
	}
	| IF '('expression')' statement {
		//strcat($$,$1);
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
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		strcat($$,$5);
		printf("iteration-smtm = %s\n",$$);
	}
	;

return-stmt : RETURN ';' {
		//strcat($$,$1);
		strcat($$,";");
		strcat($$,"\n");
		printf("return-smtm = %s\n",$$);
	}
	| RETURN expression ';' {
		//strcat($$,$1);
		strcat($$," ");
		strcat($$,$2);
		strcat($$,";");
		strcat($$,"\n");
		printf("return-smtm = %s\n",$$);
	}
	;

expression : var '=' expression {
		//strcat($$,$1);
		strcat($$,"=");
		strcat($$,$3);
		printf("expression = %s\n",$$);
	}
	| simple-expression {
		//strcat($$,$1);
		printf("expression = %s\n",$$);
	}
	;

var : ID {
		//strcat($$,$1);
		printf("Var = %s\n",$$);
	}
	| ID '['expression']' {
		//strcat($$,$1);
		strcat($$,"[");
		strcat($$,$3);
		strcat($$,"]");
		printf("Var = %s\n",$$);
	}
	;

simple-expression : additive-expression RELOP additive-expression {
		//strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		printf("Simple-Expression: %s\n",$$);
	}	
	| additive-expression {
		//strcat($$,$1);
		printf("Simple-Expression: %s\n",$$);
	}
	;


additive-expression : additive-expression addop term {
		//strcat($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		printf("Additive-expression: %s\n",$$);
	}
	| term {
		//strcat($$,$1);
		printf("Additive-expression: %s\n",$$);
	}
	;

addop : '+' 	{
		strcat($$,"+");
	}
	| '-' 	{
		strcat($$,"-");
	}
	;

term : term mulop factor {
		strcpy($$,$1);
		strcat($$,$2);
		strcat($$,$3);
		printf("Term = %s\n",$$);
	}
	| factor {
		//strcat($$,$1);
		printf("Term = %s\n",$$);
	}
	;

mulop : '*' {
		strcat($$,"*");
	}
	| '/' {
		strcat($$,"/");
	}
	;

factor : '(' expression ')' {
		strcat($$,"(");
		strcat($$,$2);
		strcat($$,")");
		printf("Factor = %s\n",$$);
	}
	| var {	
		//strcat($$,$1);
		printf("Factor = %s\n",$$);
	}
	| call {
		//strcat($$,$1);
		printf("Factor = %s\n",$$);
	}
	| NUM {
		char c[30];
		itoa($1,c);
		strcat($$,c);
		printf("Factor = %s\n",$$);
	}
	;

call : ID '('args')' {
		//strcat($$,$1);
		strcat($$,"(");
		strcat($$,$3);
		strcat($$,")");
		printf("Call = %s\n",$$);
	}
	;

args : arg-list {
		//strcat($$,$1);
		printf("Args = %s\n",$$);
	}
	|  {
		strcat($$,"");
		printf("Args = %s\n",$$);
	}
	;

arg-list : arg-list ',' expression {
		//strcat($$,$1);
		strcat($$,",");
		strcat($$,$3);		
		printf("Arg-list = %s\n",$$);	
	}
	| expression {
		//strcat($$,$1);
		printf("Arg-list = %s\n",$$);	
	}
	;
 
%%

int main (void) {
    //yydebug= 1;
    return yyparse ();
}


