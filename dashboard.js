let token = localStorage.getItem('github_token');

if (!token) {
    token = prompt("Enter your GitHub Personal Access Token:");
    if (token) {
        localStorage.setItem('github_token', token);
    }
}

function sendCommand(eventType) {
    fetch(`https://api.github.com/repos/yourusername/zt-firewall-suite/dispatches `, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            event_type: eventType,
            client_payload: {}
        })
    }).then(res => {
        const log = document.getElementById('log');
        if (res.ok) {
            log.innerText += `[+] Sent command: ${eventType}\n`;
        } else {
            res.text().then(text => {
                log.innerText += `[!] Failed: ${eventType} → ${text}\n`;
            });
        }
    });
}