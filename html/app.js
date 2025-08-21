(() => {
  const app = document.getElementById('app');
  const title = document.getElementById('locationTitle');
  const grid = document.getElementById('vehicles');
  const closeBtn = document.getElementById('closeBtn');

  function post(name, data = {}) {
    fetch(`https://${GetParentResourceName()}/${name}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data)
    });
  }

  function render(state) {
    title.textContent = state.locationLabel || 'Rentals';
    grid.innerHTML = '';
    (state.vehicles || []).forEach(v => {
      const card = document.createElement('div');
      card.className = 'card';

      const media = document.createElement('div');
      media.className = 'car-media';
      const img = document.createElement('img');
      const placeholder = document.getElementById('placeholderIcon').cloneNode(true);
      placeholder.removeAttribute('id');
      placeholder.classList.add('ph');

      // Updated image loading system - prioritize FiveM docs
      const trySources = [];
      if (v.image) trySources.push(v.image);
      if (v.model) {
        // Primary: FiveM docs with .webp extension
        trySources.push(`https://docs.fivem.net/vehicles/${v.model}.webp`);
        // Fallback: FiveM docs with .jpg extension
        trySources.push(`https://docs.fivem.net/vehicles/${v.model}.jpg`);
        // Legacy fallback: ESX vehicleshop
        trySources.push(`https://raw.githubusercontent.com/esx-framework/esx-vehicleshop/master/html/img/${v.model}.png`);
      }

      let loaded = false;
      let idx = 0;
      function loadNext() {
        if (idx >= trySources.length) {
          media.appendChild(placeholder);
          return;
        }
        const src = trySources[idx++];
        img.src = src;
      }
      img.onload = () => {
        loaded = true;
        media.innerHTML = '';
        media.appendChild(img);
      };
      img.onerror = () => {
        if (!loaded) loadNext();
      };
      loadNext();
      media.appendChild(placeholder);
      card.appendChild(media);

      const name = document.createElement('div');
      name.className = 'car-name';
      name.textContent = v.label;
      card.appendChild(name);

      const price = document.createElement('div');
      price.className = 'car-price';
      price.textContent = `$${v.price}`;
      card.appendChild(price);

      const actions = document.createElement('div');
      actions.className = 'car-actions';
      const rentBtn = document.createElement('button');
      rentBtn.className = 'btn btn-primary';
      
      // Check if player already has an active rental
      if (state.hasActiveRental) {
        rentBtn.textContent = 'Вече имате наета кола';
        rentBtn.disabled = true;
        rentBtn.style.opacity = '0.5';
        rentBtn.style.cursor = 'not-allowed';
      } else {
        rentBtn.textContent = 'Наеми';
        rentBtn.onclick = () => post('rentals:rent', {
          locationIndex: state.locationIndex,
          model: v.model,
          price: v.price,
          label: v.label
        });
      }
      
      actions.appendChild(rentBtn);
      card.appendChild(actions);

      grid.appendChild(card);
    });

    app.classList.remove('hidden');
  }

  window.addEventListener('message', (e) => {
    const msg = e.data;
    if (!msg || !msg.action) return;
    if (msg.action === 'open') {
      render(msg);
    } else if (msg.action === 'close') {
      app.classList.add('hidden');
    }
  });

  closeBtn.addEventListener('click', () => post('rentals:close'));
})();
