start
 = program

program
 = br blocks
 / blocks

blocks
 = block br blocks
 / declare br blocks
 / block br
 / declare br

block
 = start_block
 / end_block
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
 = [^|:\n]+

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
