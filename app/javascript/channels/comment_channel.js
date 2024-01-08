import consumer from "./consumer"

if(location.pathname.match(/\/items\/\d/)){

  consumer.subscriptions.create({
    channel: "CommentChannel",
    item_id: location.pathname.match(/\d+/)[0]
  }, {

    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const html = `
        <div class="comment">
          <p class="user-comment-name">${data.user.nickname}： </p>
          <p class="user-comment">${data.comment.text}</p>
          <p class="space">${data.comment.created_at}</p>
        </div>`
      const comments = document.getElementById("comments")
      comments.insertAdjacentHTML('beforeend', html)
      const commentForm = document.getElementById("comment-form")
      commentForm.reset();
    }
  })
}
