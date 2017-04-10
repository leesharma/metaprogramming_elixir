# Chapter 4: How to Test Macros

## Notes & Annotations

### 4.1 Setting Up Your Test Suite

- why `Code.require_file/2`? Haven't seen before.

### 4.2 Deciding What to Test

- with `loop`:
  ```
  ** (CompileError) while_test.exs:16: undefined function loop/1
    (stdlib) lists.erl:1338: :lists.foreach/2
    (elixir) lib/code.ex:363: Code.require_file/2
  ```
  Need the infinite stream. Why doesn't `loop` work?
    - Oops, `loop` is a self-defined private function.
- Not how I would have done this test! Interesting.

### 4.3 Integration Testing

### 4.4 Unit Tests

### 4.5 Test Simple and Test Fast

### 4.6 Further Exploration

--------------------------------------------------------------------------------

## Outline

1. Setting Up Your Test Suite
    - `ExUnit.start` and `ExUnit.case`

2. Deciding What to Test
    - "We used processes and messages to self for cheap and easy testing."
    - "Message-sending provided a way to assert that certain events happen in
      our loop, and the process trick allowed us to easily change the
      truthiness of the while expression on demand."
    - different strategy needed for more complex metaprogramming

3. Integration Testing
    1. Test Your Generated Code, Not Your Code Generation
    2. Easy Integration Testing with Nested Modules
    - Gist: test behavior, not code generation. Use "inline" modules for
      complex tests

4. Unit Tests
    - unit tests = testing generated the AST directly
    - only use to test a bit of tricky code generation in isolation
        - leads to brittle tests
        - very finicky–even incorrect spacing will make the test fail
    - example: recursive compile with `Translation`

5. Test Simple and Test Fast
    - slow tests make testing painful/less likely
    - several conventions for writing good tests:
    1. Limit the Number of Created Modules
        - test cases can share modules
    2. Keep It Simple

6. Further Exploration
    - `Process.info(pid)[:messages]` returns a list of messages in a process’
      mailbox
