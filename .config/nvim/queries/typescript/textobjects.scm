; Play around with textobject and capture groups here: https://tree-sitter.github.io/tree-sitter/7-playground.html

(string
  (string_fragment) @custom_string.inner)
  
((string) @custom_string.outer)

(template_string
  . (_) @custom_string.inner
  (_)* @custom_string.inner)
   
((template_string) @custom_string.outer)
