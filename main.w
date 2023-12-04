bring cloud;

let bucket = new cloud.Bucket();

let api = new cloud.Api();

api.get("/files", inflight () => {
  return {
    status: 200,
    body: Json.stringify({
      files: bucket.list()
    })
  };
});

api.put("/files/:name", inflight (req) => {
  let name = req.vars.get("name");
  let body = req.body ?? "";
  bucket.put(name, body);
  return { status: 200 };
});

api.get("/files/:name", inflight (req) => {
  let name = req.vars.get("name");
  return {
    status: 200,
    body: bucket.get(name)
  };
});
