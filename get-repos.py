#!/usr/bin/env python3

import urllib.request as urllib2    # for downloading the webpage
from bs4 import BeautifulSoup       # for parsing the HTML
import re                           # for regular expressions
import json
import sys

args = [x.lower() for x in sys.argv[1:]]

url = "https://gap-packages.github.io/index.html"
html = urllib2.urlopen(url)
page = BeautifulSoup(html, "html.parser")
anchors = page.find_all("a")

# Regex pattern for repositories
# * Accommodate possible http versus https; possible trailing /)
# * Catch organisation and repository name as groups
pattern = re.compile("https?://[^/]+/([^/]*)/([^/]*)/?")

# TODO: Populate a list of packages to remove, perhaps dynamically
avoid = ["homepage", "itc"]

repos = []
for anchor in anchors:
    match = pattern.match(anchor.get("href"))
    pkg_name = anchor.get_text()
    if match \
            and (not args or pkg_name.lower() in args) \
            and not pkg_name.lower() in avoid \
            and not "gap-packages.github.io" in pkg_name.lower():
        repos.append(
            {
                "package": anchor.get_text(), \
                "repo_url": match.group(0)
            }
        )

matrix = {"include": sorted(repos, key=lambda r: r["package"].lower())}
print(json.dumps(matrix))
