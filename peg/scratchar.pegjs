start
 = program

program
 = br cs:codes {
     return cs
   }
 / cs:codes {
     return cs
   }

codes
 = c:code br cs:codes {
     cs.unshift(c)
     return cs
   }
 / c:code {
     return [c]
   }

code
 = br s:start_block br bs:body_blocks {
     bs.unshift(s)
     return bs
   }
 / br d:declare br bs:body_blocks {
     bs.unshift(d)
     return bs
   }
 / s:start_block br bs:body_blocks {
     bs.unshift(s)
     return bs
   }
 / d:declare br bs:body_blocks {
     bs.unshift(d)
     return bs
   }
 / s:start_block br {
     return [s]
   }
 / d:declare br {
     return [d]
   }

body_blocks
 = b:body_block br bs:body_blocks {
     bs.unshift(b)
     return bs
   }
 / b:body_block br {
     return [b]
   }

body_block
 = end_block
 / middle_block
 / end_paren_block
 / middle_paren_block
 
start_block
 = "^" "|" block_contents "|"
 
middle_block
 = ":"+ "|" block_contents "|"
 
end_block
 = "_" "|" block_contents "|"

middle_paren_block
 = ":"+ "{" paren_contents ":"+ "}"

end_paren_block
 = ":"+ "{" paren_contents "_" "}"

declare
 = declare_block
 / declare_var

declare_block
 = "~" "|" declare_block_contents "|"

declare_var
 = "~" "|" declare_var_contents "|"

block_contents
 = [^|]+

paren_contents
 = paren_first_contents br middle_blocks br
 / paren_first_contents

paren_first_contents
 = contents:[^|:\n]+ { return contents }

middle_blocks
 = middle_block br middle_blocks
 / middle_paren_block br middle_blocks
 / middle_block br
 / middle_paren_block br
 / br

declare_block_contents
 = declare_block_first_contents "|" declare_block_sig "|"

declare_block_sig
 = [^|]+

declare_block_first_contents
 = [^|]+

declare_var_contents
 = [^|]+

br
 = [\n]*
