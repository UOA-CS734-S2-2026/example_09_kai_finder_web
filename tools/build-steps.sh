#!/usr/bin/env bash
# Rebuilds the step-NN-* tags from the current contents of main.
#
# Each step checks out the finished tree, removes the files that step has not
# introduced yet, swaps in the variants from tools/steps/, and commits. Run it
# after changing anything on main so the tags stay in sync.
#
#   ./tools/build-steps.sh
#
# Existing step tags are deleted and recreated. Nothing else is touched.
set -euo pipefail
cd "$(dirname "$0")/.."

FINAL="$(git rev-parse HEAD)"
git diff --quiet || { echo "Working tree is dirty. Commit or stash first."; exit 1; }

for t in $(git tag -l 'step-*'); do git tag -d "$t" >/dev/null; done
git checkout -q --orphan build-steps-tmp
git rm -rq --cached . >/dev/null

commit () { git add -A; git commit -qm "$2"; git tag "$1"; echo "  $1"; }
restore () { git checkout -q "$FINAL" -- .; }

echo "Building steps:"

# --- 1: a scaffolded app with the boilerplate removed ------------------------
restore
rm -rf src/features src/state src/hooks src/data .github
cp tools/steps/01-App.tsx src/App.tsx
cp tools/steps/01-styles.css src/styles.css
commit step-01-scaffold "Step 1: a Vite React app, boilerplate removed"

# --- 2: the first component --------------------------------------------------
restore
rm -rf src/features/post src/features/organiser src/state src/hooks \
       src/data/kai_api_service.ts src/data/kai_user.ts \
       src/data/event_repository.ts src/data/fake_event_repository.ts \
       src/features/feed/KaiEventList.tsx src/features/feed/RowCheckbox.tsx \
       src/features/feed/SelectionBar.tsx src/features/feed/FeedScreen.tsx \
       src/features/feed/FeedScreen.test.tsx .github
cp tools/steps/02-KaiEventCard.tsx src/features/feed/KaiEventCard.tsx
cp tools/steps/02-App.tsx src/App.tsx
commit step-02-card "Step 2: a component, props and JSX"

# --- 3: a list, and keys -----------------------------------------------------
restore
rm -rf src/features/post src/features/organiser src/state src/hooks \
       src/data/kai_api_service.ts src/data/kai_user.ts \
       src/features/feed/RowCheckbox.tsx src/features/feed/SelectionBar.tsx \
       src/features/feed/FeedScreen.tsx src/features/feed/FeedScreen.test.tsx .github
cp tools/steps/02-KaiEventCard.tsx src/features/feed/KaiEventCard.tsx
cp tools/steps/03-App.tsx src/App.tsx
commit step-03-list "Step 3: rendering a list, and what key is for"

# --- 4: shared state ---------------------------------------------------------
restore
rm -rf src/features/post src/features/organiser src/hooks \
       src/state/RepositoryContext.tsx src/state/OrganiserContext.tsx \
       src/data/kai_api_service.ts src/data/kai_user.ts \
       src/features/feed/FeedScreen.tsx src/features/feed/FeedScreen.test.tsx .github
cp tools/steps/04-App.tsx src/App.tsx
commit step-04-selection "Step 4: useState, Context and immutable updates"

# --- 5: fetching -------------------------------------------------------------
restore
rm -rf src/features/post src/features/organiser \
       src/state/OrganiserContext.tsx src/data/kai_user.ts \
       src/features/feed/FeedScreen.test.tsx .github
cp tools/steps/05-FeedScreen.tsx src/features/feed/FeedScreen.tsx
cp tools/steps/05-App.tsx src/App.tsx
commit step-05-fetch "Step 5: useEffect, dependencies and cleanup"

# --- 6: the four states ------------------------------------------------------
restore
rm -rf src/features/post src/features/organiser \
       src/state/OrganiserContext.tsx src/data/kai_user.ts .github
cp tools/steps/06-FeedScreen.tsx src/features/feed/FeedScreen.tsx
cp tools/steps/05-App.tsx src/App.tsx
commit step-06-states "Step 6: loading, error, empty and data"

# --- 7: writing through the API ----------------------------------------------
restore
rm -rf src/features/organiser src/state/OrganiserContext.tsx src/data/kai_user.ts .github
cp tools/steps/06-FeedScreen.tsx src/features/feed/FeedScreen.tsx
cp tools/steps/07-PostEventScreen.tsx src/features/post/PostEventScreen.tsx
cp tools/steps/07-App.tsx src/App.tsx
commit step-07-post "Step 7: posting an event through the API"

# --- 8: attribution ----------------------------------------------------------
restore
commit step-08-who-posted "Step 8: who posted it"

git checkout -q main
git branch -qD build-steps-tmp
echo "Done. ./demo.sh list to see them."
