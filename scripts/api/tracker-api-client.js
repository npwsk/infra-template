const axios = require('axios');

const { OAUTH_TOKEN, ORG_ID, ISSUE_ID } = process.env;

class TrackerApiClient {
  baseUrl = `https://api.tracker.yandex.net/v2/issues/${ISSUE_ID}`;

  #authRequestHeaders = {
    Authorization: `OAuth ${OAUTH_TOKEN}`,
    'X-Org-ID': ORG_ID,
  };

  async updateTicket({ summary, description }) {
    const ticketData = {
      summary,
      description,
    };

    console.log(`Send PATCH request to ${this.baseUrl} with body:\n${JSON.stringify(ticketData)}`);

    const headers = { ...this.#authRequestHeaders, 'Content-Type': 'application/json' };

    return axios
      .patch(this.baseUrl, JSON.stringify(ticketData), { headers })
      .then(({ data }) => {
        console.log(`Request succeded`);
        console.log(`New summary: ${data.summary}`);
        console.log(`New description:\n${data.description}`);
      })
      .catch((error) => {
        const message = error.response
          ? `Request failed with status: ${error.response.status}`
          : `Error sending request: ${error.message}`;
        console.log(message);
        throw new Error(message);
      });
  }
}

module.exports = TrackerApiClient;
