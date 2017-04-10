# Chapter 2: Extending Elixir with Metaprogramming

## Thoughts & Annotations

### 2.1 Custom Language Constructs

- Sanity check on `if_recreated.exs`:
    - Doesn't `if_recreated.exs` example rely on `if`?
    - Example returns the wrong value for `ControlFlow.my_if(1==2, do: "correct")`
        - `false` works fine
    - Known problem
    - Second clause is expanded during compilation due to first clause
    - `c "filename.exs"` acts weird. What caching happens? Sometimes it requires
      a second compile to print output to console, sometimes compiletime errors
      seem to be cached until I exit out of iex and re-start it
    - Reason: The first clause gets expanded during compile-time, using the
      args from pattern matching. Unfortunately, they are in AST-form, so they're
      always truthy.
- In second example `while.exs`, why are we doing a stream instead of `loop`?

### 2.2 Smarter Testing with Macros

- I think this (delegating to another module) is how `if` works. (Look up)

### 2.3 Extending Modules

- On L5 of `module_extension_custom.exs`, what's `import` for?

### 2.4 Using Module Attributes for Code Generation

- Major takeaway: be careful of order!
- Figured out what `import` is for (for assertions/test to be used directly!)

### 2.5 Compile-Time Hooks

- Example of proxying to an outside function whenever possible
- Example of having functions return records/tagged values and formating in one
  place
- Takeaways:
    - `@before_compile` -> `SomeMacro.__before_compile__/1`
    - keep macro expansions concise
    - delegate to functions when possible
    - separate calculation (running tests) and formatting

### 2.6 Further Exploration

- Assignment: enhance `Assertion` tests
    - Implement `assert` for every operator in Elixir
    - Add boolean assertions, such as `assert true`
    - Implement a `refute` macro for refutions
    - Advanced:
        - Run test cases in parallel within `Assertion.Test.run/2` via spawned
          processes
        - Add reports for the module. Include pass/fail counts and execution
          time

--------------------------------------------------------------------------------

## Outline

1. Custom Language Constructs (started: 10/23)
    1. Re-Creating the `if` Macro
        - example: `ch2/if_recreated.exs`
    2. Adding a `while` Loop to Elixir
        - can create an infinite loop with a stream
        - using judicious `try`/`catch`, can break out of an infinite loop

2. Smarter Testing with Macros (started: 10/24)
    - Priorities with testing: clear failure messages, consistant API. With
      macros, you don't need the huge API of other testing frameworks.
    1. Supercharged Assertions
    2. `bind_quoted`
        - `unquote` evaluates your expression–bad practice for multiple uses
        - `bind_quoted` evaluates once and saves the result
        - Note: `bind_quoted` will disable `unquote` unless explicitly reenabled
    3. Leveraging the VM's Pattern Matching Engine (started: 10/26)
        - pattern matching = optimized
        - delegate out to another module to avoid importing unnecissary funcs
            - minimum generated code possible
            - "pivitol to writing maintainable macros"

3. Extending Modules
    - Goals: add a `test` macro and better error messages, inserted with `use`
    1. Module Extension Is Simply Code Injection
        - by putting `def ... end` in `quote`, functions can be injected
        - the macro `extend` does all the work here
    2. `use`: A Common API for Module Extension
        - `use SomeModule` invokes `SomeModule.__using__/1`
        - `use` is just a macro (eqiv. to `require X; X.<extension macro>`)
              - Yay for internal consistancy!

4. Using Module Attributes for Code Generation
    - "Module attributes allow data to be stored in the module at compile time."
        - like constants
            - ex: adding with each macro "invocation"/func creation
        - `Module.register_attributes __MODULE__, :attr_name, opts`
            - `accumulate: true` keeps appended list of registrations
    - order matters, esp. if you're using attributes (`before_compile`)

5. Compile-Time Hooks
    - `@before_compile SomeModule` acts as a placeholder for
      `SomeModule.__before_compile__/1`. Macro is invoked just before
      compilation "in order to perform a final bit of code generation"
    - Once again: delegate to outside functions when possible
    - Once again: keep macro expansions consise

6. Futher Exploration
