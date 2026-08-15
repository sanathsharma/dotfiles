; Play around with textobject and capture groups here: https://tree-sitter.github.io/tree-sitter/7-playground.html

; strings

(string_literal
	. (_) @custom_string.inner
	(_)* @custom_string.inner)

((string_literal) @custom_string.outer)

((char_literal) @custom_string.outer)

(raw_string_literal
	. (_) @custom_string.inner
	(_)* @custom_string.inner)

((raw_string_literal) @custom_string.outer)

; brackets

[
 (arguments)
 (parameters)
 (block)
 (array_expression)
 (tuple_expression)
] @custom_bracket.outer

(arguments 
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

(parameters 
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

(block
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

(array_expression
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

(tuple_expression
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

; (array_expression
;   (_) @_first @_last
;   (#make-range! "custom_bracket.inner" @_first @_last))
;
; (tuple_expression
;   (_) @_first @_last
;   (#make-range! "custom_bracket.inner" @_first @_last))

; block

((block) @block.outer)

(block
	. (_) @block.inner
	(_)* @block.inner)

; function

(function_item
	(block) @function.inner) @function.outer

