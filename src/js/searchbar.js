
(function () {
    let users = [];
    let debounceTimeout;
    let keyboardIndex = -1;

    const input = document.getElementById('searchInput');
    const listWrap = document.getElementById('userList');
    const closeIcon = document.querySelector('.search-close');

    fetch('/services/GetHierarchy.ashx')
        .then(r => { if (!r.ok) throw new Error('Network error'); return r.json(); })
        .then(data => { users = Array.isArray(data) ? data : []; })
        .catch(err => console.log('Fetch error:', err.message));

    input.addEventListener('input', function (e) {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => {
            const searchTerm = e.target.value.trim().toLowerCase();
            if (!searchTerm) {
                hideList();
                return;
            }
            const filtered = users
                .filter(u => (u.Account || '').toLowerCase().includes(searchTerm) || (u.Name || '').toLowerCase().includes(searchTerm))
                .slice(0, 50);

            displayUsers(filtered);
            if (filtered.length) showList(); else hideList();
            keyboardIndex = -1;
        }, 220);
    });

    if (closeIcon) {
        closeIcon.addEventListener('click', () => {
            input.value = '';
            hideList();
            input.focus();
        });
    }

    document.addEventListener('click', function (ev) {
        if (!listWrap.contains(ev.target) && ev.target !== input) {
            hideList();
        }
    });

    input.addEventListener('keydown', function (e) {
        const ul = listWrap.querySelector('ul');
        if (!ul || listWrap.style.display === 'none') return;

        const items = Array.from(ul.querySelectorAll('li'));
        if (!items.length) return;

        if (e.key === 'ArrowDown') {
            e.preventDefault();
            keyboardIndex = (keyboardIndex + 1) % items.length;
            setActive(items, keyboardIndex);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            keyboardIndex = (keyboardIndex - 1 + items.length) % items.length;
            setActive(items, keyboardIndex);
        } else if (e.key === 'Enter') {
            e.preventDefault();
            if (keyboardIndex >= 0) items[keyboardIndex].click();
        } else if (e.key === 'Escape') {
            hideList();
        }
    });

    function setActive(items, index) {
        items.forEach(li => li.classList.remove('active'));
        const li = items[index];
        if (li) {
            li.classList.add('active');
            li.scrollIntoView({ block: 'nearest' });
        }
    }

    function showList() { listWrap.style.display = 'block'; }
    function hideList() { listWrap.style.display = 'none'; listWrap.innerHTML = ''; }

    function displayUsers(arr) {
        listWrap.innerHTML = '';
        const ul = document.createElement('ul');

        arr.forEach(user => {
            const li = document.createElement('li');

            const pill = document.createElement('span');
            pill.className = 'pill ' + getTypeClass(user.Type);
            pill.textContent = (user.Type || '').toUpperCase();

            const main = document.createElement('span');
            main.innerHTML = `<span class="acc">${escapeHtml(user.Account || '')}</span>
                        <span class="muted"> (${escapeHtml(user.password || '')}) </span>
                        <span class="name">${escapeHtml(user.Name || '')}</span>`;

            li.addEventListener('click', function () {
                handleGo(user);
            });

            pill.addEventListener('click', function (ev) {
                ev.stopPropagation();
                if (user.Type === 'A' || user.Type === 'M') {
                    updateSession(user.Id).then(() => {
                        window.location.href = `/Report/WeeklyBalancesEnhanced.aspx?idAgent=${user.Id}`;
                    });
                } else if (user.Type === 'P') {
                    window.location.href = `/Report/PlayerPayment.aspx?player=${user.Id}`;
                }
            });

            li.appendChild(pill);
            li.appendChild(main);
            ul.appendChild(li);
        });

        listWrap.appendChild(ul);
    }

    function getTypeClass(t) {
        switch (t) {
            case 'P': return 'type-p';
            case 'A': return 'type-a';
            case 'M': return 'type-m';
            case 'D': return 'type-d';
            default: return '';
        }
    }

    function handleGo(user) {
        if (user.Type === 'P') {
            window.location.href = `/Report/PlayerEditEnhanced.aspx?player=${user.Id}`;
        } else if (user.Type === 'D') {
            updateSession(user.Id).then(() => location.reload());
        } else {
            // A o M
            window.location.href = `/Report/ManageSubAgent.aspx?idAgent=${user.Id}`;
        }
    }

    function escapeHtml(str) {
        return String(str).replace(/[&<>"']/g, s => ({
            '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;'
        }[s]));
    }

    function updateSession(id) {
        try { if (window.$ && $('.preloader').length) $('.preloader').show(); } catch (_) { }
        return fetch('/services/ChangeSubAgent.ashx', {
            method: 'POST',
            body: new URLSearchParams({ id }),
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
            .then(r => r.json())
            .then(data => {
                if (data !== "success") {
                    console.error('Failed to update session. Server responded with:', data);
                }
                return data;
            })
            .catch(err => console.error('Error:', err))
            .finally(() => {
                try { if (window.$ && $('.preloader').length) $('.preloader').hide(); } catch (_) { }
            });
    }
})();