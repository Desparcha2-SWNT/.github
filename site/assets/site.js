/* Mejoras para pantallas chicas. Sin este script el sitio se sigue leyendo: el menú se ve completo
   y las tablas anchas se desplazan dentro de su caja. */
(function () {
  'use strict';
  document.documentElement.classList.add('js');

  // 1. Menú plegable en celular.
  var header = document.querySelector('.top');
  var nav = header && header.querySelector('nav');
  if (nav) {
    nav.id = nav.id || 'menu';
    var button = document.createElement('button');
    button.type = 'button';
    button.className = 'menu-boton';
    button.setAttribute('aria-controls', nav.id);
    var setOpen = function (open) {
      header.classList.toggle('abierto', open);
      button.setAttribute('aria-expanded', String(open));
      button.innerHTML = '<span aria-hidden="true">' + (open ? '✕' : '☰') + '</span> Menú';
    };
    setOpen(false);
    button.addEventListener('click', function () {
      setOpen(!header.classList.contains('abierto'));
    });
    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape' && header.classList.contains('abierto')) {
        setOpen(false);
        button.focus();
      }
    });
    nav.addEventListener('click', function (event) {
      if (event.target.closest('a')) setOpen(false);
    });
    header.insertBefore(button, nav);
  }

  // 2. Tablas: cada celda recuerda el título de su columna para poder apilarse en celular.
  document.querySelectorAll('main table').forEach(function (table) {
    var titles = Array.prototype.map.call(table.querySelectorAll('thead th'), function (th) {
      return th.textContent.trim();
    });
    if (!titles.length) return;
    // Las fichas «Campo | Descripción» usan la primera celda como título de la fila.
    var isRecord = titles.length === 2 && /^campo$/i.test(titles[0]);
    table.classList.add('apilable');
    if (isRecord) table.classList.add('ficha');
    table.querySelectorAll('tbody tr').forEach(function (row) {
      Array.prototype.forEach.call(row.children, function (cell, index) {
        cell.setAttribute('data-titulo', titles[index] || '');
      });
    });
  });

  // 3. Diagramas: tocar para abrir la imagen completa y ampliarla.
  document.querySelectorAll('main img').forEach(function (img) {
    var src = img.getAttribute('src') || '';
    if (!/assets\/(diagramas|casos-de-uso|clases|datos|componentes)\//.test(src) || img.closest('a')) return;
    var link = document.createElement('a');
    link.className = 'ampliar';
    link.href = src;
    link.target = '_blank';
    link.rel = 'noopener';
    link.setAttribute('aria-label', 'Ampliar: ' + (img.alt || 'diagrama'));
    img.parentNode.insertBefore(link, img);
    link.appendChild(img);
    var hint = document.createElement('span');
    hint.className = 'ampliar-nota';
    hint.textContent = 'Ampliar';
    link.appendChild(hint);
  });
})();
