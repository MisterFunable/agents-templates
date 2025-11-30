#!/usr/bin/env python3
"""
git-stats: Display git repository statistics
"""

import argparse
import subprocess
import sys
from pathlib import Path
from typing import Optional
import json


def get_commit_count(repo_path: Path) -> int:
    """Get total number of commits in repository."""
    result = subprocess.run(
        ["git", "-C", str(repo_path), "rev-list", "--count", "HEAD"],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        raise RuntimeError("Not a git repository or git is not installed")
    
    return int(result.stdout.strip())


def get_author_count(repo_path: Path) -> int:
    """Get number of unique authors."""
    result = subprocess.run(
        ["git", "-C", str(repo_path), "log", "--format=%ae"],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        raise RuntimeError("Failed to get author information")
    
    authors = set(result.stdout.strip().split('\n'))
    return len(authors)


def get_branch_count(repo_path: Path) -> int:
    """Get number of branches."""
    result = subprocess.run(
        ["git", "-C", str(repo_path), "branch", "-a"],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        raise RuntimeError("Failed to get branch information")
    
    branches = [line.strip() for line in result.stdout.split('\n') if line.strip()]
    return len(branches)


def display_stats(stats: dict, output_format: str) -> None:
    """Display statistics in specified format."""
    if output_format == "json":
        print(json.dumps(stats, indent=2))
    else:
        # Human-readable text format
        print("Git Repository Statistics")
        print("=" * 40)
        print(f"Commits:  {stats['commits']}")
        print(f"Authors:  {stats['authors']}")
        print(f"Branches: {stats['branches']}")


def main():
    parser = argparse.ArgumentParser(
        description="Display git repository statistics",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  git-stats
  git-stats /path/to/repo
  git-stats --format json
        """
    )
    
    parser.add_argument(
        "path",
        nargs="?",
        default=".",
        help="path to git repository (default: current directory)"
    )
    
    parser.add_argument(
        "--format",
        choices=["text", "json"],
        default="text",
        help="output format (default: text)"
    )
    
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="enable verbose output"
    )
    
    args = parser.parse_args()
    
    # Validate repository path
    repo_path = Path(args.path).resolve()
    if not repo_path.exists():
        print(f"Error: Path '{args.path}' does not exist", file=sys.stderr)
        sys.exit(1)
    
    if not (repo_path / ".git").exists():
        print(f"Error: '{args.path}' is not a git repository", file=sys.stderr)
        sys.exit(1)
    
    try:
        if args.verbose:
            print(f"Analyzing repository: {repo_path}", file=sys.stderr)
        
        stats = {
            "commits": get_commit_count(repo_path),
            "authors": get_author_count(repo_path),
            "branches": get_branch_count(repo_path),
        }
        
        display_stats(stats, args.format)
        
    except RuntimeError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nInterrupted", file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        if args.verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()

