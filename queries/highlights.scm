[ "var"
  "const"
  "axiom"
  "function"
  "procedure"
  "implementation"
  "free"
  "ensures"
  "requires"
  "modifies"
  "call"
  "assume"
  "returns"
  "uses"
  "assert"
  "where"
  "havoc"
  "datatype"
  "invariant"
  ] @keyword
(Pure) @keyword

((ident) @variable.builtin (#eq? @variable.builtin "this"))
((ident) @constant.builtin (#eq? @constant.builtin "null"))

[ "is" ] @keyword.operator

[ "while"
  ] @keyword.repeat

["type"] @keyword
(UserDefinedType (Ident) @type.definition)

[ "if" "then" "else" ] @keyword.conditional

[ "unique" "revealed" "async" ] @keyword.modifier

[ "return" ] @keyword.return
[ "goto" ] @keyword
(TransferCmd "goto" (Idents (Ident) @function.method.call))

[ ";" "," ] @punctuation.delimiter
[ "=" ":=" "|{" "}|" ] @punctuation
[ "{" "}" "[" "]" ] @punctuation.bracket

(comment) @comment
[
 (float)
 (dec_float)
 (decimal)
 (digits)
 (bvlit)
] @number

[ "bool"
  (TypeAtom ["int" "real"]) ] @type.builtin

(Type (Ident) @type)
(WhiteSpaceIdents (Ident) @type) ; used for generic type applications
(VarOrType (Type (Ident) @variable.parameter) ":")
(TypeParams (Idents (Ident) @type))
(TypeArgs (Ident) @type)
(Datatype (Ident) @type.definition)
(Constructor (Ident) @type.definition)

[ "true"
  "false" ] @boolean

[ "roundNearestTiesToEven"
  "RNE"
  "roundNearestTiesToAway"
  "RNA"
  "roundTowardPositive"
  "RTP"
  "roundTowardNegative"
  "RTN"
  "roundTowardZero"
  "RTZ" ] @constant.builtin

[ "old" (AtomExpression ["int" "real"]) ] @function.builtin
(Guard "*" @function.builtin)

[ "forall"
  "exists"
  "lambda"
  (Forall)
  (Exists)
  (Lambda)
  "==>"
  "<==>"
  "<==>"
  "::"
  ] @keyword.operator

(ProcSignature (Ident) @function)
(Function (Ident) @function)

(AttributesIdsTypeWhere (Idents (Ident) @variable.parameter) ":")
(IdsTypeWhere (Idents (Ident) @variable.parameter) ":")

(AttributeOrTrigger
  "{" @attribute
  (":" @attribute (Ident) @attribute)
  "}" @attribute
  )

(string) @string

(SpecBlock (Ident) @function.method)
(LabelOrAssign (Ident) @function.method ":")
(LabelOrAssign (Ident) @type "(" (Idents (Ident) @variable.member) ")" ":=")
(IsConstructor "is" (Ident) @type)

(AtomExpression (Ident) @function.call "(")

(CallParams (Ident) @function.call "(")
