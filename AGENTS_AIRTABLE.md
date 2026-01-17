# AGENTS_AIRTABLE.md

Instructions for AI models building Airtable automations and utilities with Python.

## Project Structure

Standard Airtable automation project layout:

```
airtable-automation/
├── README.md
├── requirements.txt
├── .env.example
├── .gitignore
├── src/
│   ├── __init__.py
│   ├── client.py              # Airtable API client wrapper
│   ├── config.py              # Configuration and env loading
│   ├── models.py              # Record models and schemas
│   ├── operations/            # CRUD and batch operations
│   │   ├── __init__.py
│   │   ├── create.py
│   │   ├── read.py
│   │   ├── update.py
│   │   └── delete.py
│   ├── automations/           # Automation scripts
│   │   ├── __init__.py
│   │   ├── sync_records.py
│   │   └── cleanup_old.py
│   └── utils/                 # Shared utilities
│       ├── __init__.py
│       ├── rate_limiter.py
│       └── transformers.py
├── scripts/                   # CLI entry points
│   ├── run_sync.py
│   └── run_cleanup.py
└── tests/
    ├── conftest.py
    └── test_operations.py
```

## Configuration

**Environment variables:**

```bash
# .env.example
AIRTABLE_API_KEY=pat...              # Personal access token (recommended)
AIRTABLE_BASE_ID=app...              # Base ID from URL
AIRTABLE_TABLE_NAME=Table Name       # Table name or ID
AIRTABLE_VIEW_NAME=Grid view         # Optional: specific view
```

**Configuration module:**

```python
# src/config.py
import os
from dataclasses import dataclass

@dataclass
class AirtableConfig:
    api_key: str
    base_id: str
    table_name: str
    view_name: str | None = None

    @classmethod
    def from_env(cls) -> "AirtableConfig":
        api_key = os.environ.get("AIRTABLE_API_KEY")
        if not api_key:
            raise ValueError("AIRTABLE_API_KEY environment variable required")

        return cls(
            api_key=api_key,
            base_id=os.environ["AIRTABLE_BASE_ID"],
            table_name=os.environ["AIRTABLE_TABLE_NAME"],
            view_name=os.environ.get("AIRTABLE_VIEW_NAME"),
        )
```

**Loading config:**

```python
from dotenv import load_dotenv
from src.config import AirtableConfig

load_dotenv()
config = AirtableConfig.from_env()
```

## Airtable Client

**Use pyairtable library:**

```python
# src/client.py
from pyairtable import Api, Table
from src.config import AirtableConfig

class AirtableClient:
    def __init__(self, config: AirtableConfig):
        self.api = Api(config.api_key)
        self.table = self.api.table(config.base_id, config.table_name)
        self.config = config

    def get_all_records(self, formula: str | None = None) -> list[dict]:
        """Fetch all records with automatic pagination."""
        params = {}
        if self.config.view_name:
            params["view"] = self.config.view_name
        if formula:
            params["formula"] = formula

        return self.table.all(**params)

    def get_record(self, record_id: str) -> dict:
        """Fetch single record by ID."""
        return self.table.get(record_id)

    def create_record(self, fields: dict) -> dict:
        """Create single record."""
        return self.table.create(fields)

    def update_record(self, record_id: str, fields: dict) -> dict:
        """Update single record."""
        return self.table.update(record_id, fields)

    def delete_record(self, record_id: str) -> dict:
        """Delete single record."""
        return self.table.delete(record_id)
```

**Direct table access (simpler scripts):**

```python
from pyairtable import Api

api = Api(os.environ["AIRTABLE_API_KEY"])
table = api.table("appXXXXXXXXXXXXXX", "Table Name")

# Fetch all records
records = table.all()

# Fetch with filter formula
active = table.all(formula="{Status} = 'Active'")

# Fetch specific fields only
partial = table.all(fields=["Name", "Email", "Status"])
```

## Record Models

**Define record schemas with Pydantic:**

```python
# src/models.py
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class ContactFields(BaseModel):
    """Fields for Contact table records."""
    name: str = Field(alias="Name")
    email: str = Field(alias="Email")
    company: Optional[str] = Field(default=None, alias="Company")
    status: str = Field(default="New", alias="Status")
    created_date: Optional[datetime] = Field(default=None, alias="Created Date")

    class Config:
        populate_by_name = True

class ContactRecord(BaseModel):
    """Full Airtable record with metadata."""
    id: str
    created_time: datetime = Field(alias="createdTime")
    fields: ContactFields

    @classmethod
    def from_airtable(cls, record: dict) -> "ContactRecord":
        return cls(
            id=record["id"],
            createdTime=record["createdTime"],
            fields=ContactFields(**record["fields"]),
        )
```

