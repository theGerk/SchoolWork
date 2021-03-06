/* declaration */ 

package scanner;

%%
%public
%class Scanner
%function nextToken
%type Token
%eofval{
	return null;
%eofval}

/* paterns */

whitespace	= [ \n\t]|\r\n
letter		= [A-Za-z]
word		= (_|{letter})({letter}|{digit}|_)*
digit		= [0-9]
number		= {digit}+
symbol		= <>|<=|>=|:=|[;,.:\[\]()+\-=*<>/]
comment		= \{[^\}\{]*\}


%%

/** lexical rules 
*	yytext creates a function that prints out the word */

{word}	{
	System.out.println("Found a word: " + yytext());
	return(new Token(yytext()));
}

{number}	{
	System.out.println("Found a number: " + yytext());
	return(new Token(Integer.parseInt(yytext()), yytext()));
}

{symbol}	{
	System.out.println("Found a symbol: " + yytext());
	return(new Token(yytext()));
}

{whitespace} {
	//do nothing
}

{comment}	{
	System.out.println("\t----\tHere be a comment.\t----");
	// do nothing
}

.	{
	System.out.println("You done fucked up.");
}