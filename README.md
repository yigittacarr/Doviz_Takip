# 💱 Döviz Kuru Takip Sistemi

TCMB'nin (Türkiye Cumhuriyet Merkez Bankası) resmi günlük kur servisinden döviz kurlarını otomatik olarak çeken, geçmişini Excel'e kaydeden ve canlı bir web panelinde gösteren Python uygulaması.

## Özellikler

- **Otomatik veri çekme** — sunucu arka planda her 5 dakikada TCMB'den güncel kurları çeker
- **Canlı kur kartları** — USD, EUR, GBP, JPY, CHF için anlık alış/satış gösterimi
- **Geçmiş grafik** — her para biriminin zaman içindeki değişimi (Chart.js ile)
- **Excel arşivi** — her çekim `doviz_kurlari.xlsx` dosyasına satır olarak eklenir, geçmiş korunur
- **Manuel yenileme** — "Şimdi Yenile" butonu ile beklemeden anlık çekim
- **Otomatik ekran güncelleme** — sayfa yenilenmeden, her 1 dakikada arayüz kendini günceller

## Teknolojiler

| Teknoloji | Kullanım amacı |
|---|---|
| Python 3 | Ana programlama dili |
| Flask | Web framework ve REST API |
| requests | TCMB'ye HTTP isteği |
| xml.etree.ElementTree | XML parse (stdlib, ek kurulum gerektirmez) |
| openpyxl | Excel dosyası oluşturma ve güncelleme |
| threading | Arka plan veri çekme thread'i |
| Chart.js | Tarayıcı tarafında interaktif grafik |

## Kurulum

```bash
pip install -r requirements.txt
python app.py
```

Tarayıcıda `http://localhost:5000` aç, ardından "Şimdi Yenile" butonuna bas.

## Proje Yapısı

```
doviz-web/
├── app.py              # Flask web uygulaması + arka plan thread
├── doviz_takip.py      # OOP otomasyon sınıfları
├── requirements.txt
├── baslat.bat          # Windows için tek tıkla başlatma
└── templates/
    └── index.html      # Canlı panel (kartlar + grafik + tablo)
```

## OOP Tasarımı

`doviz_takip.py` içinde her sınıfın tek bir sorumluluğu vardır:

```python
class DovizKuru:
    # Bir para birimini temsil eden veri nesnesi

class TCMBKurCekici:
    # TCMB XML servisinden veri çekmekten sorumlu
    def kurlari_getir(self) -> list[DovizKuru]: ...

class ExcelRaporlayici:
    # Excel'e kaydetmekten sorumlu
    # Dosya yoksa oluşturur, varsa satır ekler
    def kaydet(self, kurlar: list[DovizKuru]) -> int: ...
```

## REST API Endpointleri

| Endpoint | Yöntem | Açıklama |
|---|---|---|
| `/` | GET | Ana panel sayfası |
| `/api/guncel` | GET | En güncel kurları JSON olarak döner |
| `/api/grafik` | GET | Chart.js için zaman serisi verisi döner |
| `/api/yenile` | GET | TCMB'den anında yeni veri çeker |

## Veri Kaynağı

TCMB'nin resmi açık veri servisi: `https://www.tcmb.gov.tr/kurlar/today.xml`

Scraping izni gerektirmeyen, herkese açık resmi bir kaynaktır. Hafta sonu ve resmi tatillerde TCMB güncel kur yayınlamayabilir.

## Geliştirme Fikirleri

- E-posta bildirimi: kur belirli eşiği geçince otomatik mail
- Alarm sistemi: kullanıcı tanımlı kur uyarıları
- Daha fazla para birimi: `TAKIP_EDILEN_KURLAR` listesine ekle
- Karşılaştırma: bugün vs. 30 gün önce fark hesaplama
