#!/bin/zsh
# Publish Sustainability Watch to https://sustainability.thewishingstream.com
# First run creates the public repo otterstew/sustainability-watch and turns on
# GitHub Pages; later runs just copy the latest page across and push.
set -e
cd "${0:A:h}"
cp ~/Documents/open-brain/sustainability.html index.html
git add -A
git diff --cached --quiet || git commit -q -m "Update Sustainability Watch page"
if ! gh repo view otterstew/sustainability-watch >/dev/null 2>&1; then
  gh repo create otterstew/sustainability-watch --public --source . --push \
    --description "Sustainability Watch: environmental regulation digest and carbon case studies"
  gh api -X POST repos/otterstew/sustainability-watch/pages -f 'source[branch]=main' -f 'source[path]=/' >/dev/null
  gh api -X PUT repos/otterstew/sustainability-watch/pages -f cname=sustainability.thewishingstream.com >/dev/null
  echo "Repo created and Pages switched on."
else
  git push -q
  echo "Pushed."
fi
echo "Site: https://sustainability.thewishingstream.com"
