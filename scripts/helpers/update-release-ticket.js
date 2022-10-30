const TrackerApiClient = require('../api/tracker-api-client');

const [changelog, releaseTag, author] = process.argv.slice(2);

console.log(`Changelog:\n${changelog}`);
console.log(`Release tag: ${releaseTag}`);
console.log(`Author: ${author}`);

const client = new TrackerApiClient();

const todayDate = new Date().toLocaleDateString();

const ticketData = {
  summary: `Релиз ${releaseTag || ''} - ${todayDate}`,
  description: [
    `Ответстсвенный за релиз: ${author || ''}`,
    '---',
    'Коммиты, попавшие в релиз:',
    changelog,
  ].join('\n'),
};

client.updateTicket(ticketData).catch(() => {
  process.exit(1);
});
