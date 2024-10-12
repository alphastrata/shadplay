import asyncio
import re
import time
import argparse
from collections import defaultdict
from aiohttp import ClientSession
from pathlib import Path
from typing import List, Set, Tuple

# ANSI color codes
RESET = "\033[0m"
GREEN = "\033[32m"
RED = "\033[31m"
ORANGE = "\033[33m"
WHITE = "\033[37m"

# User-Agent to mimic a browser
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.5790.102 Safari/537.36"
HEADERS = {"User-Agent": USER_AGENT}

# Simple URL Regex to capture valid URLs only
URL_REGEX = r'https?://[^\s\'"<>]+'

# Dictionary to store results
results = defaultdict(list)

# Set to track tested URLs
tested_urls: Set[str] = set()

# Counters for performance
good_links = 0
bad_links = 0

async def fetch(url: str, session: ClientSession, filename: str, line_number: int) -> None:
    global good_links, bad_links
    try:
        async with session.get(url, timeout=10) as response:
            status = response.status
            # Treat 403 as valid (so it's "good")
            if status == 200:
                color = GREEN
                good_links += 1
            elif status == 403:
                color = GREEN  # 403 is OK for us
                good_links += 1
            else:
                color = RED
                bad_links += 1
            results[filename].append((url, status, color, line_number))
    except Exception as e:
        results[filename].append((url, f"Error: {str(e)}", RED, line_number))
        bad_links += 1

async def check_urls_in_file(filename: str, urls_with_lines: List[Tuple[str, int]], session: ClientSession) -> None:
    tasks = []
    for url, line_number in urls_with_lines:
        if url not in tested_urls:
            tested_urls.add(url)  # Add URL to the set to avoid re-testing
            tasks.append(fetch(url, session, filename, line_number))
    await asyncio.gather(*tasks)

async def process_files(files: List[str]) -> None:
    async with ClientSession(headers=HEADERS) as session:
        tasks = []
        for file in files:
            urls_with_lines = extract_urls_from_file(file)
            if urls_with_lines:
                tasks.append(check_urls_in_file(file, urls_with_lines, session))
        await asyncio.gather(*tasks)

def extract_urls_from_file(filepath: str) -> List[Tuple[str, int]]:
    """Extract all URLs and their line numbers from the given file."""
    urls_with_lines = []
    with open(filepath, "r", encoding="utf-8") as file:
        for line_number, line in enumerate(file, 1):
            urls_in_line = re.findall(URL_REGEX, line)
            for url in urls_in_line:
                urls_with_lines.append((url, line_number))
    return urls_with_lines

def collect_files(extensions: List[str]) -> List[str]:
    """Collect files with the given extensions from the current directory."""
    files = []
    for ext in extensions:
        files.extend(Path(".").rglob(f"*.{ext}"))
    return [str(file) for file in files]

def print_results(verbose: bool, errors_only: bool) -> None:
    """Print results in a tree-like structure based on verbosity level."""
    for filename, url_statuses in results.items():
        for url, status, color, line_number in url_statuses:
            if errors_only and status == 200:
                continue  # Skip successful links when printing errors-only

            if verbose or (errors_only and status != 200):
                print(f"\n{ORANGE}{filename}:{line_number}{RESET}")
                print(f"  {color}{status}{RESET} {WHITE}{url}{RESET}")

def parse_arguments() -> argparse.Namespace:
    """Parse command-line arguments for verbosity control."""
    parser = argparse.ArgumentParser(description="Check URLs in project files.")
    parser.add_argument(
        "--verbose", action="store_true", help="Print all URLs and their statuses (success and error)"
    )
    parser.add_argument(
        "--errors-only", action="store_true", help="Print only error URLs"
    )
    parser.add_argument(
        "--silent", action="store_true", help="Print nothing, exit 0 for no bad links, 1 otherwise"
    )
    return parser.parse_args()

def main() -> None:
    args = parse_arguments()

    # Start performance counter
    start_time = time.perf_counter()

    # Specify file extensions to search for
    extensions = ["rs", "wgsl", "md", "txt", "toml", "py", "sh"]
    files = collect_files(extensions)

    # Run asyncio event loop
    asyncio.run(process_files(files))

    # Print results based on verbosity level
    if not args.silent:
        print_results(args.verbose, args.errors_only)

    # End performance counter
    end_time = time.perf_counter()
    total_time = end_time - start_time

    # If in silent mode, exit with code 0 if no bad links, or 1 if bad links exist
    if args.silent:
        exit(0 if bad_links == 0 else 1)

    # Summary
    print(f"\nSummary: {good_links} good links, {bad_links} bad links.")
    print(f"Total time: {total_time:.2f} seconds.")

if __name__ == "__main__":
    main()
