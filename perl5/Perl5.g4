grammar Perl5;

main: line+ EOF;
line                           : use_module
                                 | expr
                                 | variable_declaration
                                 | variable_declaration_with_init
                                 | variable_reference
                                 | subroutine_declaration
                                 | subroutine_call
                                 | conditional_block
                                 | variable_deref
                                 | comment;
unary_expr                     : UNARY_OP+ literal;
binary_expr                    : literal BINARY_OP literal;
use_module                     : USE IDENTIFIER scalar_value* SEMICOLON?;
variable_reference             : '\\'+ variable;
variable                       : (scalar_variable | array_variable | hash_variable);
scalar_variable                : SCALAR_SIGIL IDENTIFIER;
array_variable                 : ARRAY_SIGIL IDENTIFIER;
hash_variable                  : HASH_SIGIL IDENTIFIER;
variable_declaration           : SCOPE? variable SEMICOLON;
variable_declaration_with_init : SCOPE? variable ASSIGNMENT value SEMICOLON;
subroutine_declaration         : SUB IDENTIFIER lexical_scope;
variable_deref                 : arrayref_deref | hashref_deref;
arrayref_deref                 : ARRAY_SIGIL LEFT_CURLY_BRACKET (deref_unit|SIGIL IDENTIFIER)+ RIGHT_CURLY_BRACKET;
hashref_deref                  : HASH_SIGIL LEFT_CURLY_BRACKET SIGIL (IDENTIFIER | deref_unit)* RIGHT_CURLY_BRACKET;
deref_unit                     : DEREF?(LEFT_CURLY_BRACKET | LEFT_SQUARE_BRACKET) (DIGITS | IDENTIFIER) (RIGHT_CURLY_BRACKET | RIGHT_SQUARE_BRACKET);
expr                           : literal | unary_expr | binary_expr;
literal                        : (SQUOTE_STRING | DQUOTE_STRING | value | variable_declaration | variable_declaration_with_init);
value                          : scalar_value
                                 | subroutine_declaration
                                 | subroutine_call
                                 | array_value
                                 | arrayref_value
                                 | hash_value
                                 | hashref_value
                                 | variable
                                 | file_descriptor
                                 | IDENTIFIER;
file_descriptor                : LEFT_ANGLE_BRACKET IDENTIFIER RIGHT_ANGLE_BRACKET;
scalar_value                   : (SQUOTE_STRING | DQUOTE_STRING | DIGITS);
array_value                    : LEFT_ROUND_BRACKET (value COMMA?)* RIGHT_ROUND_BRACKET;
arrayref_value                 : LEFT_SQUARE_BRACKET (value COMMA?)* RIGHT_SQUARE_BRACKET;
hash_value                     : array_value;
hashref_value                  : LEFT_CURLY_BRACKET (value (COMMA | FAT_COMMA)?)* RIGHT_CURLY_BRACKET;
subroutine_call                : (call_with_parenthesis | call_without_parenthesis | call_by_reference) SEMICOLON?;
call_with_parenthesis          : AMPERSAND? IDENTIFIER LEFT_ROUND_BRACKET (value COMMA?)* RIGHT_ROUND_BRACKET;
call_without_parenthesis       : IDENTIFIER (value COMMA?)+;
call_by_reference              : variable DEREF LEFT_ROUND_BRACKET (value COMMA?)* RIGHT_ROUND_BRACKET;
lexical_scope                  : LEFT_CURLY_BRACKET (line)* SEMICOLON? RIGHT_CURLY_BRACKET SEMICOLON?;
conditional_block              : if_block+ elsif_block* else_block?;
if_block                       : IF LEFT_ROUND_BRACKET (expr)+ RIGHT_ROUND_BRACKET lexical_scope;
elsif_block                    : ELSEIF LEFT_ROUND_BRACKET (expr)+ RIGHT_ROUND_BRACKET lexical_scope;
else_block                     : ELSE lexical_scope;
comment                        : COMMENT ;

// Lexer rules.
DEREF                 : '->';
SEPARATOR             : '::';
COMMENT               : '#'+ ~[\r\n]*;
SCOPE                 : ('my' | 'our') ;
AMPERSAND             : '&';
COMMA                 : ',';
FAT_COMMA             : '=>';
ARRAY_SIGIL           : '@';
HASH_SIGIL            : '%';
SCALAR_SIGIL          : '$';
SIGIL                 : (HASH_SIGIL|SCALAR_SIGIL|ARRAY_SIGIL) ;
SUB                   : 'sub';
USE                   : 'use';
SEMICOLON             : ';';
WHITESPACE            : (' ' | '\t' | '\n') -> skip;
ASSIGNMENT            : '=';
DIGITS                : [-+]?([0-9]*[.][0-9]+|[0-9]+);
IF                    : 'if' | 'unless';
ELSEIF                : 'elsif';
ELSE                  : 'else';
BINARY_OP             : '=='
                        | '!='
                        | '>='
                        | '<='
                        | 'ge'
                        | 'le'
                        | 'ne'
                        | 'eq'
                        | '&&'
                        | '||'
                        | 'and'
                        | 'or'
                        ;
UNARY_OP              : '++' | '--' | '!';
LEFT_CURLY_BRACKET    : '{';
RIGHT_CURLY_BRACKET   : '}';
LEFT_ROUND_BRACKET    : '(';
RIGHT_ROUND_BRACKET   : ')';
LEFT_SQUARE_BRACKET   : '[';
RIGHT_SQUARE_BRACKET  : ']';
LEFT_ANGLE_BRACKET    : '<';
RIGHT_ANGLE_BRACKET   : '>';
DQUOTE_STRING         : '"' .*? '"';
SQUOTE_STRING         : '\'' .*? '\'';
IDENTIFIER            : ([a-zA-Z_]([A-Za-z0-9_]|[:]+)*);
