echo "$TAG_PATTERN"
echo "$GITHUB_REF_NAME"
echo "$GITHUB_ACTOR"
CHANGELOG=$(git log --pretty=format:"%h %cn: %s")
echo "$CHANGELOG"
