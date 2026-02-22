---
name: testing
description: "Behavioral testing strategy — deciding what to test and how. Use when writing tests, reviewing test quality, or fixing tests that test mocks instead of behavior. Triggers on: 'use testing mode', 'write tests', 'test strategy', 'tests are brittle', 'tests test mocks', 'improve test quality', 'what should I test'. Full access mode - can write and run tests."
---

# Testing Strategy

Decide what to test and how to test it. Write tests that catch real regressions.

> "Tests should be coupled to the behavior of code and decoupled from the structure of code." — Kent Beck

## The Self-Test

Ask these 5 questions about EVERY test you write. If any answer is "no", rewrite the test.

| #   | Question                                                  | What It Checks         |
| --- | --------------------------------------------------------- | ---------------------- |
| 1   | Could I rewrite the internals and this test still passes? | Structure-insensitive  |
| 2   | Am I testing what the code SHOULD DO, not what it DOES?   | Behavioral             |
| 3   | If this test passes, do I trust the code works?           | Predictive / Inspiring |
| 4   | Am I testing through the public API?                      | Public contract        |
| 5   | Am I checking state/output, not verifying call sequences? | State > Interaction    |

**The Refactoring Litmus Test**: After writing a test, imagine completely rewriting the internals while keeping the same public behavior. Would the test still pass? If not, it's coupled to structure and will become a maintenance burden.

## Test Double Decision Tree

Choose the simplest test double that gives confidence. Work top to bottom — stop at the first "yes".

```
Can I use the REAL implementation?
├─ Yes → Use it (always the first choice)
└─ No → Is it slow, non-deterministic, or expensive?
         ├─ Yes → Is a FAKE available? (in-memory DB, fake server)
         │        ├─ Yes → Use the fake
         │        └─ No → STUB specific return values (keep count low)
         └─ No → Do I need to verify external SIDE EFFECTS?
                  (email sent, record saved, event published)
                  ├─ Yes → Interaction test with verify (LAST RESORT)
                  └─ No → Re-examine — you probably CAN use the real thing
```

### When to Mock

**Mock AT boundaries (external edges of your system):**

- External HTTP APIs → fake server or stub responses
- Databases → in-memory DB, fake repository, or testcontainers
- File system → in-memory FS or temp directories
- System clock → inject controllable clock
- Non-deterministic sources → seeded random, fixed UUIDs
- Expensive third-party calls → stub at the adapter layer

**Never mock these:**

- Internal collaborator classes
- Value objects or data structures
- Pure functions or utilities
- Anything you can instantiate cheaply

**"Don't Mock What You Don't Own"**: If you must mock a third-party API, wrap it in your own adapter and mock the adapter.

## What to Test

Think in **behaviors**, not methods. Each test covers one behavior: "Given X, when Y, then Z."

### Identify Behaviors

Don't write one test per method. Write one test per behavior:

```python
# BAD — one method, one test (grows unwieldy)
def test_process_transaction():
    # tests display, validation, AND balance check in one test
    ...

# GOOD — one behavior, one test
def test_process_transaction_displays_item_name(): ...
def test_process_transaction_rejects_negative_amount(): ...
def test_process_transaction_warns_on_low_balance(): ...
```

### Priority Order

