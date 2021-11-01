# TheGauntlet
This is a basic SRE/DevOps challenge.

It is not meant to be difficult or take alot of time. The main purpose is to see how the you handle the given task and is intentionally open-ended in a number of ways to allow us to see your thought processes and methodologies. These results will be used in the interview as the basis for further questions.

**Scenario:**

Create a simple webserver and scrape its metrics using Prometheus. Configure Grafana to display a single graph for the webserver.

***Requirements***

- Using `docker` and `docker-compose`, create multiple containers running Linux.
- Create a simple web application using the language/framework of your choice. The server should respond to a single endpoint `/ping` and return the json response `{"message": "pong"}`.
- Implement Prometheus metrics for the web application with the metric `http_requests_total`.
- Set up Prometheus to scrape the web application.
- Set up Grafana using Prometheus as the data source.
- Create a graph in Grafana displaying the scraped metric from the web application.
- Create a pull request with your changes and tag @highlycaffeinated when you're ready for the team to review 
