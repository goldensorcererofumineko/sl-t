// 例: シンプルカレンダーの日付をクリックした際のJavaScript
document.addEventListener("DOMContentLoaded", () => {
  const dateCells = document.querySelectorAll(".calendar-container .calendar-cell");

  dateCells.forEach((cell) => {
    cell.addEventListener("click", (event) => {
      // クリックされた日付の取得
      const clickedDate = event.currentTarget.dataset.date;

      // 日付に関連するデータフォームへのリダイレクト
      window.location.href = `<%= sleep_ms_detail_path(date: clickedDate) %>`;
    });
  });
});
