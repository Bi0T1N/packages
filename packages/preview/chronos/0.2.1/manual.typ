#import "@preview/tidy:0.4.2"
#import "@preview/codly:1.2.0": codly-init, codly
#import "@preview/codly-languages:0.1.8": codly-languages
#import "src/lib.typ" as chronos
#import "src/participant.typ" as mod-par
#import "docs/examples.typ"
#import "docs/example.typ": example

#let TYPST = image("gallery/typst.png", width: 1.5cm, height: 1.5cm, fit: "contain")

#show: codly-init
#codly(
  languages: codly-languages
)

#set text(font: "Source Sans 3")

#set heading(numbering: (..num) => if num.pos().len() < 4 {
  numbering("1.1", ..num)
})

#align(center)[
  #v(2cm)
  #text(size: 2em)[*Chronos*]
  
  _v#chronos.version;_
  #v(1cm)
  #chronos.diagram({
    import chronos: *
    _par("u", display-name: [User], shape: "actor")
    _par("wa", display-name: [Web App])
    _par("tu", display-name: [Typst Universe], shape: "database")

    _seq("u", "wa", comment: [Compile document], enable-dst: true)
    _seq("wa", "tu", comment: [Fetch Chronos])
    _seq("tu", "wa", dashed: true, slant: 10)
    _seq("wa", "wa", comment: [Render])
    _ret(comment: [Nice sequence diagram])
  })
]

#pagebreak()

#{
  outline(indent: auto, depth: 3)
}
#show link: set text(fill: blue)

#set page(numbering: "1/1", header: align(right)[chronos #sym.dash.em v#chronos.version])
#set page(
  header: align(left)[chronos #sym.dash.em v#chronos.version],
  footer: context align(center, counter(page).display("1/1", both: true))
)

= Introduction

This package lets you create nice sequence diagrams using the CeTZ package.

= Usage

#let import-stmt = "#import \"@preview/chronos:" + str(chronos.version) + "\""

Simply import #link("https://typst.app/universe/package/chronos/")[chronos] and call the `diagram` function:
#raw(block:true, lang: "typ", ```typ
$import
#chronos.diagram({
  import chronos: *
  ...
})
```.text.replace("$import", import-stmt))

= Examples

You can find the following examples and more in the #link("https://git.kb28.ch/HEL/circuiteria/src/branch/main/gallery")[gallery] directory

== Some groups and sequences

#example(```
chronos.diagram({
  import chronos: *
  _seq("Alice", "Bob", comment: "Authentication Request")
  _seq("Bob", "Alice", comment: "Authentication Failure")

  _grp("My own label", desc: "My own label2", {
    _seq("Alice", "Log", comment: "Log attack start")
    _grp("loop", desc: "1000 times", {
      _seq("Alice", "Bob", comment: "DNS Attack")
    })
    _seq("Alice", "Bob", comment: "Log attack end")
  })
})
```, wrap: false, vertical: true)

#pagebreak(weak: true)

== Lifelines

#example(```
chronos.diagram({
  import chronos: *
  _seq("alice", "bob", comment: "hello", enable-dst: true)
  _seq("bob", "bob", comment: "self call", enable-dst: true)
  _seq(
    "bill", "bob",
    comment: "hello from thread 2",
    enable-dst: true,
    lifeline-style: (fill: rgb("#005500"))
  )
  _seq("bob", "george", comment: "create", create-dst: true)
  _seq(
    "bob", "bill",
    comment: "done in thread 2",
    disable-src: true,
    dashed: true
  )
  _seq("bob", "bob", comment: "rc", disable-src: true, dashed: true)
  _seq("bob", "george", comment: "delete", destroy-dst: true)
  _seq("bob", "alice", comment: "success", disable-src: true, dashed: true)
})
```, wrap: false, vertical: true)

#pagebreak(weak: true)

== Found and lost messages

#example(```
chronos.diagram({
  import chronos: *
  _seq("?", "Alice", comment: [?->\ *short* to actor1])
  _seq("[", "Alice", comment: [\[->\ *from start* to actor1])
  _seq("[", "Bob", comment: [\[->\ *from start* to actor2])
  _seq("?", "Bob", comment: [?->\ *short* to actor2])
  _seq("Alice", "]", comment: [->\]\ from actor1 *to end*])
  _seq("Alice", "?", comment: [->?\ *short* from actor1])
  _seq("Alice", "Bob", comment: [->\ from actor1 to actor2])
})
```, wrap: false, vertical: true)

#pagebreak(weak: true)

== Custom images

#example(```
let load-img(path) = image(
  path,
  width: 1.5cm, height: 1.5cm,
  fit:"contain"
)
let TYPST = load-img("../gallery/typst.png")
let FERRIS = load-img("../gallery/ferris.png")
let ME = load-img("../gallery/me.jpg")

chronos.diagram({
  import chronos: *
  _par("me", display-name: "Me", shape: "custom", custom-image: ME)
  _par("typst", display-name: "Typst", shape: "custom", custom-image: TYPST)
  _par("rust", display-name: "Rust", shape: "custom", custom-image: FERRIS)

  _seq("me", "typst", comment: "opens document", enable-dst: true)
  _seq("me", "typst", comment: "types document")
  _seq("typst", "rust", comment: "compiles content", enable-dst: true)
  _seq("rust", "typst", comment: "renders document", disable-src: true)
  _seq("typst", "me", comment: "displays document", disable-src: true)
})
```, wrap: false, vertical: true)

#pagebreak(weak: true)

= Reference

#let par-docs = tidy.parse-module(
  read("docs/participants.typ"),
  name: "Participants",
  require-all-parameters: true,
  old-syntax: true,
  scope: (
    chronos: chronos,
    mod-par: mod-par,
    TYPST: TYPST
  )
)
#tidy.show-module(par-docs, show-outline: false, sort-functions: none)

#pagebreak(weak: true)

#let seq-docs = tidy.parse-module(
  read("docs/sequences.typ"),
  name: "Sequences",
  require-all-parameters: true,
  old-syntax: true,
  scope: (
    chronos: chronos,
    examples: examples
  )
)
#tidy.show-module(seq-docs, show-outline: false, sort-functions: none)

#pagebreak(weak: true)

#let grp-docs = tidy.parse-module(
  read("docs/groups.typ"),
  name: "Groups",
  require-all-parameters: true,
  old-syntax: true,
  scope: (
    chronos: chronos,
    examples: examples
  )
)
#tidy.show-module(grp-docs, show-outline: false, sort-functions: none)

#pagebreak(weak: true)

#let gap-sep-docs = tidy.parse-module(
  read("docs/gaps_seps.typ"),
  name: "Gaps and separators",
  require-all-parameters: true,
  old-syntax: true,
  scope: (
    chronos: chronos,
    examples: examples
  )
)
#tidy.show-module(gap-sep-docs, show-outline: false, sort-functions: none)

#pagebreak(weak: true)

#let notes-docs = tidy.parse-module(
  read("docs/notes.typ"),
  name: "Notes",
  require-all-parameters: true,
  old-syntax: true,
  scope: (
    chronos: chronos,
    examples: examples
  )
)
#tidy.show-module(notes-docs, show-outline: false)
