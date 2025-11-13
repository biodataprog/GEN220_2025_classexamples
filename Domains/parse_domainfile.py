#!/usr/bin/env python3

import os
import re

def parse_domainfile(filepath):
    """
    Parses a domain file and extracts domain names.

    Args:
        filepath (str): The path to the domain file.
    Returns:
        list: A list of domain names extracted from the file.
    """
    if not os.path.isfile(filepath):
        raise FileNotFoundError(f"The file {filepath} does not exist.")

    domains = {}
    with open(filepath, 'r') as file:
        for line in file:
            if line.startswith('#'):
                continue
            line = line.strip()
            row = line.split()
            domain_name = row[0]
            if domain_name not in domains:
                domains[domain_name] = 1
            else:
                domains[domain_name] += 1
    return domains

if __name__ == "__main__":
    import sys
    import argparse
    import csv
    if len(sys.argv) < 2:
        print("Usage: python parse_domainfile.py <domainfile> > table.tsv")
        sys.exit(1)

    all_domains = {}
    for domainfile in sys.argv[1:]:
        # this function gives me back domains counted
        # keys are the domains (eg Kinase, AAA, etc),
        # value is count of number of times domain show up
        domain_counts = parse_domainfile(domainfile)
        for domain in domain_counts:
            # print(f'domain {domain} found {domain_counts[domain]} times in {domainfile}')
            if domain not in all_domains:
                all_domains[domain] = { domainfile: domain_counts[domain] }    
            else:
                all_domains[domain][domainfile] = domain_counts[domain]
    csvout = csv.writer(sys.stdout, delimiter='\t')
    csvout.writerow(["Domain"] + sys.argv[1:])
    for domain in sorted(all_domains):
        row = [domain]
        for domainfile in sys.argv[1:]:
            row.append(all_domains[domain].get(domainfile, 0))
        csvout.writerow(row)