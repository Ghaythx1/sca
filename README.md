# sca — Router / Camera / WiFi Scanner

أداة سكان سريعة للراوترات على الشبكة المحلية، بتجيب:
- اسم الشبكة (SSID)
- عدد الأجهزة المتصلة
- الباسورد لو الراوتر بيسربه من غير تسجيل دخول
- حالة الكاميرات (Traffic)

وتحاول تدخل بـ `admin/admin` على الأجهزة اللي بتطلب login.

> الاستخدام على شبكة من حقك أو مصرح لك بفحصها فقط.

---

## المميزات

- مسح مباشر وسريع بالـ threads مع ترقيم `#`.
- أعمدة متراصة بدقة (حتى مع العربي والإيموجي).
- دعم Realtek / Netis / Tenda / TP-Link / ipTIME.
- استخراج الباسورد من Realtek وNetis وTenda وTP-Link (new UI) لما يكون متاح.
- محاولة `admin/admin` على الأجهزة المحمية.
- عرض SSID العربي بشكل صحيح في Termux وQTerminal.
- عمود `CLIENTS` لعدد الأجهزة المتصلة.

---

## التثبيت — نسخ ولصق

### Termux (Android)

```bash
pkg update -y && pkg install -y python curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh)"
```

بعد كده شغّلها من أي مكان:

```bash
sca
```

### Kali Linux / Debian

```bash
sudo apt update && sudo apt install -y python3 python3-pip curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh)"
```

لو `~/.local/bin` مش على الـ PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### تشغيل مباشر من غير تثبيت

```bash
curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/sca -o /tmp/sca
chmod +x /tmp/sca
/tmp/sca
```

---

## الاستخدام

```bash
sca                 # يسكان 15.15.15.175 -> 254 افتراضيًا
sca 175 254         # رينج مخصص
sca 1 254 -s 192.168.1
sca -t 32           # عدد threads أكبر
sca --realtek-only  # أجهزة Realtek فقط
```

### أمثلة

```text
#    | IP              | SSID                 | CLIENTS | TRAFFIC              | PASSWORD             | STATUS
01   | 15.15.15.233    | TP-Link_81           | 1       | 0 / 0                | A98765432@@          | ❌ No Cameras
02   | 15.15.15.241    | ﻡﺎﻨﻏ ﺪﻤﺤﻣ            | 1       | 0 / 0                | 55153553             | ❌ No Cameras
```

---

## ملاحظات

- الأجهزة اللي بتحتاج login ومش بتقبل `admin/admin` بتظهر `🔒 login req.`
- الباسورد بيظهر كامل من غير قطع.
- عمود `CLIENTS` ممكن يكون `N/A` لو الراوتر مش بيسمح بقراءة العدد من غير login.
- العربي بيتم تشكيله وعرضه بترتيب مناسب للطرفيات اللي مفيهاش BiDi (زي QTerminal).

## المتطلبات

- Python 3
- `curl` (أو `wget` للتثبيت)
- اختياري: `wcwidth`, `arabic-reshaper`, `python-bidi` (بيسطبهم الإنستولر تلقائيًا)

---

## License

MIT — استخدمها على مسؤوليتك وعلى شبكتك فقط.
