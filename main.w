bring cloud;

new cloud.Bucket();
new cloud.Queue();

let api = new cloud.Api();

api.get("/", inflight () => {
  return { status: 200, body: "hello, world" };
});