1. **Edge cases and error conditions** — these catch real bugs
2. **Business rules and invariants** — the core logic
3. **Integration boundaries** — where systems meet
4. **Happy path** — last, not first (it's usually the most obvious)

### Usually Skip

- Third-party library internals
- Simple getters/setters
- Framework boilerplate
- Implementation details that may change

### Bug Fixes

Always write a failing test FIRST that reproduces the bug. Then fix it. Never fix a bug without a regression test.

## Anti-Patterns: Before and After

### 1. Over-Mocking → Use Real Implementations

```python
# BEFORE — testing mocks, not code
@patch("myapp.cache.get")
@patch("myapp.db.query")
@patch("myapp.validator.check")
def test_process(mock_check, mock_cache, mock_db):
    mock_db.return_value = {"id": 1}
    mock_cache.return_value = None
    mock_check.return_value = True
    result = process(1)  # What are we even testing?
    assert result == {"id": 1}

# AFTER — test with real collaborators
def test_process():
    db = InMemoryDatabase({"users": [{"id": 1, "name": "Alice"}]})
    service = ProcessingService(db=db, cache=MemoryCache())
    result = service.process(1)
    assert result.name == "Alice"
```

### 2. Mirror Tests → Test Outcomes, Not Steps

```python
# BEFORE — mirrors implementation step by step
def test_register_user():
    service.register("alice@test.com", "pass123")
    mock_validator.validate.assert_called_once_with("alice@test.com")
    mock_db.insert.assert_called_once()
    mock_email.send.assert_called_once_with(
        to="alice@test.com", template="welcome"
    )

# AFTER — asserts observable outcomes
def test_register_user():
    service.register("alice@test.com", "pass123")
    assert service.get_user("alice@test.com") is not None  # user exists
    assert len(email_server.sent) == 1                      # email sent
    assert email_server.sent[0].to == "alice@test.com"
```

### 3. Logic in Tests → Hardcode Expected Values

```python
# BEFORE — computed expected value hides bugs
def test_url_construction():
    base = "http://example.com/"
    result = build_url("albums")
    assert result == base + "/albums"  # double-slash bug hidden!

# AFTER — explicit expected value, trivially correct
def test_url_construction():
    result = build_url("albums")
    assert result == "http://example.com/albums"
```

### 4. Method-Driven → Behavior-Driven

```python
# BEFORE — one test per method, testing structure
def test_set_balance():
    account.set_balance(100)
    assert account.balance == 100

def test_withdraw():
    account.set_balance(100)
    account.withdraw(30)
    assert account.balance == 70

# AFTER — one test per behavior, testing through public API
def test_withdrawal_reduces_balance():
    account = Account(initial_balance=100)
    account.withdraw(30)
    assert account.balance == 70

def test_withdrawal_exceeding_balance_is_rejected():
    account = Account(initial_balance=50)
    with pytest.raises(InsufficientFunds):
        account.withdraw(100)
    assert account.balance == 50  # unchanged
```

## Writing Good Tests

### Naming Conventions

Describe **what scenario** is tested and **what outcome** is expected:

```python
# Good — scenario + expected outcome
def test_expired_token_returns_401(): ...
def test_checkout_with_empty_cart_raises_error(): ...
def test_transfer_insufficient_balance_raises_error(): ...
def test_login_wrong_password_locks_after_3_attempts(): ...
def test_search_returns_empty_list_when_no_matches(): ...

# Bad — vague, no outcome
def test_token_expiry_check(): ...
def test_transfer(): ...
def test_login_error(): ...
def test_search_works(): ...
```

### Test Structure: AAA / GWT

Structure each test as **Arrange → Act → Assert** (or **Given → When → Then**). Keep sections visually distinct — whitespace or comments between the three phases help readability.

### DAMP, Not DRY

Tests should be **Descriptive And Meaningful Phrases**. Duplicate for clarity:

- Use helper methods for **constructing** test objects (factories with sensible defaults)
- Use factory helpers like `make_user(**overrides)` to build test objects with sensible defaults — override only fields relevant to the test
- Avoid helpers that **hide what's being asserted**
- Each test should be readable without scrolling to shared setup
- Prefer explicit inline values over shared constants with ambiguous names

### No Logic in Test Bodies

Tests should be trivially correct on inspection. Straight-line code only:

- ❌ No loops, conditionals, or string concatenation in assertions
- ❌ No computed expected values
- ✅ Hardcode every expected value
- ✅ One clear path from setup → action → assertion

## Test Quality Checklist

Before committing tests, verify each one:

```markdown
- [ ] Passes the 5-question Self-Test (above)
- [ ] Name describes scenario + expected outcome
- [ ] No logic (loops, conditionals) in test body
- [ ] Each test is self-contained (DAMP: readable without shared context)
- [ ] Failure message tells you what's wrong without reading the test
- [ ] Uses real implementations where possible (mocks only at boundaries)
- [ ] Tests behavior through public API, not internal methods
```
