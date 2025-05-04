document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById("message_content");

  if (input) {
    input.addEventListener("keydown", function(e) {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault(); // 改行を防ぐ
        this.form.requestSubmit(); // フォームを送信
      }
    });
  }
});
