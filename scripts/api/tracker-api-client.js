const axios = require('axios');

const { OAUTH_TOKEN, ORG_ID, ISSUE_ID } = process.env;

class TrackerApiClient {
  baseUrl = `https://api.tracker.yandex.net/v2/issues/${ISSUE_ID}`;

  #authRequestHeaders = {
    Authorization: `OAuth ${OAUTH_TOKEN}`,
    'X-Org-ID': ORG_ID,
  };

  #contentTypeHeader = {
    'Content-Type': 'application/json',
  };

  async updateTicket({ summary, description }) {
    const url = this.baseUrl;

    const ticketData = {
      summary,
      description,
    };

    console.log(`Send PATCH request to ${url} with body:\n${JSON.stringify(ticketData)}`);

    const headers = { ...this.#authRequestHeaders, ...this.#contentTypeHeader };

    return axios
      .patch(url, JSON.stringify(ticketData), { headers })
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

  async addComment(text) {
    const url = `${this.baseUrl}/comments`;
    const body = { text };

    console.log(`Send POST request to ${url} with body:\n${JSON.stringify(body)}`);

    const headers = { ...this.#authRequestHeaders, ...this.#contentTypeHeader };

    return axios
      .post(url, JSON.stringify(body), { headers })
      .then(({ data }) => {
        console.log(`Request succeded`);
        console.log(`Comment id: ${data.id}`);
        console.log(`Comment text:\n${data.text}`);
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
