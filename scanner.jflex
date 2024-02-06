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

uint = [1-9][0-9]*
qstring = \" ~ \"
sep = "###"
real = ("+" | "-")? ((0"."[0-9]*) | [1-9][0-9]*"."[0-9]* | "."[0-9]+ | [1-9][0-9]*"." | 0".")


/* TOKENS */

token1 = I"_"{numb}"$"{numb}"$"{numb}"$"{numb}(("$"{numb}){8,12})?
numb = ("-"((3[0-7])|([12][0-9])|[1-9]))|([0-9])|([1-9][0-9])|(1[01][0-9])|(12[0-7])

token2 = J"_"{date}
date = 2024"/"((01"/"((1[3-9])|(2[0-9])|(3[01])))|(02"/"(([012][0-9])))|(0[3578]"/"(([012][0-9])|(3[01])))|(0[46]"/"(([012][0-9])|(3[01])))|(0[46]"/"(([01][0-9])|(2[01]))))

token3 = K"_"{wrds}{5}({wrds}{wrds})*

wrds = "--"|"**"|"*-"|"-*"

id = aaa(aa)*{uint}

nl = \r | \n | \r\n
comment = "<<<" .* ">>>"

%%
{uint}      {return sym(sym.UINT, new Integer(yytext()));}
{id}        {return sym(sym.ID, new String(yytext()));}
{real}      {return sym(sym.REAL, new Double(yytext()));}
{qstring}   {return sym(sym.QSTRING, new String(yytext()));}
"euro"       {return sym(sym.EUR);}
{sep}       {return sym(sym.SEP);}
{token1}    {return sym(sym.TK1);}
{token2}    {return sym(sym.TK2);}
{token3}    {return sym(sym.TK3);}
","         {return sym(sym.CM);}
";"         {return sym(sym.S);}
"::"         {return sym(sym.CCL);}
":"         {return sym(sym.COL);}
{comment}   {;}
\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}