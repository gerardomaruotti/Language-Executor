import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

%{
    private Symbol sym(int type){
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol sym(int type, Object value){
        return new Symbol(type, yyline, yycolumn, value);
    }
%}


uint = 0 | [1-9][0-9]*
real = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
qstring = \" ~ \"
sep = "***"

/* TOKEN 1 DONE*/
token1 = {hexnum}{sep1}{alphabetic}{sep2}{terminal}
hexnum = {hex1}|{hex2}|{hex3}
hex1 = [2-9a-fA-F][7-9a-fA-F][a-fA-F]
hex2 = [0-9a-fA-F]{3}
hex3 = 1[0-2][0-9a-bA-B][0-3]
alphabetic = [a-zA-Z]{5}([a-zA-Z][a-zA-Z])*
sep1 = "*"
sep2 = "-"
terminal = ("****"("**"))*(YZ(ZZ)*Y)* 


/* TOKEN 2 DONE*/
token2 = {ip}{sepIp}{date}
sepIp = "-"
ip_num = (2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])
ip = {ip_num}"."{ip_num}"."{ip_num}"."{ip_num}
date = {date1}|{date2}|{date3}|{date4}|{date5}|{date6}
date1 = 2023\/10\/((0[5-9])|((1|2)[0-9]|(3[0-1])))
date2 = 2023\/11\/((0[1-9])|((1|2)[0-9]|(30)))
date3 = 2023\/12\/((0[1-9])|((1|2)[0-9]|(3[0-1])))
date4 = 2024\/01\/((0[1-9])|((1|2)[0-9]|(3[0-1])))
date5 = 2024\/02\/((0[1-9])|((1|2)[0-9]))
date6 = 2024\/03\/(0[1-3])

/* TOKEN 3 DONE*/
token3 = {number}{sepNum}{number}{sepNum}{number}({sepNum}{number}{sepNum}{number})*
number = ([0-9]{4})|([0-9]{6})
sepNum = "-"|"+"

comment = \{\{ (.*) \}\}
nl = \r | \n | \r\n
cpp_comment = "//" .* {nl}

%%
// ALL INTRODUCED SYMBOLS NEED TO BE DECLARED AS TERMINALS INSIDE OF CUP FILE OTHERWISE YOU HAVE AN ERROR WHEN COMPILING WITH JAVAC
{sep}       {return sym(sym.SEP);}
{uint}      {return sym(sym.UINT, new Integer(yytext()));}
{real}      {return sym(sym.REAL, new Double(yytext()));}
{qstring}   {return sym(sym.QSTRING, new String(yytext()));}
{token1}    {return sym(sym.TK1);}
{token2}    {return sym(sym.TK2);}
{token3}    {return sym(sym.TK3);}
"euro"      {return sym(sym.EURO);}
","         {return sym(sym.CM);}
";"         {return sym(sym.S);}
"-"         {return sym(sym.MINUS);}
"%"         {return sym(sym.PERC);}

{comment}   {;}
{cpp_comment} {;}
\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}