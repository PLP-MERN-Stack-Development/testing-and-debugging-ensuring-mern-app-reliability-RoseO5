import mockingoose from "mockingoose";
import Post from "../../src/models/Post.js";

describe("Post model test (mocked)", () => {
  it("should return a mocked post", async () => {
    mockingoose(Post).toReturn({ title: "Test Post", content: "Hello" }, "findOne");
    const post = await Post.findOne({ title: "Test Post" });
    expect(post.title).toBe("Test Post");
    expect(post.content).toBe("Hello");
  });
});