**Using models:**

```python
# Fetch and parse records
raw_records = client.get_all_records()
contacts = [ContactRecord.from_airtable(r) for r in raw_records]

# Access typed fields
for contact in contacts:
    print(f"{contact.fields.name}: {contact.fields.email}")

# Create record from model
new_contact = ContactFields(name="John Doe", email="john@example.com")
client.create_record(new_contact.model_dump(by_alias=True, exclude_none=True))
```

## Batch Operations

**Batch create (up to 10 records per request):**

```python
# src/operations/create.py
from pyairtable import Table

def batch_create(table: Table, records: list[dict], batch_size: int = 10) -> list[dict]:
    """Create records in batches of 10 (Airtable limit)."""
    created = []
    for i in range(0, len(records), batch_size):
        batch = records[i:i + batch_size]
        results = table.batch_create(batch)
        created.extend(results)
    return created

# Usage
new_records = [
    {"Name": "Alice", "Email": "alice@example.com"},
    {"Name": "Bob", "Email": "bob@example.com"},
    # ... more records
]
created = batch_create(table, new_records)
print(f"Created {len(created)} records")
```

**Batch update:**

```python
# src/operations/update.py
def batch_update(table: Table, updates: list[dict], batch_size: int = 10) -> list[dict]:
    """Update records in batches. Each update needs 'id' and 'fields'."""
    updated = []
    for i in range(0, len(updates), batch_size):
        batch = updates[i:i + batch_size]
        results = table.batch_update(batch)
        updated.extend(results)
    return updated

# Usage
updates = [
    {"id": "recXXXXXXXXXXXXXX", "fields": {"Status": "Contacted"}},
    {"id": "recYYYYYYYYYYYYYY", "fields": {"Status": "Contacted"}},
]
updated = batch_update(table, updates)
```

**Batch delete:**

```python
# src/operations/delete.py
def batch_delete(table: Table, record_ids: list[str], batch_size: int = 10) -> list[dict]:
    """Delete records in batches."""
    deleted = []
    for i in range(0, len(record_ids), batch_size):
        batch = record_ids[i:i + batch_size]
        results = table.batch_delete(batch)
        deleted.extend(results)
    return deleted

# Usage
old_record_ids = ["recXXXXXX", "recYYYYYY", "recZZZZZZ"]
deleted = batch_delete(table, old_record_ids)
```

## Rate Limiting

Airtable limits: **5 requests per second per base**.

**Rate limiter utility:**

```python
# src/utils/rate_limiter.py
import time
from collections import deque
from threading import Lock

class RateLimiter:
    """Enforce Airtable's 5 requests/second limit."""

    def __init__(self, max_requests: int = 5, window_seconds: float = 1.0):
        self.max_requests = max_requests
        self.window = window_seconds
        self.timestamps: deque = deque()
        self.lock = Lock()

    def acquire(self):
        """Block until a request slot is available."""
        with self.lock:
            now = time.time()

            # Remove timestamps outside the window
            while self.timestamps and self.timestamps[0] < now - self.window:
                self.timestamps.popleft()

            # Wait if at capacity
            if len(self.timestamps) >= self.max_requests:
                sleep_time = self.timestamps[0] - (now - self.window)
                if sleep_time > 0:
                    time.sleep(sleep_time)

            self.timestamps.append(time.time())

# Global rate limiter
rate_limiter = RateLimiter()

def rate_limited_request(func):
    """Decorator to rate limit Airtable requests."""
    def wrapper(*args, **kwargs):
        rate_limiter.acquire()
        return func(*args, **kwargs)
    return wrapper
```

**Using pyairtable's built-in retry:**

```python
from pyairtable import Api, retry_strategy
from requests import Session
from urllib3 import Retry

# Configure retry for rate limits (429 errors)
retry = Retry(
    total=5,
    backoff_factor=0.5,
    status_forcelist=[429, 500, 502, 503, 504],
)

api = Api(api_key, timeout=(5, 30))  # Connect timeout, read timeout
```

## Formula Queries

**Common filter formulas:**

