# NovaStore – E-Ticaret Veritabanı Projesi

**Hazırlayan:** Tuğçe Yıldız  
**Proje türü:** İlişkisel veritabanı tasarımı ve SQL sorgulama  
**Kullanılan teknoloji:** Microsoft SQL Server, T-SQL

## Proje hakkında

NovaStore, örnek bir e-ticaret platformunun ürün, kategori, müşteri ve sipariş verilerini yönetmek amacıyla tasarlanmış ilişkisel veritabanı projesidir. Projede tablolar arası ilişkiler kurulmuş, örnek veriler eklenmiş ve iş ihtiyaçlarına yönelik SQL sorguları hazırlanmıştır.

## Veritabanı yapısı

Projede beş temel tablo bulunmaktadır:

| Tablo | Açıklama |
|---|---|
| `Categories` | Ürün kategorilerini tutar. |
| `Products` | Ürün adı, fiyat, stok ve kategori bilgisini tutar. |
| `Customers` | Müşteri adı, şehir ve e-posta bilgilerini tutar. |
| `Orders` | Müşteri siparişlerini ve sipariş toplamını tutar. |
| `OrderDetails` | Siparişlerde bulunan ürün ve miktar bilgilerini tutar. |

Tablolar arasında Primary Key (PK) ve Foreign Key (FK) ilişkileri kullanılmıştır.

- `Products.CategoryID` → `Categories.CategoryID`
- `Orders.CustomerID` → `Customers.CustomerID`
- `OrderDetails.OrderID` → `Orders.OrderID`
- `OrderDetails.ProductID` → `Products.ProductID`

## Uygulanan işlemler

- Veritabanı ve tabloların oluşturulması
- Örnek kategori, ürün, müşteri ve sipariş verilerinin eklenmesi
- Stok miktarı 20'nin altında olan ürünlerin listelenmesi
- Müşteri ve sipariş bilgilerinin `INNER JOIN` ile birleştirilmesi
- Belirli bir müşterinin satın aldığı ürünlerin listelenmesi
- Kategori bazında ürün sayısının `LEFT JOIN`, `COUNT` ve `GROUP BY` ile hesaplanması
- Müşteri bazında toplam cironun `SUM` ile hesaplanması ve sıralanması
- `DATEDIFF` ile sipariş tarihinden itibaren geçen gün sayısının hesaplanması
- Tekrarlanan JOIN işlemlerini azaltmak için `vw_SiparisOzet` isimli VIEW oluşturulması

## Kurulum ve çalıştırma

1. Microsoft SQL Server ve SQL Server Management Studio (SSMS) kurulu olmalıdır.
2. Bu depodaki `NovaStoreDB.sql` dosyasını SSMS ile açın.
3. Scripti çalıştırarak veritabanını, tabloları, örnek verileri ve sorguları oluşturun.
4. Oluşturulan görünümü kontrol etmek için scriptin sonundaki `SELECT * FROM vw_SiparisOzet` sorgusunu kullanabilirsiniz.

> **Önemli:** Script, aynı isimde mevcut bir `NovaStoreDB` veritabanı varsa onu silip yeniden oluşturur. Çalıştırmadan önce mevcut verilerinizin silinmesini istemediğinizden emin olun.

## Proje dosyaları

- `NovaStoreDB.sql` – Veritabanı oluşturma, tablolar, örnek veriler, analiz sorguları ve VIEW tanımı.

## Not

Projede kullanılan kayıtlar örnek (dummy) verilerdir. Veritabanı tasarımı ve SQL sorgulama çalışmalarını göstermek amacıyla hazırlanmıştır.
