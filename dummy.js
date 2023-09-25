const PORT = 3001;
const http = require("http");
const process = require("process");

process.on("SIGINT", () => {
  console.info("Interrupted");
  process.exit(0);
});

http
  .createServer(function (_req, res) {
    res.writeHead(200, {
      "Content-Type": "html",
    });
    res.end("It works");
  })
  .listen(PORT);

console.info(`Listening on ${PORT}`);
