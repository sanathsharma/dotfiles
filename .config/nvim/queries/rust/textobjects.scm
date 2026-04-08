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
] @custom_bracket.outer

(arguments 
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

(parameters 
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

((block) @block.outer)

(block
	. (_) @block.inner
	(_)* @block.inner)

(block
	. (_) @custom_bracket.inner
	(_)* @custom_bracket.inner)

(function_item
	(body) @function.inner)

((function_item) @function.outer)
