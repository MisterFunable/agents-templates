# AGENTS_PROMPT.md Example Usage

Real-world examples of using AGENTS_PROMPT.md templates for common development tasks.

## Example 1: Code Review on API Endpoint

**Scenario:** You have an API endpoint that works but want to ensure it's production-ready.

**Prompt used:**
```
Review this code for:
1. **Bugs**: Logic errors, edge cases, null checks, off-by-one
2. **Performance**: O(n) complexity, unnecessary iterations, memory leaks
3. **Security**: Injection risks, input validation, exposed secrets
4. **Readability**: Naming, structure, unnecessary complexity
5. **Best Practices**: Python-specific patterns

For each issue found:
- Line number
- Problem description
- Severity (critical/high/medium/low)
- Suggested fix with code
```

**Input code:**
```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/api/users/<id>', methods=['GET'])
def get_user(id):
    conn = db.connect('postgresql://user:password@localhost/mydb')
    query = f"SELECT * FROM users WHERE id = {id}"
    result = conn.execute(query)
    user = result.fetchone()
    return jsonify(user)
```

**AI Output:** (example)
```
Issues Found:

1. **Line 8 - SQL Injection - CRITICAL**
   - Problem: Using f-string to build SQL query allows SQL injection
   - Fix:
   ```python
   query = "SELECT * FROM users WHERE id = %s"
   result = conn.execute(query, (id,))
   ```

2. **Line 7 - Hardcoded credentials - CRITICAL**
   - Problem: Database password exposed in code
   - Fix:
   ```python
   import os
   db_url = os.environ.get('DATABASE_URL')
   conn = db.connect(db_url)
   ```

3. **Line 6-10 - No error handling - HIGH**
   - Problem: Will crash on invalid ID or DB error
   - Fix:
   ```python
   try:
       conn = db.connect(db_url)
       query = "SELECT * FROM users WHERE id = %s"
       result = conn.execute(query, (id,))
       user = result.fetchone()
       if not user:
           return jsonify({'error': 'User not found'}), 404
       return jsonify(user)
   except DatabaseError as e:
       logger.error(f"Database error: {e}")
       return jsonify({'error': 'Internal server error'}), 500
   finally:
       if conn:
           conn.close()
   ```

4. **Line 10 - Type conversion - MEDIUM**
   - Problem: `id` is string, but likely should be int
   - Fix: Add type validation
   ```python
   try:
       user_id = int(id)
   except ValueError:
       return jsonify({'error': 'Invalid user ID'}), 400
   ```
```

## Example 2: Screenshot Error Debug

**Scenario:** Application shows a TypeError when clicking submit button.

**Prompt used:**
```
Looking at this error screenshot:
1. Identify the error type and root cause
2. Explain why it's happening
3. Provide the exact fix with code
4. Suggest how to prevent similar errors
```

**Screenshot content:** (simulated)
```
TypeError: Cannot read property 'value' of null
  at handleSubmit (form.js:23)
  at HTMLFormElement.onclick (form.html:12)
```

**AI Output:** (example)
```
1. Error Type: Null Reference Error
   Root Cause: Trying to access .value on a null element

2. Why it's happening:
   - document.getElementById() is returning null
   - Element doesn't exist or ID is wrong
   - Script runs before DOM is loaded

3. Fix:

   **Before (form.js:23):**
   ```javascript
   function handleSubmit() {
       const email = document.getElementById('email').value;
       // ...
   }
   ```

   **After:**
   ```javascript
   function handleSubmit() {
       const emailEl = document.getElementById('email');
       if (!emailEl) {
           console.error('Email input not found');
           return;
       }
       const email = emailEl.value;
       // ...
   }
   ```

   **Or use defer in HTML:**
   ```html
   <script src="form.js" defer></script>
   ```

4. Prevention:
   - Always check if element exists before accessing properties
   - Use defer/async for scripts or place before </body>
   - Use optional chaining: document.getElementById('email')?.value
   - Add data validation in HTML: <input required id="email">
```

