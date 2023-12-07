bring cloud;

let b = new cloud.Bucket();
let q = new cloud.Queue();

let api = new cloud.Api();

api.get("/", inflight () => {
  b.put("hello.txt", "world");
  q.push("new message");

  return { status: 200, body: "hello, barak" };
});

test "show me the url" {
  log(api.url);
}
