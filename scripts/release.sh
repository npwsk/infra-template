# global variables from release-ci workflow

echo "Release tag: $GITHUB_REF_NAME"
echo "Release initiator: $GITHUB_ACTOR"
echo "Release tags pattern: $TAG_PATTERN"

# prepare changelog

CURRENT_TAG=$GITHUB_REF_NAME

PREV_TAG=$(git tag |
  sort -V |
  grep "$TAG_PATTERN" |
  grep -B 1 "$CURRENT_TAG" |
  grep -v "$CURRENT_TAG")

echo "Previous release tag: $PREV_TAG"

if [ "$PREV_TAG" = "" ]; then
  CHANGELOG=$(git log --pretty=format:"%h %cn: %s" $CURRENT_TAG)
else
  CHANGELOG=$(git log --pretty=format:"%h %cn: %s" $CURRENT_TAG...$PREV_TAG)
fi

echo -e "Release changelog:\n$CHANGELOG"

# fill release ticket

node ./update-release-ticket.js $CHANGELOG $GITHUB_REF_NAME $GITHUB_ACTOR

if [ "$?" != 0 ]; then
  echo "Failed to fill release ticket"
  exit 1
fi

# build docker image

echo "Release script finished"