## Example 3: Generate Tests for Utility Function

**Scenario:** You wrote a date formatting utility and need comprehensive tests.

**Prompt used:**
```
Generate tests for this code:

**Test coverage:**
1. Happy path (expected inputs, typical use cases)
2. Edge cases (empty, null, zero, max values, boundaries)
3. Error cases (invalid inputs, malformed data)
4. Integration with dependencies (mocked)

**Format:**
- Use pytest framework
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Clear test names: test_[what]_[scenario]_[expected_result]
```

**Input code:**
```python
from datetime import datetime

def format_date(date_str: str, format: str = '%Y-%m-%d') -> str:
    """Format date string to specified format."""
    dt = datetime.strptime(date_str, '%Y-%m-%d')
    return dt.strftime(format)
```

**AI Output:** (example)
```python
import pytest
from datetime import datetime
from your_module import format_date

class TestFormatDate:
    # Happy path tests
    def test_format_date_with_default_format_returns_same_date(self):
        # Arrange
        date_str = '2024-01-15'

        # Act
        result = format_date(date_str)

        # Assert
        assert result == '2024-01-15'

    def test_format_date_with_custom_format_returns_formatted_date(self):
        # Arrange
        date_str = '2024-01-15'
        custom_format = '%d/%m/%Y'

        # Act
        result = format_date(date_str, custom_format)

        # Assert
        assert result == '15/01/2024'

    # Edge cases
    def test_format_date_with_leap_year_handles_feb_29(self):
        # Arrange
        date_str = '2024-02-29'

        # Act
        result = format_date(date_str)

        # Assert
        assert result == '2024-02-29'

    def test_format_date_with_year_boundary_handles_correctly(self):
        # Arrange
        date_str = '2023-12-31'
        custom_format = '%Y-%m-%d'

        # Act
        result = format_date(date_str, custom_format)

        # Assert
        assert result == '2023-12-31'

    # Error cases
    def test_format_date_with_invalid_date_raises_value_error(self):
        # Arrange
        invalid_date = '2024-13-01'  # Invalid month

        # Act & Assert
        with pytest.raises(ValueError):
            format_date(invalid_date)

    def test_format_date_with_wrong_input_format_raises_value_error(self):
        # Arrange
        wrong_format = '01/15/2024'  # Wrong format

        # Act & Assert
        with pytest.raises(ValueError):
            format_date(wrong_format)

    def test_format_date_with_empty_string_raises_value_error(self):
        # Arrange
        empty_date = ''

        # Act & Assert
        with pytest.raises(ValueError):
            format_date(empty_date)

    def test_format_date_with_none_raises_type_error(self):
        # Arrange
        none_date = None

        # Act & Assert
        with pytest.raises(TypeError):
            format_date(none_date)

    # Additional test for format validation
    def test_format_date_with_invalid_output_format_raises_value_error(self):
        # Arrange
        date_str = '2024-01-15'
        invalid_format = '%Z'  # Invalid format code

        # Act & Assert
        with pytest.raises(ValueError):
            format_date(date_str, invalid_format)
```

**Improvement suggestion from AI:**
```
Note: The current implementation could be improved:

1. Add input validation:
```python
def format_date(date_str: str | None, format: str = '%Y-%m-%d') -> str:
    if not date_str:
        raise ValueError("date_str cannot be empty or None")
    if not isinstance(date_str, str):
        raise TypeError(f"date_str must be str, got {type(date_str)}")

    try:
        dt = datetime.strptime(date_str, '%Y-%m-%d')
        return dt.strftime(format)
    except ValueError as e:
        raise ValueError(f"Invalid date format: {date_str}. Expected YYYY-MM-DD") from e
```
```

## Example 4: Refactor Complex Function

**Scenario:** A function does too much and is hard to test.

**Prompt used:**
```
Refactor this code to:
1. Extract functions for single responsibilities
2. Remove duplication
3. Improve naming (variables, functions, classes)
4. Add type hints/annotations
5. Simplify complex conditionals
6. Reduce nesting depth
7. Maintain identical behavior

Show before/after for each change with explanation.
```

