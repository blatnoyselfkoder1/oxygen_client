const express = require('express');
const app = express();
app.use(express.json());

// Хранилище: { "никнейм": время_пинга }
const onlineUsers = new Map();

// Регистрация онлайна (мод шлет сюда)
app.post('/api/heartbeat', (req, res) => {
    const { username } = req.body;
    if (username) {
        onlineUsers.set(username, Date.now());
        res.json({ success: true });
    } else {
        res.status(400).json({ error: "No username" });
    }
});

// Получение списка (мод шлет сюда)
app.get('/api/users', (req, res) => {
    const now = Date.now();
    // Удаляем тех, кто не пинговался дольше 3 минут (180 сек)
    for (let [name, time] of onlineUsers) {
        if (now - time > 180000) onlineUsers.delete(name);
    }
    res.json({ success: true, users: Array.from(onlineUsers.keys()) });
});

// Запуск сервера на порту, который выдаст Railway
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server started on port ${port}`));
