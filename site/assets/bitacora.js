/* «Uso de IA»: lee la bitácora de prompts en vivo desde GitHub y la muestra con el diseño del sitio.
   La página no guarda copia: lo que se registre en BITACORA_PROMPTS.md (rama main) aparece al abrirla.
   El contenido del archivo se inserta siempre como texto, nunca como HTML. */
(function () {
  'use strict';
  var box = document.getElementById('bitacora');
  if (!box) return;

  var FASES = ['Análisis', 'Diseño', 'Implementación', 'Pruebas', 'Despliegue', 'Documentación', 'Planeación'];

  var el = function (tag, className, text) {
    var node = document.createElement(tag);
    if (className) node.className = className;
    if (text !== undefined) node.textContent = text;
    return node;
  };

  /* Separa el archivo en entradas «## P12», respetando los bloques de código. */
  var parse = function (markdown) {
    var entries = [];
    var entry = null;
    var field = null;
    var fenced = false;
    markdown.replace(/\r\n?/g, '\n').split('\n').forEach(function (line) {
      var fence = /^\s*```/.test(line);
      if (!fenced && !fence) {
        var heading = line.match(/^##\s+(.*?)\s*$/);
        if (heading) {
          var id = heading[1].match(/^P(\d+)\b/);
          entry = null;
          field = null;
          if (id) {
            entry = { number: Number(id[1]), id: 'P' + id[1], fields: [] };
            entries.push(entry);
          }
          return;
        }
        if (/^---+\s*$/.test(line)) {
          field = null;
          return;
        }
        var start = entry && line.match(/^[-*]\s+\*\*(.+?):?\*\*:?\s*(.*)$/);
        if (start) {
          field = { name: start[1].replace(/:$/, ''), lines: start[2] ? [start[2]] : [] };
          entry.fields.push(field);
          return;
        }
      }
      if (fence) fenced = !fenced;
      if (field) field.lines.push(line);
    });
    return entries;
  };

  var value = function (entry, pattern) {
    var found = entry.fields.filter(function (f) { return pattern.test(f.name); })[0];
    return found ? found.lines.join(' ').trim() : '';
  };

  var phasesOf = function (entry) {
    var text = value(entry, /^Fase/i).split('(')[0].toLowerCase();
    return FASES.filter(function (phase) { return text.indexOf(phase.toLowerCase()) !== -1; });
  };

  /* Formato dentro de una línea: **negrita**, `código` y enlaces https. */
  var inline = function (parent, text) {
    var pattern = /\*\*([^*]+)\*\*|`([^`]+)`|\[([^\]]+)\]\((https:\/\/[^)\s]+)\)/g;
    var last = 0;
    var match;
    while ((match = pattern.exec(text))) {
      parent.appendChild(document.createTextNode(text.slice(last, match.index)));
      if (match[1]) parent.appendChild(el('strong', '', match[1]));
      else if (match[2]) parent.appendChild(el('code', '', match[2]));
      else {
        var link = el('a', '', match[3]);
        link.href = match[4];
        link.target = '_blank';
        link.rel = 'noopener';
        parent.appendChild(link);
      }
      last = pattern.lastIndex;
    }
    parent.appendChild(document.createTextNode(text.slice(last)));
  };

  /* Párrafos, listas y bloques de código de un campo. */
  var blocks = function (parent, lines) {
    var paragraph = null;
    var list = null;
    var code = null;
    lines.forEach(function (line) {
      if (/^\s*```/.test(line)) {
        if (code) {
          var pre = el('pre');
          pre.appendChild(el('code', '', code.join('\n')));
          parent.appendChild(pre);
          code = null;
        } else {
          code = [];
        }
        paragraph = list = null;
        return;
      }
      if (code) {
        code.push(line);
        return;
      }
      var text = line.trim();
      if (!text) {
        paragraph = list = null;
        return;
      }
      var item = text.match(/^(?:[-*]|\d+[.)])\s+(.*)$/);
      if (item) {
        var ordered = /^\d/.test(text);
        if (!list || list.tagName !== (ordered ? 'OL' : 'UL')) {
          list = el(ordered ? 'ol' : 'ul');
          parent.appendChild(list);
        }
        var li = el('li');
        inline(li, item[1]);
        list.appendChild(li);
        paragraph = null;
        return;
      }
      if (!paragraph) {
        paragraph = el('p');
        parent.appendChild(paragraph);
        list = null;
      } else {
        paragraph.appendChild(document.createTextNode(' '));
      }
      inline(paragraph, text);
    });
    if (code) {
      var open = el('pre');
      open.appendChild(el('code', '', code.join('\n')));
      parent.appendChild(open);
    }
  };

  var card = function (entry) {
    var details = el('details', 'plegable prompt');
    details.id = entry.id.toLowerCase();
    var summary = el('summary');
    summary.appendChild(el('span', 'prompt-id', entry.id));
    var phases = phasesOf(entry);
    (phases.length ? phases : []).forEach(function (phase) { summary.appendChild(el('span', 'chip chip-fase', phase)); });
    var meta = [value(entry, /^Fecha/i), value(entry, /^Autor/i)].filter(Boolean).join(' · ');
    summary.appendChild(el('span', 'prompt-meta', meta));
    var technique = value(entry, /^Técnica/i);
    if (technique) summary.appendChild(el('span', 'prompt-tecnica', technique.replace(/[*`]/g, '')));
    details.appendChild(summary);
    var body = el('div', 'plegable-cuerpo');
    /* La fecha y el autor ya van en el encabezado de la tarjeta; los datos cortos van juntos. */
    var facts = el('div', 'prompt-datos');
    body.appendChild(facts);
    entry.fields.forEach(function (field) {
      if (/^(Fecha|Autor)$/i.test(field.name)) return;
      var parent = body;
      if (/^(Herramienta|Fase|Técnica)/i.test(field.name)) {
        parent = el('div');
        facts.appendChild(parent);
      }
      parent.appendChild(el('h4', '', field.name));
      blocks(parent, field.lines);
    });
    details.appendChild(body);
    details.dataset.autor = value(entry, /^Autor/i);
    details.dataset.fases = phases.join('|');
    details.dataset.texto = (entry.id + ' ' + entry.fields.map(function (f) { return f.lines.join(' '); }).join(' ')).toLowerCase();
    return details;
  };

  var select = function (label, options) {
    var node = el('select');
    node.setAttribute('aria-label', label);
    var all = el('option', '', label + ': todos');
    all.value = '';
    node.appendChild(all);
    options.forEach(function (option) {
      var item = el('option', '', option);
      item.value = option;
      node.appendChild(item);
    });
    return node;
  };

  var show = function (markdown) {
    var entries = parse(markdown).sort(function (a, b) { return b.number - a.number; });
    if (!entries.length) throw new Error('sin entradas');
    box.textContent = '';
    var authors = [];
    var phases = [];
    entries.forEach(function (entry) {
      var author = value(entry, /^Autor/i);
      if (author && author.charAt(0) !== '[' && authors.indexOf(author) === -1) authors.push(author);
      phasesOf(entry).forEach(function (phase) { if (phases.indexOf(phase) === -1) phases.push(phase); });
    });
    phases.sort(function (a, b) { return FASES.indexOf(a) - FASES.indexOf(b); });

    var tools = el('div', 'bitacora-filtros');
    var search = el('input');
    search.type = 'search';
    search.placeholder = 'Buscar en los prompts';
    search.setAttribute('aria-label', 'Buscar en los prompts');
    var byPhase = select('Fase', phases);
    var byAuthor = select('Autor', authors.sort());
    [search, byPhase, byAuthor].forEach(function (node) { tools.appendChild(node); });
    var count = el('p', 'bitacora-cuenta');
    count.setAttribute('role', 'status');
    var list = el('div', 'grupo');
    var cards = entries.map(card);
    cards.forEach(function (node) { list.appendChild(node); });
    var apply = function () {
      var term = search.value.trim().toLowerCase();
      var visible = 0;
      cards.forEach(function (node) {
        var ok = (!term || node.dataset.texto.indexOf(term) !== -1) &&
          (!byPhase.value || node.dataset.fases.split('|').indexOf(byPhase.value) !== -1) &&
          (!byAuthor.value || node.dataset.autor === byAuthor.value);
        node.hidden = !ok;
        if (ok) visible += 1;
      });
      count.textContent = visible === cards.length
        ? cards.length + (cards.length === 1 ? ' prompt registrado' : ' prompts registrados') + ', del más reciente al más antiguo'
        : visible + ' de ' + cards.length + ' prompts';
    };
    search.addEventListener('input', apply);
    byPhase.addEventListener('change', apply);
    byAuthor.addEventListener('change', apply);
    box.appendChild(tools);
    box.appendChild(count);
    box.appendChild(list);
    apply();
    var target = window.location.hash && document.getElementById(window.location.hash.slice(1));
    if (target && target.tagName === 'DETAILS') {
      target.open = true;
      target.scrollIntoView();
    }
    return entries.length;
  };

  var fail = function () {
    box.textContent = '';
    var message = el('p', 'bitacora-aviso', 'No fue posible cargar la bitácora en este momento. Puedes leerla directamente en GitHub con el botón de arriba.');
    box.appendChild(message);
  };

  var load = function () {
    return window.fetch(box.getAttribute('data-fuente'), { cache: 'no-cache' })
      .then(function (response) {
        if (!response.ok) throw new Error('HTTP ' + response.status);
        return response.text();
      })
      .then(show)
      .catch(fail);
  };

  window.FestaBitacora = { parse: parse, show: show, load: load };
  load();
})();
