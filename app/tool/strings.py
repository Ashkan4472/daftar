#!/usr/bin/env python3
"""Single source for UI strings. Run: python3 tool/strings.py  (writes lib/l10n/app_{en,fa}.arb)
Entries: key: (en, fa) or (en, fa, {placeholder: type}). Placeholders not listed are String."""
import json, re, os

S = {}
exec(open(os.path.join(os.path.dirname(__file__), 'strings_data.py'), encoding='utf-8').read())

def arb(idx):
    out = {'@@locale': 'en' if idx == 0 else 'fa'}
    for k, v in S.items():
        out[k] = v[idx]
        if idx == 0:
            names = re.findall(r'\{(\w+)(?:,|\})', v[0])
            if names:
                types = v[2] if len(v) > 2 else {}
                out['@' + k] = {'placeholders': {n: {'type': types.get(n, 'String')} for n in dict.fromkeys(names)}}
    return out

for i, loc in enumerate(['en', 'fa']):
    path = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n', f'app_{loc}.arb')
    json.dump(arb(i), open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
print(len(S), 'strings')
