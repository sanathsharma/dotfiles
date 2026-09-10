; Play around with textobject and capture groups here: https://tree-sitter.github.io/tree-sitter/7-playground.html

; block

((block) @block.outer)

(block
	. (_) @block.inner
	(_)* @block.inner)

; function

(function_item
	(block) @function.inner) @function.outer