```python
# Exact match
formula = "{Status} = 'Active'"

# Multiple conditions (AND)
formula = "AND({Status} = 'Active', {Priority} = 'High')"

# Multiple conditions (OR)
formula = "OR({Status} = 'New', {Status} = 'Pending')"

# Contains text
formula = "FIND('gmail', {Email}) > 0"

# Date comparisons
formula = "IS_AFTER({Created Date}, '2024-01-01')"
formula = "IS_SAME({Due Date}, TODAY(), 'day')"

# Empty/not empty
formula = "{Email} = BLANK()"
formula = "{Email} != BLANK()"

# Linked record check
formula = "COUNTA({Projects}) > 0"
```

**Building formulas safely:**

```python
# src/utils/formulas.py
def escape_value(value: str) -> str:
    """Escape single quotes in formula values."""
    return value.replace("'", "\\'")

def field_equals(field: str, value: str) -> str:
    """Build safe equality formula."""
    return f"{{{field}}} = '{escape_value(value)}'"

def field_in(field: str, values: list[str]) -> str:
    """Build OR formula for multiple values."""
    conditions = [field_equals(field, v) for v in values]
    return f"OR({', '.join(conditions)})"

# Usage
formula = field_equals("Status", "In Progress")
formula = field_in("Category", ["Sales", "Marketing", "Support"])
```

## Common Automations

**Sync from external source:**

```python
# src/automations/sync_records.py
import logging
from src.client import AirtableClient
from src.config import AirtableConfig

logger = logging.getLogger(__name__)

def sync_from_source(client: AirtableClient, source_data: list[dict], key_field: str = "Email"):
    """Sync external data to Airtable. Creates new, updates existing."""

    # Get existing records
    existing = client.get_all_records()
    existing_by_key = {r["fields"].get(key_field): r for r in existing}

    to_create = []
    to_update = []

    for item in source_data:
        key = item.get(key_field)
        if key in existing_by_key:
            record = existing_by_key[key]
            # Check if update needed
            if needs_update(record["fields"], item):
                to_update.append({"id": record["id"], "fields": item})
        else:
            to_create.append(item)

    # Execute batch operations
    if to_create:
        created = client.table.batch_create(to_create)
        logger.info(f"Created {len(created)} new records")

    if to_update:
        updated = client.table.batch_update(to_update)
        logger.info(f"Updated {len(updated)} records")

    return {"created": len(to_create), "updated": len(to_update)}

def needs_update(existing: dict, new: dict) -> bool:
    """Check if record fields differ from new data."""
    for key, value in new.items():
        if existing.get(key) != value:
            return True
    return False
```

**Cleanup old records:**

```python
# src/automations/cleanup_old.py
from datetime import datetime, timedelta
from src.client import AirtableClient

def cleanup_old_records(
    client: AirtableClient,
    days_old: int = 90,
    date_field: str = "Created Date",
    status_field: str = "Status",
    status_value: str = "Archived",
    dry_run: bool = True,
) -> dict:
    """Delete or archive records older than specified days."""

    cutoff = datetime.now() - timedelta(days=days_old)
    formula = f"IS_BEFORE({{{date_field}}}, '{cutoff.strftime('%Y-%m-%d')}')"

    old_records = client.get_all_records(formula=formula)

    if dry_run:
        return {"would_process": len(old_records), "dry_run": True}

    # Archive instead of delete (safer)
    updates = [
        {"id": r["id"], "fields": {status_field: status_value}}
        for r in old_records
    ]

    if updates:
        client.table.batch_update(updates)

    return {"archived": len(updates), "dry_run": False}
```

**Duplicate detection:**

```python
# src/automations/deduplicate.py
from collections import defaultdict
from src.client import AirtableClient

def find_duplicates(client: AirtableClient, key_fields: list[str]) -> dict[str, list[str]]:
    """Find duplicate records based on key fields."""
    records = client.get_all_records()

    # Group by key
    groups = defaultdict(list)
    for record in records:
        key = tuple(record["fields"].get(f) for f in key_fields)
        groups[key].append(record["id"])

    # Return only duplicates
    duplicates = {
        str(k): ids for k, ids in groups.items()
        if len(ids) > 1
    }

    return duplicates

def merge_duplicates(
    client: AirtableClient,
    duplicate_ids: list[str],
    keep: str = "first",  # "first", "last", or specific record ID
) -> dict:
    """Merge duplicate records, keeping one and deleting others."""
    if len(duplicate_ids) < 2:
        return {"merged": 0}

    if keep == "first":
        to_keep = duplicate_ids[0]
        to_delete = duplicate_ids[1:]
    elif keep == "last":
        to_keep = duplicate_ids[-1]
        to_delete = duplicate_ids[:-1]
    else:
        to_keep = keep
        to_delete = [id for id in duplicate_ids if id != keep]

    # Delete duplicates
    client.table.batch_delete(to_delete)

    return {"kept": to_keep, "deleted": len(to_delete)}
```

