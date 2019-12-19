{
  class ProgramNode {
    constructor(codes=[]) {
      this.codes = codes
    }
  }

  class CodeNode {
    constructor(blocks=[]) {
      this.blocks = blocks
    }
  }

  class BlockNode {
    constructor(signature=[]) {
      this.signature = signature
    }
  }

  class ParenBlockNode extends BlockNode {
    constructor(children=[]) {
      this.children = children
    }
  }

  class DeclareNode {
  }

  class VarNode {
    constructor(expressions=[]) {
      this.expressions = expressions
    }
  }

  class BoolVarNode {
    constructor(expressions=[]) {
      this.expressions = expressions
    }
  }

  class OptionNode {
    constructor(val) {
      this.value = val
    }
  }

  class OptionVarNode {
    constructor(val) {
      this.value = val
    }
  }
}

start
 = program

program
 = br cs:codes {
     return new ProgramNode(cs)
   }
 / cs:codes {
     return new ProgramNode(cs)
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
     return new CodeNode(bs)
   }
 / br d:declare br bs:body_blocks {
     bs.unshift(d)
     return new CodeNode(bs)
   }
 / s:start_block br bs:body_blocks {
     bs.unshift(s)
     return new CodeNode(bs)
   }
 / d:declare br bs:body_blocks {
     bs.unshift(d)
     return new CodeNode(bs)
   }
 / s:start_block br {
     return new CodeNode([s])
   }
 / d:declare br {
     return new CodeNode([d])
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
 = "^" "|" expressions "|"
 
middle_block
 = ":"+ "|" expressions "|"
 
end_block
 = "_" "|" expressions "|"

middle_paren_block
 = ":"+ "{" paren_contents ":"+ "}"

end_paren_block
 = ":"+ "{" paren_contents "_" "}"

declare
 = declare_block
 / declare_var

/*
declare_block
 = "~" "|" declare_block_contents "|"
*/

declare_block
 = "~" "|" expressions "|" expressions "|" "|"

declare_var
 = "~" "|" declare_var_contents "|"

/*
paren_contents
 = paren_first_contents br middle_blocks br
 / paren_first_contents
*/
paren_contents
 = expressions br middle_blocks br
 / expressions

paren_first_contents
 = c:[^|:\n]+ {
     return c.join("") 
   }

middle_blocks
 = b:middle_block br bs:middle_blocks {
     bs.unshift(b)
     return bs
   }
 / b:middle_paren_block br bs:middle_blocks {
     bs.unshift(b)
     return bs
   }
 / b:middle_block br {
     return [b]
   }
 / b:middle_paren_block br {
     return [b]
   }
 / br {
     return []
   }

declare_block_contents
 = declare_block_first_contents "|" declare_block_sig "|"

declare_block_sig
 = [^|]+

declare_block_first_contents
 = [^|]+

declare_var_contents
 = [^|]+

option
 = "[*" w:word "*]" {
     return new OptionNode(w)
   }

option_var
 = "(*" w:word "*)" {
     return new OptionVarNode(w)
   }

var
 = "(" es:expressions")" {
     return new VarNode(es)
   }

bool_var
 = "<" expressions ">" {
     return new BoolVarNode(es)
   }

words
 = w:word ws:words {
     ws.unshift(w)
     return ws
   }
 / w:word {
     return [w]
   }

word
 = w:[^|\[\]\()*\n]+ { 
     return w.join("")
   }

expressions
 = e:expression es:expressions {
     es.unshift(e)
     return es
   }
 / e:expression {
     return [e]
   }

expression
 = word
 / option
 / option_var
 / var
 / bool_var

paren_word
 = w:[^:|\[\]\()*\n]+ { 
     return w.join("")
   }

paren_expressions
 = e:paren_expression es:paren_expressions {
     es.unshift(e)
     return es
   }
 / e:paren_expression {
     return [e]
   }

paren_expression
 = paren_word
 / option
 / option_var
 / var
 / bool_var

spaces
 = space
 / space spaces

space
 = " "
 / "\t"

br
 = [\n]*
