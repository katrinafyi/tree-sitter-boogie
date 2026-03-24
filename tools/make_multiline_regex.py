#!/usr/bin/env python3

import sys

# comment body that terminates at the next instance of `*/`
non_nested_comment_body = r'(?:[^*]|[*]+[^*/])*[*]+[/]'

string_without_comment_delimiter = \
    r'(?:[^*/]|[*]+[^*/]|[/]+[^/*])*'

def nested_comment_body(nestings: int) -> str:
    if nestings == 0:
        return non_nested_comment_body
    return rf'(?:{string_without_comment_delimiter}|[/]+[*]{nested_comment_body(nestings-1)})*[*]+[/]'

print('[/][*]' + nested_comment_body(int(sys.argv[1])))