**Scheduled data export:**

```python
# src/automations/export_csv.py
import csv
from pathlib import Path
from datetime import datetime
from src.client import AirtableClient

def export_to_csv(
    client: AirtableClient,
    output_dir: Path,
    fields: list[str] | None = None,
    formula: str | None = None,
) -> Path:
    """Export Airtable records to CSV file."""

    records = client.get_all_records(formula=formula)

    if not records:
        raise ValueError("No records to export")

    # Determine fields from first record if not specified
    if fields is None:
        fields = list(records[0]["fields"].keys())

    # Generate filename with timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = output_dir / f"export_{timestamp}.csv"

    output_dir.mkdir(parents=True, exist_ok=True)

    with open(filename, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id"] + fields)
        writer.writeheader()

        for record in records:
            row = {"id": record["id"]}
            row.update({f: record["fields"].get(f, "") for f in fields})
            writer.writerow(row)

    return filename
```

## Linked Records

**Working with linked records:**

```python
# Linked records return as list of record IDs
record = table.get("recXXXXXX")
linked_ids = record["fields"].get("Related Projects", [])  # ["recAAAA", "recBBBB"]

# Fetch linked records
projects_table = api.table(base_id, "Projects")
linked_records = [projects_table.get(id) for id in linked_ids]

# Create with linked records
new_task = {
    "Name": "New Task",
    "Project": ["recAAAAAAAAAAAAA"],  # Link to existing project
}
table.create(new_task)

# Update linked records (replaces all links)
table.update("recXXXXXX", {
    "Project": ["recAAAA", "recBBBB"],  # New set of linked records
})
```

**Expand linked records in query:**

```python
# Fetch records with expanded linked fields (returns full records, not just IDs)
# Note: pyairtable doesn't directly support this, use raw API
import requests

def get_with_linked(table, formula=None, linked_fields=None):
    """Fetch records with linked record data expanded."""
    url = f"https://api.airtable.com/v0/{base_id}/{table_name}"
    headers = {"Authorization": f"Bearer {api_key}"}
    params = {}

    if formula:
        params["filterByFormula"] = formula

    # Request linked record expansion
    if linked_fields:
        params["returnFieldsByFieldId"] = "true"

    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()
    return response.json()["records"]
```

## Attachments

**Working with attachment fields:**

```python
# Attachment structure
attachment = {
    "url": "https://example.com/image.jpg",
    "filename": "image.jpg",
}

# Create record with attachment URL (Airtable will download)
table.create({
    "Name": "Document",
    "Files": [{"url": "https://example.com/file.pdf"}],
})

# Read attachment data
record = table.get("recXXXXXX")
attachments = record["fields"].get("Files", [])
for att in attachments:
    print(f"File: {att['filename']}")
    print(f"URL: {att['url']}")  # Temporary signed URL
    print(f"Type: {att.get('type')}")
    print(f"Size: {att.get('size')}")
```

**Download attachments:**

```python
import requests
from pathlib import Path

def download_attachments(record: dict, field: str, output_dir: Path) -> list[Path]:
    """Download all attachments from a field."""
    attachments = record["fields"].get(field, [])
    downloaded = []

    output_dir.mkdir(parents=True, exist_ok=True)

    for att in attachments:
        response = requests.get(att["url"])
        response.raise_for_status()

        filepath = output_dir / att["filename"]
        filepath.write_bytes(response.content)
        downloaded.append(filepath)

    return downloaded
```

## Error Handling

**Handle common Airtable errors:**

```python
from pyairtable.api.types import AirtableError
import logging

logger = logging.getLogger(__name__)

def safe_create(table, fields: dict) -> dict | None:
    """Create record with error handling."""
    try:
        return table.create(fields)
    except AirtableError as e:
        if e.status_code == 422:
            logger.error(f"Validation error: {e.error_message}")
            # Field doesn't exist or wrong type
        elif e.status_code == 429:
            logger.warning("Rate limited, will retry...")
            raise  # Let retry logic handle it
        elif e.status_code == 404:
            logger.error(f"Table or base not found: {e.error_message}")
        else:
            logger.error(f"Airtable error {e.status_code}: {e.error_message}")
        return None

def validate_before_create(table, records: list[dict]) -> tuple[list[dict], list[dict]]:
    """Validate records before batch create."""
    valid = []
    invalid = []

    # Get table schema to check field names
    schema = table.schema()
    field_names = {f.name for f in schema.fields}

    for record in records:
        unknown_fields = set(record.keys()) - field_names
        if unknown_fields:
            invalid.append({
                "record": record,
                "error": f"Unknown fields: {unknown_fields}",
            })
        else:
            valid.append(record)

    return valid, invalid
```

