const TrackerApiClient = require('../api/tracker-api-client');

const [tag] = process.argv.slice(2);

console.log(`Image tag: ${tag}`);

const client = new TrackerApiClient();

client.addComment(`Собран образ с тегом ${tag}`).catch(() => process.exit(1));
