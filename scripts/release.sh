# env variables from release-ci workflow

echo "Release tag: $GITHUB_REF_NAME"
echo "Release initiator: $GITHUB_ACTOR"
echo "Release tags pattern: $TAG_PATTERN"

# install dependencies

echo 'Install dependencies'
npm ci

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

# update release ticket

echo "Update release ticket"

node ./scripts/helpers/update-release-ticket.js "$CHANGELOG" "$GITHUB_REF_NAME" "$GITHUB_ACTOR"

if [ "$?" != 0 ]; then
  echo "Failed to update release ticket"
  exit 1
fi

# build docker image

echo "Build Docker image"

DOCKER_IMAGE_NAME="release-image:$CURRENT_TAG"

docker build -t "$DOCKER_IMAGE_NAME" .

if [ "$?" != 0 ]; then
  echo "Failed to build docker image"
  exit 1
fi

echo "Created Docker image: $DOCKER_IMAGE_NAME"

# add comment to release ticket

echo "Add comment to release ticket"

node ./scripts/helpers/add-ticket-comment.js "$CURRENT_TAG"

if [ "$?" != 0 ]; then
  echo "Failed to add comment"
  exit 1
fi

echo "Release script finished"