**Input code:**
```python
def process_order(data):
    if data:
        if 'items' in data:
            total = 0
            for item in data['items']:
                if item['quantity'] > 0:
                    price = item['price']
                    qty = item['quantity']
                    if 'discount' in item:
                        price = price - (price * item['discount'])
                    total += price * qty
            if total > 100:
                total = total - (total * 0.1)
            if 'shipping' in data:
                total += data['shipping']
            return total
    return 0
```

**AI Output:** (example - showing refactored version)
```python
from typing import Dict, List, Optional

def calculate_item_price(item: Dict) -> float:
    """Calculate final price for a single item with discount."""
    base_price = item['price'] * item['quantity']
    discount = item.get('discount', 0)
    return base_price * (1 - discount)

def calculate_items_total(items: List[Dict]) -> float:
    """Calculate total price for all items."""
    valid_items = [item for item in items if item['quantity'] > 0]
    return sum(calculate_item_price(item) for item in valid_items)

def apply_bulk_discount(total: float, threshold: float = 100.0, discount: float = 0.1) -> float:
    """Apply bulk discount if total exceeds threshold."""
    if total > threshold:
        return total * (1 - discount)
    return total

def process_order(order_data: Optional[Dict]) -> float:
    """Process order and return final total with discounts and shipping."""
    if not order_data or 'items' not in order_data:
        return 0.0

    items_total = calculate_items_total(order_data['items'])
    discounted_total = apply_bulk_discount(items_total)
    shipping_cost = order_data.get('shipping', 0.0)

    return discounted_total + shipping_cost

# Improvements made:

# 1. Single Responsibility:
#    - calculate_item_price: handles individual item pricing
#    - calculate_items_total: handles items collection
#    - apply_bulk_discount: handles bulk discount logic
#    - process_order: orchestrates the flow

# 2. Removed Duplication:
#    - Price calculation logic extracted once
#    - Discount pattern consistent across functions

# 3. Better Naming:
#    - data → order_data (more specific)
#    - total → items_total, discounted_total (clearer intent)
#    - Functions describe what they do

# 4. Type Hints:
#    - All parameters and returns typed
#    - Used Optional for nullable values

# 5. Simplified Conditionals:
#    - Early return for invalid data
#    - Used .get() for optional fields
#    - List comprehension for filtering

# 6. Reduced Nesting:
#    - From 4 levels to max 1 level
#    - Early returns eliminate else blocks

# 7. Behavior Maintained:
#    - All edge cases handled identically
#    - Same calculation results
```

## Key Takeaways

1. **Be specific**: The more context you provide, the better the output
2. **Choose the right prompt**: Different scenarios need different prompts
3. **Iterate**: Use the output as a starting point, refine as needed
4. **Validate**: Always review AI-generated code before using
5. **Combine prompts**: Chain prompts for complex workflows (review → refactor → test)

## Prompt Chaining Example

For comprehensive code improvement:

```
Step 1: Code Review
  → Identify 4 issues

Step 2: Refactor Request
  → Fix all 4 issues

Step 3: Generate Tests
  → Create test suite for refactored code

Step 4: Add Documentation
  → Document the improved code

Result: Production-ready code in 4 prompts
```

## Common Patterns

| Task | Prompt Combination | Outcome |
|------|-------------------|---------|
| Fix bug in production | Error Screenshot Debug → Error Fix → Generate Tests | Bug fixed with regression prevention |
| Improve legacy code | Code Review → Refactor Request → Add Documentation | Maintainable code |
| Build new feature | Full Feature Implementation → Code Review → Generate Tests | Production-ready feature |
| Optimize slow endpoint | Performance Optimization → Code Review → Generate Tests | Fast, validated code |

---

These examples demonstrate how AGENTS_PROMPT.md templates save time and ensure consistent, high-quality output.