## CLI Entry Points

**Script with argument parsing:**

```python
# scripts/run_sync.py
#!/usr/bin/env python3
import argparse
import logging
from dotenv import load_dotenv
from src.client import AirtableClient
from src.config import AirtableConfig
from src.automations.sync_records import sync_from_source

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

def main():
    parser = argparse.ArgumentParser(description="Sync data to Airtable")
    parser.add_argument("--source", required=True, help="Path to source JSON file")
    parser.add_argument("--key-field", default="Email", help="Field to match on")
    parser.add_argument("--dry-run", action="store_true", help="Preview changes only")
    parser.add_argument("-v", "--verbose", action="store_true")
    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    load_dotenv()
    config = AirtableConfig.from_env()
    client = AirtableClient(config)

    # Load source data
    import json
    with open(args.source) as f:
        source_data = json.load(f)

    if args.dry_run:
        print(f"Would sync {len(source_data)} records")
        return

    result = sync_from_source(client, source_data, args.key_field)
    print(f"Created: {result['created']}, Updated: {result['updated']}")

if __name__ == "__main__":
    main()
```

## Testing

**Test fixtures:**

```python
# tests/conftest.py
import pytest
from unittest.mock import MagicMock

@pytest.fixture
def mock_table():
    """Mock Airtable table for testing."""
    table = MagicMock()
    table.all.return_value = [
        {"id": "rec1", "fields": {"Name": "Alice", "Email": "alice@test.com"}},
        {"id": "rec2", "fields": {"Name": "Bob", "Email": "bob@test.com"}},
    ]
    return table

@pytest.fixture
def sample_records():
    return [
        {"Name": "Test User 1", "Email": "test1@example.com"},
        {"Name": "Test User 2", "Email": "test2@example.com"},
    ]
```

**Test operations:**

```python
# tests/test_operations.py
from src.operations.create import batch_create

def test_batch_create_chunks_correctly(mock_table, sample_records):
    # Create 15 records to test batching
    records = sample_records * 8  # 16 records

    mock_table.batch_create.return_value = [{"id": f"rec{i}"} for i in range(10)]

    result = batch_create(mock_table, records)

    # Should be called twice (10 + 6)
    assert mock_table.batch_create.call_count == 2

def test_batch_create_handles_empty_list(mock_table):
    result = batch_create(mock_table, [])
    assert result == []
    mock_table.batch_create.assert_not_called()
```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Fetch all records repeatedly | Cache results, use formulas to filter |
| Update records one at a time | Use batch_update (up to 10 per request) |
| Ignore rate limits | Implement rate limiting (5 req/sec) |
| Hardcode base/table IDs | Use environment variables |
| Store API key in code | Use .env file, never commit |
| Create records without validation | Validate fields against schema first |
| Ignore pagination | Use table.all() which handles pagination |
| Delete without confirmation | Use dry-run flag, archive instead of delete |
| Fetch all fields when few needed | Specify fields parameter to reduce payload |
| Build formulas with string concat | Use helper functions to escape values |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Library | pyairtable |
| Auth | Personal access token (PAT) in env var |
| Rate limit | 5 requests/second per base |
| Batch size | 10 records per create/update/delete |
| Config | dataclass with from_env() method |
| Models | Pydantic for record validation |
| Formulas | Helper functions for safe escaping |
| Error handling | Catch AirtableError, log details |
| CLI scripts | argparse with --dry-run flag |
| Testing | Mock table responses |

## When Building Airtable Automations

1. Set up .env with API key and base/table IDs
2. Create client wrapper class for reusability
3. Define Pydantic models for record schemas
4. Implement batch operations (10 records max)
5. Add rate limiting for bulk operations
6. Use formulas to filter server-side
7. Always include --dry-run option for destructive operations
8. Handle linked records as lists of IDs
9. Validate records before batch create/update
10. Log operations with record counts

## See Also

- AGENTS_PYTHON.md for Python code patterns
- AGENTS_CLI.md for CLI script structure
- AGENTS_COMMON.md for error handling and logging patterns
