# Chapter 3: Advanced Compile-Time Code Generation

## Thoughts and Annotations

### 3.1 Generating Functions from External Data

- I know that the Erlang Virtual Machine’s pattern-matching engine is optimized,
	but is there any real cost to adding functions? Is this a free addition? Where
	are the limitations?

### 3.2 MIME-Type Conversion in Ten Lines of Code

- Why did he use `&String.strip(&1)` instead of `&String.strip/1`?
- How is `unquote` being used outside a `quote` block? Is it because `def` is a
  macro?
    - Answer: "unquote fragments"
    - http://elixir-lang.org/docs/stable/elixir/Kernel.SpecialForms.html#quote/2-binding-and-unquote-fragments
    - Can solve similar problems as `bind_quoted` (resolve variables (as opposed
      to the representations of variables) in compile time)
    - What are actually happening with unquote fragments?

### 3.3 Build an Internationalization Library

- why is `persist: false` specified? Isn't that the default?
- "Elixir doesn’t mind definitions within lists"–what does this mean? Does
  Elixir automatically evaluate/follow some structures? Where is the ambiguity?
- I broke out the gnarly lambda in `interpolate` into a named function
- This code is kind of tough to read!
    - common patterns: `__using__`, `Module.register_attribute` +
      `__before_compile__`
    - minimal defmacros

### 3.4 Code Generation from Remote APIs

- `--sup` vs `--bare` debate: https://github.com/elixir-lang/elixir/issues/2074
- packages are way out of date–updated
- difference between `quote` and `Macro.escape`?
    - `Macro.escape` used within `unquote` fragments
    - Any other times?

### 3.5 Further Exploration

--------------------------------------------------------------------------------

## Outline

1. Generating Functions from External Data (started: 10/27)
    - unicode uses `UnicodeData.txt` to dynamically generate pattern-matching
      functions during compile time
    - no data structure to hold in memory
    - can add to it by updating `UnicodeData.txt` and running `mix compile`
    - https://github.com/elixir-lang/elixir/tree/master/lib/elixir/unicode

2. MIME-Type Conversion in Ten Lines of Code
    1. Making Use of Existing Datasets
        - example: `mimes.exs` + `mimes.txt`
        - "unquote fragments" let us inject variables in compile time
            - used for dynamically generating function names
    2. Recompiling Modules when External Resources Change
        -`@external_resource` attribute will auto-recompile when ext. resources
          change
            - accumulated attribute (multiple resources)

3. Building an Internationalization Library
    - `i18n.exs`
    1. Step 1: Plan Your Macro API
        - "README-driven development". What should the interface look like?
    2. Step 2: Implement a Skeleton Module with Metaprogramming Hooks
        - Fill out the macro-ish parts of `Translator`, leaving the funcs as
          stubs. This will help keep the meta part lean
    3. Step 3: Generate Code from Your Accumulated Module Attributes
        - Fill out a `deftranslations` function that generates `t` clauses
    4. `Macro.to_string`: Make Sense of Your Generated Code
        - "It’s a good idea to use Macro.to_string any time you’re generating an
           AST with many function definitions. You can see the final expanded
           code that will be injected into the caller and ensure that your
           generated arguments will be properly pattern matched."
    5. Final Step: Identify Areas for Compile-Time Optimizations
        - Doing the regex scanning during compile time is a major optimization
        - Instead, use string concat + bindings look-ups in the AST
        - When quote blocks are in the same module, they share the same context
    6. The Complete Translator Module

4. Code Generation from Remote APIs (started: 10/28)
    1. Mix Project Setup
    2. Remote Code Generation
        - In 20 lines of code, we generated a whole interface with one API call
    3. `Macro.escape`
        - "used to take an elixir literal and recursively escape it for
          injection into an AST"
        - "required when you need to inject an Elixir value into a quoted
          expression where the value isn't an AST literal"
				- *invalid quoted expression* error -> possible `Macro.escape`
						- if the base expression is already quoted (and injectee is a non-
							literal)

5. Further Exploration
