# Thoughts, Questions, and Annotations

## The World Is Your Playground

- And we start with a while loop. Whomp whomp.
- “José Valim, the creator of Elixir, chose to do something very different. He
  exposed the AST in a form that can be represented by Elixir’s own data
  structures and gave us a natural syntax to interact with it.” I think this is
  really cool. It’s kind of like lisp (where you seem to be writing the AST).
  Does anyone know of other languages that do this? Has anyone heard him
  justify/explain his reasoning behind this? What are the downsides? It seems
  like a very powerful idea, and I’m wondering why so many languages hide it.
- Aside from `quote`/`unquote`, I’ve found the `Code` module helpful for playing
  with the AST. I’ve been using `Code.string_to_quoted` to generate an AST of
  my saved elixir files, and there are a ton of other neat functions there too.
- Understanding: the AST is composed of a bunch of doubles/triples. Triples
  include the function atom, the context/meta information, and a list of
  arguments.
- Awesome code focused on manipulating, parsing, and walking the AST: elixir
  itself, credo
- Seriously, [Chris's talk on this](https://vimeo.com/131643017) is good
- Relevant/awesome ElixirConf talks?
- exercise: write the AST for exercism

## Macro Rules

- Has anyone used macros in lisp or another powerful macro language? Horror
  stories/guidelines?
- Ideas of interesting exercises/projects?

## The Abstract Syntax Tree—Demystified

- What kind of output would be the most human-readable? (for web proj) How are
  trees usually displayed?
  - json outputs
  - tree (like in outline below)
- Has anyone used Lisp? Does it feel the same?
- What does the metadata do? Lisp doesn't have it.

## Macros: The Building Blocks of Elixir

- How does a `do` block get converted to the keyword argument?
- `Macro` module–`Macro.expand/2` is interesting (pass `__ENV__`)
- What are the `counter` and `optimize_boolean` metadata?

## Code Injection and the Caller's Context

## Further Exploration

--------------------------------------------------------------------------------

# Outline

## The World Is Your Playground (started: 10/20)
    1. The Abstract Syntax Tree
        - “José Valim, the creator of Elixir, chose to do something very
          different. He exposed the AST in a form that can be represented by
          Elixir’s own data structures and gave us a natural syntax to interact
          with it.”
        - “Having the AST accessible by normal Elixir code lets you do very
          powerful things because you can operate at the level typically reserved
          only for compilers and language designers.”
    2. Macros
        - “They turn you, the programmer, from language consumer to language
          creator. No longer are you merely a user of the language.”
    3. Tying It All Together
        - macros receive ASTs as args and return ASTs as return values
        - `ch1/math.exs` example

## Macro Rules
    - Rule 1: Don’t Write Macros
    - Rule 2: Write Macros Gratuitously

## The Abstract Syntax Tree—Demystified (started: 10/21)
    1. The Structure of the AST
        - Every expression you write in Elixir breaks down to a three-element
          tuple in the AST. It has the following format:
            1. The first element is an atom denoting the function call, or
               another tuple, representing a nested node in the AST
            2. The second element represents the metadata about the expression
            3. The third element is a list of arguments for the function call
        - Tree for `(5 * 2) - 1 + 7`
            ```
            +               {:+, [...], [
            ├┬─── -           {:-, [...], [
            │├┬───── *          {:*, [...]. [
            ││├───── 5            5,
            ││└───── 2            2]}
            │└─── 1           , 1]}
            └─ 7            , 7]}
            ```

    2. High-Level Syntax vs. Low-level AST
        - Like a Lisp
    3. AST Literals
        - Return themselves when quoted:
          * atoms
          * integers
          * floats
          * lists
          * strings
          * doubles (two-element tuples) with the above
          - Example: `quote do: {:ok, [1, 2, 3]}` => `{:ok, [1, 2, 3]}`
        - Other types: abstract representation
          - Example: `quote do: %{a: 1, b: 2}` => `{:%{}, [], [a: 1, b: 2]}`

## Macros: The Building Blocks of Elixir (started: 10/22)
    1. Re-Creating Elixir's `unless` Macro
        - must `require` modules for macros
        - start with `quote`–you need to return an AST representation
        - transformation from a macro to the "next level"–*macro expansion*
    2. `unquote`
        - "`quote`/`unquote` [is like] string interpolation for code."
    3. Macro Expansion
        - recursively expands macros
        - For example:
          ```elixir
          ControlFLow.unless 2==5, do: "block entered"

          # goes to
          if !(2==5), do: "block entered"

          # goes to
          case !(2==5) do
            x when x in [false, nil]  -> nil
            _                         -> "block entered"
          end
          ```
          - `case` is a special macro in `Kernel.SpecialForms`
            (http://elixir-lang.org/docs/stable/elixir/Kernel.SpecialForms.html)

## Code Injection and the Caller's Context
    - *context*: A place where code is injected; the scope of the caller's
      bindings, imports, and aliases (important for immutability)

    1. Injecting Code
        - macro executes in two contexts:
          1. macro definition
          2. caller invocation
        - example: `callers_context.exs`
          - both statements are printed with the `Mod.definfo` call
          - before macro is expanded, `IO.puts` is called. Next, it's injected
    2. Hygiene Protects the Caller's Context
        - you must **explicitly** mark unhygienic functions
    3. Overriding Hygiene
        - `var!(variable_name)` explicitly overrides hygiene

## Further Exploration
    1. See `ch1/exercises.exs`
