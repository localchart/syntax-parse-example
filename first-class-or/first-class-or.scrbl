#lang syntax-parse-example
@require[
  (for-label
    racket/base
    syntax/parse
    syntax-parse-example/first-class-or/first-class-or)]

@(define first-class-or-eval
   (make-base-eval
     '(require syntax-parse-example/first-class-or/first-class-or)))

@title{@tt{first-class-or}}

@; =============================================================================

@defmodule[syntax-parse-example/first-class-or/first-class-or]{}

@defform[(first-class-or expr ...)]{
  Racket's @racket[or] is a macro, not a function.
  It cannot be used like a normal value (i.e., evaluated as an identifier).
  @margin-note{See also @secref["and+or" #:doc '(lib "scribblings/guide/guide.scrbl")]}

  @examples[#:eval (make-base-eval)
    (or #false #true)
    (eval:error (apply or '(#false #true 0)))
  ]

  @tech/guide{Identifier macros} can be evaluated as identifiers.

  So we can write a @racket[first-class-or] macro to:
  @itemlist[
  @item{
    expand like Racket's @racket[or] when called like a function, and
  }
  @item{
    expand to a function definition when used like an identifier.
  }
  ]
  In the latter case, the function that @racket[first-class-or] evaluates to
   is similar to @racket[or], but evaluates all its arguments.

  @examples[#:eval first-class-or-eval
    (first-class-or #false #true)
    (apply first-class-or '(#false #true 0))
    (first-class-or (+ 2 3) (let loop () (loop)))
    (map first-class-or '(9 #false 3) '(8 #false #false))
  ]

  Implementation:

  @racketfile{first-class-or.rkt}

  Some comments:
  @itemlist[
  @item{
    The first two @racket[syntax/parse] clauses define what happens when @racket[or]
     is called like a function.
  }
  @item{
    The pattern @litchar{_:id} matches any @tech/reference{identifier}.
  }
  @item{
    The dot notation in @racket[(_ _?a . _?b)] could be
     @racket[(_ _?a _?b ...)] instead.
    See @secref["Pairs__Lists__and_Racket_Syntax" #:doc '(lib "scribblings/guide/guide.scrbl")]
     for intuition about what the dot means, and @secref["stxparse-patterns" #:doc '(lib "syntax/scribblings/syntax.scrbl")]
     for what it means in a syntax pattern.
  }
  ]
}
