bring cloud;

let b = new cloud.Bucket();

let api = new cloud.Api();

api.get("/", inflight () => {
  b.put("hello.txt", "world");
  return { status: 200, body: "hello, gang" };
});
