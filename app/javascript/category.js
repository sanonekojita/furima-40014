document.addEventListener('turbo:load', function () {
  const parentCategory = document.getElementById('parent-category');
  const selectWrap = document.getElementById('select-wrap');

  // 選択フォームを繰り返し表示する
  if (parentCategory && selectWrap) {
    const selectChildElement = (selectForm) => {
      const element = document.getElementById(selectForm);
      if (element !== null) {
        element.remove();
      }
    };

    const XHR = new XMLHttpRequest();
    const categoryXHR = (id) => {
      XHR.open("GET", `/category/${id}`, true);
      XHR.responseType = "json";
      XHR.send();
    };

    const getChildCategoryData = () => {
      const parentValue = parentCategory.value;
      categoryXHR(parentValue);

      XHR.onload = () => {
        const items = XHR.response.item;
        appendChildSelect(items);
        const childCategory = document.getElementById('child-select');

        childCategory.addEventListener('change', () => {
          selectChildElement('grand-child-select-wrap');
          getGrandchildCategoryData(childCategory);
        });
      };
    };

    const appendChildSelect = (items) => {
      const childWrap = document.createElement('div');
      const childSelect = document.createElement('select');

      childWrap.setAttribute('id', 'child-select-wrap');
      childSelect.setAttribute('id', 'child-select');

      const defaultOption = document.createElement('option');
      defaultOption.innerHTML = '---';
      defaultOption.setAttribute('value', '');

      childSelect.appendChild(defaultOption);

      items.forEach(item => {
        const childOption = document.createElement('option');
        childOption.innerHTML = item.name;
        childOption.setAttribute('value', item.id);
        childSelect.appendChild(childOption);
      });

      childSelect.addEventListener('change', () => {
        document.getElementById('child-category-id').value = childSelect.value;
        document.getElementById('grandchild-category-id').value = '';
      });

      childWrap.appendChild(childSelect);
      selectWrap.appendChild(childWrap);
    };

    const getGrandchildCategoryData = (grandchildCategory) => {
      const grandchildValue = grandchildCategory.value;
      categoryXHR(grandchildValue);

      XHR.onload = () => {
        const grandChildItems = XHR.response.item;
        appendGrandChildSelect(grandChildItems);
      };
    };

    const appendGrandChildSelect = (items) => {
      const childWrap = document.getElementById('child-select-wrap');
      const grandchildWrap = document.createElement('div');
      const grandchildSelect = document.createElement('select');

      grandchildWrap.setAttribute('id', 'grand-child-select-wrap');
      grandchildSelect.setAttribute('id', 'grand-child-select');

      const defaultOption = document.createElement('option');
      defaultOption.innerHTML = '---';
      defaultOption.setAttribute('value', '');

      grandchildSelect.appendChild(defaultOption);

      items.forEach(item => {
        const grandchildOption = document.createElement('option');
        grandchildOption.innerHTML = item.name;
        grandchildOption.setAttribute('value', item.id);
        grandchildSelect.appendChild(grandchildOption);
      });

      grandchildSelect.addEventListener('change', () => {
        document.getElementById('grandchild-category-id').value = grandchildSelect.value;
      });

      grandchildWrap.appendChild(grandchildSelect);
      childWrap.appendChild(grandchildWrap);
    };

    parentCategory.addEventListener('change', function () {
      selectChildElement('child-select-wrap');
      getChildCategoryData();
    });
  }
});