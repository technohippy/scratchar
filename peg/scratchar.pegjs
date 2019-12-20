{
  class ProgramNode {
    constructor(codes=[]) {
      this.type = "program"
      this.codes = codes
    }
  }

  class CodeNode {
    constructor(blocks=[]) {
      this.type = "code"
      this.blocks = blocks
    }
  }

  class BlockNode {
    constructor(type, expressions=[]) {
      this.type = `${type}_block`
      this.expressions = expressions
    }
  }

  class ParenBlockNode {
    constructor(type, expressions=[], children=[]) {
      this.type = `${type}_paren_block`
      this.expressions = expressions
      this.children = children
    }
  }

  class DeclareNode {
  }

  class VarNode {
    constructor(expressions=[]) {
      this.type = "var"
      this.expressions = expressions
    }
  }

  class BoolVarNode {
    constructor(expressions=[]) {
      this.type = "bool_var"
      this.expressions = expressions
    }
  }

  class OptionNode {
    constructor(val) {
      this.type = "option"
      this.value = val
    }
  }

  class OptionVarNode {
    constructor(val) {
      this.type = "option_var"
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
 = "^" "|" es:expressions "|" {
     return new BlockNode("start", es)
   }
 
middle_block
 = ":"+ "|" es:expressions "|" {
     return new BlockNode("middle", es)
   }
 
end_block
 = "_" "|" es:expressions "|" {
     return new BlockNode("end", es)
   }

middle_paren_block
 = ":"+ "{" pc:paren_contents ":"+ "}" {
     pc.type = "middle_parent_block"
     return pc
   }

end_paren_block
 = ":"+ "{" pc:paren_contents "_" "}" {
     pc.type = "end_parent_block"
     return pc
   }

declare
 = declare_block
 / declare_var

declare_block
 = "~" "|" expressions "|" expressions "|" "|"

declare_var
 = "~" "|" declare_var_contents "|"

paren_contents
 = es:expressions br bs:middle_blocks br {
     return new ParenBlockNode("", es, bs)
   }
 / es:expressions {
     return new ParenBlockNode("", es)
   }

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
