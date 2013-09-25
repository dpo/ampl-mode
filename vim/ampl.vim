" Vim syntax file
" Language:     Ampl
" Maintainer:   Dominique Orban
"               Dominique.Orban@polymtl.ca
" Last Change:  Wed May  5 12:06:54 CDT 2004
" Version:      0.1
" Remark:       Does not recognize *all* keywords yet
"               but the most commonly used ones are.


if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Case is important
syntax case match

" Keywords classification
syntax keyword amplConditional          else if then
syntax keyword amplRepeat               for repeat while until
syntax keyword amplStatement            data maximize minimize model solve
syntax match   amplStatement            /subject to/
syntax keyword amplStatement            net_in net_out to_come
syntax keyword amplDeclaration          arc node param set var function let
syntax keyword amplType                 binary integer symbolic in default logical
syntax keyword amplType                 defaultsym nodefaultsym coeff cover obj suffix
syntax keyword amplOperator             break reset check
syntax match   amplConstant             "[+-]\?Infinity"

syntax keyword amplStatement            Current Initial all
syntax keyword amplStatement            environ option
syntax keyword amplStatement            shell_exitcode solve_exitcode solve_message
syntax keyword amplStatement            solve_result solve_result_num table write

syntax keyword amplDirection            IN INOUT LOCAL OUT

syntax match   amplDotSuffix            "\.init[0]\|\.lb[12]\?"
syntax match   amplDotSuffix            "\.[ul]\?slack\|\.[lu]/?rc\|\.relax"
syntax match   amplDotSuffix            "\.[as]\?status\|\.ub[012]\?"
syntax match   amplDotSuffix            "\.val"
syntax match   amplDotSuffix            "\.body\|\.dinit[0]\|\.[l]\?dual\|\.[lu]bs"

syntax keyword amplLogicalOperator      and or not exists forall complements
syntax match   amplLogicalOperator      "&&"
syntax match   amplLogicalOperator      "||"
syntax match   amplLogicalOperator      "!="

syntax keyword amplArithmeticOperator   sum prod
syntax match   amplArithmeticOperator   "[+-]"
syntax match   amplArithmeticOperator   "\*"
syntax match   amplArithmeticOperator   "/"
syntax match   amplArithmeticOperator   "\^"

syntax match   amplRelationalOperator   "[<>=!]"

syntax match   amplRangeOperator        "\.\."

syntax match   amplNumber               "\<\d\+[ij]\=\>"
syntax match   amplFloat                "\<\d\+\(\.\d*\)\=\([edED][-+]\=\d\+\)\=[ij]\=\>"
syntax match   amplFloat                "\.\d\+\([edED][-+]\=\d\+\)\=[ij]\=\>"

syntax region  amplString               start=+\'+ skip=+\\'+ end=+\'+
syntax region  amplString               start=+\"+ skip=+\\"+ end=+\"+

syntax keyword amplBuiltinOperator      abs acos acosh alias asin asinh atan atan2
syntax keyword amplBuiltinOperator      atanh ceil ctime cos cosh exp floor log log10
syntax keyword amplBuiltinOperator      max min precision round sin sinh sqrt tan tanh
syntax keyword amplBuiltinOperator      time trunc div
syntax match   amplBuiltinOperator      "[^\.]mod"

syntax keyword amplStringOperator       num num0 ichar char length substr sprintf
syntax keyword amplStringOperator       match sub gsub printf display

syntax keyword amplBuiltinOrderedSet    next nextw prev prevw first last member inter
syntax keyword amplBuiltinOrderedSet    ord ord0 card arity indexarity diff symdiff
syntax keyword amplBuiltinOrderedSet    in within ordered by circular reversed union
syntax keyword amplBuiltinOrderedSet    cross setof less dimen interval contains

syntax keyword amplBuiltinRandom        Beta Cauchy Exponential Gamma Irand224 Normal
syntax keyword amplBuiltinRandom        Normal01 Poisson Uniform Uniform01 randseed

syntax keyword amplTodo                 TODO FIXME XXX

" Comments are everything to the right of a #
syntax match   amplComment              /#.*/

" Special characters
syntax match   amplColon                ":"
syntax match   amplAssignment           ":="
syntax match   amplSemicolon            ";"

" Blocks
syntax region  amplBlock                start=/{/    end=/}/    contains=ALL
syntax region  amplCommentBlock         start=/\/\*/ end=/\*\// keepend

" Define the default highlighting
if version >= 508 || !exists("did_ampl_syntax_inits")
    if version < 508
        let did_ampl_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink amplConditional          Conditional
    HiLink amplRepeat               Repeat
    HiLink amplStatement            Statement
    HiLink amplDotSuffix            Label
    HiLink amplDeclaration          Typedef
    HiLink amplType                 Type
    HiLink amplLogicalOperator      Operator
    HiLink amplArithmeticOperator   Operator
    HiLink amplRelationalOperator   Operator
    HiLink amplRangeOperator        Operator
    "HiLink amplNumber               Number
    "HiLink amplFloat                Float
    HiLink amplOperator             Operator
    HiLink amplConstant             Constant
    HiLink amplBuiltinOperator      Function
    HiLink amplBuiltinOrderedSet    Function
    HiLink amplBuiltinRandom        Function
    HiLink amplBlock                Normal
    HiLink amplString               String

    HiLink amplComment              Comment
    HiLink amplCommentBlock         Comment
    HiLink amplAssignment           Delimiter
    HiLink amplSemicolon            SpecialChar
    HiLink amplColon                SpecialChar

    HiLink amplTodo                 Todo

    delcommand HiLink

endif

let b:current_syntax = "ampl"
