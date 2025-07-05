# 💸 Pc2Money

**Turn your old PC into money — even if you're not tech-savvy.**

Pc2Money is a simple, no-nonsense tool designed to help **technophobic users** figure out what their computer is worth. It extracts the **essential hardware details** of your PC and saves them in a clear `.txt` file. You can then use this file to get pricing suggestions from ChatGPT — or even generate a full Facebook Marketplace listing in Hebrew using the included prompt.

---

## ✨ Features

- 🧠 No tech knowledge needed
- 🖥️ Auto-detects key PC specs (CPU, RAM, Storage, GPU)
- 📄 Generates a simple plain text report
- 💬 Bonus: AI-optimized prompt for crafting your secondhand listing
- 🇮🇱 Two versions: one for USD pricing, one for Israeli Shekel

---

## 📂 Project Structure

```
pc2dollar
├── pc2dollar.EXE # English version (USD)
├── pc2dollar.ps1 # PowerShell script source
├── pc2dollar.SED # IExpress configuration
├── pc2shekel.EXE # Hebrew/ILS version
├── pc2shekel.ps1 # PowerShell script source
└── pc2shekel.SED # IExpress configuration
```

---

## ⚙️ Installation

> No installation required!

1. Download the `Pc2Money` folder or just one of the `.EXE` files:

   - `pc2dollar.EXE` - for English/US-based sellers
   - `pc2shekel.EXE` - for Hebrew/Israeli sellers

2. **(Optional)** You may need to temporarily disable your antivirus to allow the `.exe` to run.  
   _(You can inspect the source in the `.ps1` file for transparency.)_

---

## 🚀 Usage

1. Run either `pc2dollar.EXE` or `pc2shekel.EXE`
2. Choose where to save the output `.txt` file
3. Open the file and review your computer's specs

> ⚠️ Note: The script cannot detect how long you’ve used your PC or what for - you’ll need to add this info manually to get an accurate resale price.

---

## 🧠 AI-Powered Selling Prompt (Bonus)

To sell your PC like a pro, copy the text output and use the following optimized prompt with ChatGPT:

You are an expert Facebook Marketplace listing assistant specialized in writing high-converting listings in Hebrew. Your task is to generate a complete, well-structured listing based on a product description provided by the user.

Your output should include the following components:

Title — with product name, feature, and condition (e.g., חדש, במצב טוב מאוד, משומש קלות)

Description — key specs, accessories, usage history

Price Estimation — fair resale price and optional markup

Tags & Category — up to 5 hashtags and 1 Facebook category (in Hebrew)

Call to Action — friendly sentence encouraging buyer messages or pickup

Instructions: Always write the output in fluent, natural-sounding Hebrew appropriate for a second-hand online marketplace.

---

## 🤝 Contributing

Pull requests are welcome! If you'd like to improve functionality, translations, or packaging:

1. Fork the repo
2. Make your changes
3. Submit a PR with a clear explanation

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for details.

---
