echo "$TAG_PATTERN"
echo "$GITHUB_REF_NAME"
echo "$GITHUB_ACTOR"

CHANGELOG=$(git log --pretty=format:"%h %cn: %s")
echo "$CHANGELOG"


CURRENT_VERSION=$GITHUB_REF_NAME
PREV_VERSION=$(git tag | sort -V | grep $TAG_PATTERN | grep -B 1 $CURRENT_VERSION | head -1)
echo "$PREV_VERSION"
