"""
Data processor for CSV to JSON conversion with validation.
"""

import json
import csv
from pathlib import Path
from typing import Optional
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def process_csv(input_file: str, output_file: Optional[str] = None) -> dict[str, any]:
    """
    Convert CSV file to JSON with validation.
    
    Args:
        input_file: Path to input CSV file
        output_file: Optional path to output JSON file
    
    Returns:
        Dictionary with processed data and statistics
    """
    input_path = Path(input_file)
    
    if not input_path.exists():
        raise FileNotFoundError(f"Input file '{input_file}' not found")
    
    if not input_path.suffix == '.csv':
        raise ValueError("Input file must be a CSV file")
    
    logger.info(f"Processing {input_file}")
    
    data = []
    with input_path.open('r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            data.append(row)
    
    result = {
        'data': data,
        'count': len(data),
        'source': str(input_path)
    }
    
    if output_file:
        output_path = Path(output_file)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        with output_path.open('w') as f:
            json.dump(result, f, indent=2)
        
        logger.info(f"Saved output to {output_file}")
    
    return result


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python data_processor.py input.csv [output.json]")
        sys.exit(2)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    try:
        result = process_csv(input_file, output_file)
        print(f"Processed {result['count']} records")
    except Exception as e:
        logger.error(f"Processing failed: {e}", exc_info=True)
        sys.exit(1)

