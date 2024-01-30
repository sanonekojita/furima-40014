document.addEventListener('DOMContentLoaded', function() {
  const tagInput = document.getElementById('item_tag_list');

  if (tagInput) {
    tagInput.addEventListener('input', function() {
      const query = tagInput.value;
      
      if (query.length >= 1) {  // 1文字以上で検索
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '/items/tag_search?q=' + query, true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.responseType = 'json';

        xhr.onload = function() {
          const searchResult = document.getElementById('tag-search-result');
          searchResult.innerHTML = '';

          if (xhr.status === 200) {
            const data = xhr.response;
            if (data.tags) {
              data.tags.forEach(function(tag) {
                const tagElement = document.createElement('div');
                tagElement.className = 'tag-result';
                tagElement.textContent = tag;
                searchResult.appendChild(tagElement);

                tagElement.addEventListener('click', function() {
                  tagInput.value = tag;
                  searchResult.innerHTML = '';
                });
              });
            }
          }
        };

        xhr.send();
      } else {
        // 入力が2文字未満の場合、結果をクリア
        document.getElementById('tag-search-result').innerHTML = '';
      }
    });
  }
});