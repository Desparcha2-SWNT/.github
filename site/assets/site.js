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
    // Listas de rutas «Método | Ruta | …»: en celular van en tarjetas compactas.
    if (/^m[eé]todo$/i.test(titles[0]) && /^ruta$/i.test(titles[1] || '')) table.classList.add('rutas');
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

  // 4. Secciones plegables: se abren al llegar por un enlace y se pueden abrir o cerrar todas.
  var setHeaderHeight = function () {
    var fixed = header && window.getComputedStyle(header).position === 'sticky';
    document.documentElement.style.setProperty('--alto-encabezado', (fixed ? header.offsetHeight : 0) + 'px');
  };
  setHeaderHeight();
  window.addEventListener('resize', setHeaderHeight);
  window.addEventListener('load', setHeaderHeight);

  var openTarget = function () {
    var id = decodeURIComponent(window.location.hash.slice(1));
    var target = id && document.getElementById(id);
    var box = target && target.closest('details');
    if (box) {
      box.open = true;
      target.scrollIntoView();
    }
  };
  window.addEventListener('hashchange', openTarget);
  window.addEventListener('load', openTarget);
  document.addEventListener('click', function (event) {
    var link = event.target.closest('a[href^="#"]');
    if (link && link.getAttribute('href') === window.location.hash) openTarget();
  });

  document.querySelectorAll('main .grupo').forEach(function (group) {
    var boxes = group.querySelectorAll(':scope > details');
    if (boxes.length < 2) return;
    var bar = document.createElement('div');
    bar.className = 'herramientas';
    var button = document.createElement('button');
    button.type = 'button';
    var allOpen = function () {
      return Array.prototype.every.call(boxes, function (box) { return box.open; });
    };
    var label = function () {
      button.textContent = allOpen() ? 'Cerrar todo' : 'Abrir todo';
    };
    button.addEventListener('click', function () {
      var open = !allOpen();
      boxes.forEach(function (box) { box.open = open; });
      label();
    });
    boxes.forEach(function (box) { box.addEventListener('toggle', label); });
    label();
    bar.appendChild(button);
    group.parentNode.insertBefore(bar, group);
  });
})();
