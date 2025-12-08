# References

This directory contains git submodules of open-source projects used as reference material throughout the course.

## Projects

| Project | Directory | Description |
|---------|-----------|-------------|
| Cal.com | `cal.com/` | Scheduling app with monorepo UI package |
| Supabase | `supabase/` | Database platform with two-tier UI system |

## Setup

To initialize all reference projects:

```bash
./setup.sh
```

Or initialize individually:

```bash
git submodule update --init references/cal.com
git submodule update --init references/supabase
```

## Pinned Versions

Each submodule is pinned to a specific commit for reproducibility. The setup script ensures the correct version is checked out.

| Project | Commit |
|---------|--------|
| Cal.com | `1182460d5c0733d126e77528daeb6fabc5d3ecc5` |
| Supabase | `0399beba0e8ddcf4bf63b66d9fd16dc4a53a5c81` |
