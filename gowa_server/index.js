const { Client, LocalAuth } = require("whatsapp-web.js");
const qrcode = require("qrcode-terminal");
const express = require("express");
const cors = require("cors"); // <-- 1. IMPORT CORS

const app = express();
app.use(cors()); // <-- 2. AKTIFKAN CORS UNTUK SEMUA REQUEST
app.use(express.json());

const client = new Client({
  authStrategy: new LocalAuth(),
  puppeteer: {
    executablePath:
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-gpu",
      "--disable-extensions",
      "--disable-dev-shm-usage",
    ],
    timeout: 60000,
  },
});

client.on("qr", (qr) => {
  console.log(
    '\n👇 Silakan scan QR Code ini menggunakan WhatsApp "Pengirim/Bot" 👇',
  );
  qrcode.generate(qr, { small: true });
});

client.on("loading_screen", (percent, message) => {
  console.log(`⏳ SEDANG LOADING: ${percent}% - ${message}`);
});

client.on("authenticated", () => {
  console.log('🔑 Autentikasi berhasil! Tunggu sampai statusnya "Ready"...');
});

client.on("ready", () => {
  console.log("\n✅✅ MESIN WHATSAPP GATEWAY SIAP DIGUNAKAN! ✅✅\n");
});

client.on("auth_failure", (msg) => {
  console.error("❌ Autentikasi GAGAL:", msg);
});

client.on("disconnected", (reason) => {
  console.log("⚠️ WhatsApp Terputus:", reason);
});

client.initialize();

// --- ENDPOINT API GOWA ---
app.post("/send/text", async (req, res) => {
  try {
    const { msisdn, message } = req.body;

    if (!msisdn || !message) {
      return res.status(400).json({
        status: "error",
        message: "Parameter msisdn dan message wajib diisi!",
      });
    }

    const formattedNumber = `${msisdn}@c.us`;
    await client.sendMessage(formattedNumber, message);

    console.log(`Pesan terkirim ke: ${msisdn}`);
    res.status(200).json({
      status: "success",
      message: `Pesan berhasil dikirim ke ${msisdn}`,
    });
  } catch (error) {
    console.error("❌ Error saat mengirim pesan:", error);
    res.status(500).json({ status: "error", message: error.toString() });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server GoWA berjalan di http://localhost:${PORT}`);
});
