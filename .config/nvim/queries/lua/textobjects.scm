; Play around with textobject and capture groups here: https://tree-sitter.github.io/tree-sitter/7-playground.html

(string
  (string_content) @custom_string.inner)
  
((string) @custom_string.outer)

((function_declaration) @function.outer)

(function_declaration
	(block) @function.inner)

((function_definition) @function.outer)

(function_definition
	(block) @function.inner)

((block) @block.outer)

(block
	. (_) @block.inner
	(_)* @block.inner)
