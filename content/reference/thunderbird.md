---
title: Thunderbird
---

## OpenPGP

### Encrypt using key without user ID matching the recipient email address

Thunderbird normally requires that a recipient’s public key contains a user ID with a matching email address. This can be overridden by using OpenPGP recipient alias rules. ([1](https://support.mozilla.org/en-US/kb/thunderbird-help-openpgp-alias), [2](https://support.mozilla.org/en-US/kb/openpgp-recipient-alias-configuration))

In the profile directory (*Help* -> *Troubleshooting Information* -> *Profile Directory*), create a file called `openpgp_alias_to_keys.json`. In `about:config` (*Edit* -> *Settings* -> *General -> *Config Editor* (at the very bottom)), create a preference `mail.openpgp.alias_rules_file` and set it to `openpgp_alias_to_keys.json`. Fill the file like this (descriptions are optional):

```json
{
  "rules": [
    {
      "domain": "domain1.example.com",
      "keys": [
        {
          "description": "Catch-all for domain1.example.com",
          "fingerprint": "EB85BB5FA33A75E15E944E63F231550C4F47E38E"
        }
      ]
    },
    {
      "email": "list@domain1.example.com",
      "keys": [
        {
          "description": "John",
          "fingerprint": "D1A66E1A23B182C9980F788CFBFCC82A015E7330"
        },
        {
          "description": "Eve",
          "id": "F231550C4F47E38E"
        }
      ]
    }
  ]
}

```

Restarting Thunderbird is not necessary but you do need to reopen the message window.
