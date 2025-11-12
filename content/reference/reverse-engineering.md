---
title: Reverse engineering
---

## SQLite grep

```sh
# Adapted after: https://stackoverflow.com/a/53875499 and https://stackoverflow.com/a/29548123
NEEDLE="mitmproxy|begin certificate|MIIDoTCCAomg|IVCc6egf0T"

find / -name '*.db' -o -name '*.sqlite*' -print0 2>/dev/null | while IFS= read -r -d '' file; do
    for X in $(sqlite3 -readonly "$file" .tables 2>/dev/null); do
        sqlite3 -readonly "$file" "SELECT * FROM \"$X\";" 2>/dev/null | grep -iE >/dev/null $NEEDLE && echo "Found in file '$file', table '$X'";
    done
done
```

## System-wide grep on specific file types

```sh
NEEDLE="mitmproxy|begin certificate|MIIDoTCCAomg|IVCc6egf0T"

FILES=$(find / -name "*.plist")

while IFS= read -r file; do
  if grep -iEq "$NEEDLE" "$file"; then
    echo "$file"
  fi
done <<< "$FILES"
```
