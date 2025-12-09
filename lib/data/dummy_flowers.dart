import '../models/flower.dart';

List<Flower> dummyFlowers = [
  // Local — Andhra Pradesh (Godavari & Krishna)
  Flower(
    id: '1',
    name: 'Jasmine (Malli Puvvu)',
    imageUrl:
        'https://3.imimg.com/data3/BX/NH/MY-9833861/loose-jasmine-flower-500x500.jpg',
    price: 40.0,
    event: 'marriage',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '2',
    name: 'Mogali Flowers',
    imageUrl:
        'https://pushmycart.in/cdn/shop/files/c77884120e438ed4e146125ba262d378_6d42b20b-9dd3-441b-98d9-d307b67b5a3f.jpg?v=1721032800&width=990',
    price: 25.0,
    event: 'house_warming',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '3',
    name: 'Marigold (Banthi Puvvu)',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbZErIyT8TsKcmED4M5-7tWoH5_o2BEwK7Gg&s',
    price: 20.0,
    event: 'special_events',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '4',
    name: 'Chrysanthemum (Chamanthi)',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpzKLvLIEchxhNB_mLjBxG4aI47PrWAcDwnw&s',
    price: 30.0,
    event: 'marriage',
    isLocal: true,
    isSeasonal: false,
  ),
  Flower(
    id: '5',
    name: 'Kanakambaram (Crossandra)',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSukYOGEPSKZa-MWDG5MOf59KYjh1ZHqs0jEQ&s',
    price: 35.0,
    event: 'house_warming',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '6',
    name: 'Lotus',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStBJpqH7ylAnhkBmoOMjzr0RfDiLNRL3lZ6A&s',
    price: 45.0,
    event: 'special_events',
    isLocal: true,
    isSeasonal: false,
  ),
  Flower(
    id: '7',
    name: 'Tulasi Garland',
    imageUrl:
        'https://instamart-media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,h_600/NI_CATALOG/IMAGES/ciw/2025/11/20/cb3f61c8-3fc9-4942-a6ca-be3290bc630d_33IP6PVD1K_MN_20112025.jpg',
    price: 15.0,
    event: 'death',
    isLocal: true,
    isSeasonal: true,
  ),

  // Additional local AP flowers
  Flower(
    id: '12',
    name: 'Sampangi',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaoL_Vr7lHLq1IKhjaqN7-W5Asd1WKrCo2UA&s',
    price: 28.0,
    event: 'marriage',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '13',
    name: 'Ganneru (Jasmine Cluster)',
    imageUrl:
        'https://www.shutterstock.com/image-photo/beautiful-view-cluster-star-jasmine-260nw-2526998247.jpg',
    price: 22.0,
    event: 'special_events',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '14',
    name: 'Mandaram (Hibiscus-like)',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/c/cb/Hibiscus_flower_TZ.jpg',
    price: 18.0,
    event: 'house_warming',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '15',
    name: 'Nandivardhanam (Temple flower)',
    imageUrl:
        'https://m.media-amazon.com/images/I/6158ro0sxGL._SX300_SY300_QL70_FMwebp_.jpg',
    price: 32.0,
    event: 'special_events',
    isLocal: true,
    isSeasonal: false,
  ),

  // Non-local / exotic
  Flower(
    id: '8',
    name: 'Orchid Bouquet',
    imageUrl:
        'https://www.flowersacrossindia.com/cdn/shop/products/FAIHD20170492.jpg?v=1554454628&width=823',
    price: 120.0,
    event: 'special_events',
    isLocal: false,
    isSeasonal: false,
  ),
  Flower(
    id: '9',
    name: 'Tulip Bundle',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdgvQcMIHAshPGz0PQ2vi92ICP_eSkJQ4WVQ&s',
    price: 150.0,
    event: 'valentine',
    isLocal: false,
    isSeasonal: false,
  ),
  Flower(
    id: '10',
    name: 'Carnation Bouquet',
    imageUrl:
        'https://asset.bloomnation.com/c_fill,d_vendor:global:catalog:product:image.png,f_auto,fl_preserve_transparency,h_2000,q_auto,w_2000/v1714516515/vendor/9260/catalog/product/2/0/20240330070827_file_6607ba6b5c719_6607bb06dc618.webp',
    price: 80.0,
    event: 'marriage',
    isLocal: false,
    isSeasonal: true,
  ),
  Flower(
    id: '11',
    name: 'Lily Bouquet',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxoGtvpbryjZC_Dv-zAWqQzkeiyUSZxgGUmQ&s',
    price: 90.0,
    event: 'house_warming',
    isLocal: false,
    isSeasonal: false,
  ),

  // More helpful variety
  Flower(
    id: '16',
    name: 'Mixed Garland Pack',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3RJcmQRkV2ybVpIaCBIMQpUGQZ8CfAonIbw&s',
    price: 55.0,
    event: 'special_events',
    isLocal: true,
    isSeasonal: true,
  ),
  Flower(
    id: '17',
    name: 'Premium Rose Box',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSse6D0w9dv_QOYCdApZgP1-UfTEM4DG8PyLA&s',
    price: 130.0,
    event: 'valentine',
    isLocal: false,
    isSeasonal: false,
  ),
  Flower(
    id: '18',
    name: 'Seasonal Bouquet',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdY30rsQ2TF-0kpFIE6-Fydi2rtKjkmkbU0Q&s',
    price: 65.0,
    event: 'special_events',
    isLocal: true,
    isSeasonal: true,
  ),
];
