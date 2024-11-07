class Bearing {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String cost;
  final String article;

  // Используем именованные параметры для конструктора
  Bearing({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cost,
    required this.article,
  });
}

final List<Bearing> initialBearings = [
  Bearing(
    id: 0,
    title: "FAG 566719",
    description: "Радиально-упорный шариковый подшипник 566719",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/39a/radialno_upornye_sharikovyy_podshipnik_qj_206_xl_mpa_.jpg",
    cost: '1350 рублей',
    article: '1',
  ),
  Bearing(
    id: 1,
    title: "FAG 3204",
    description: "Радиальный двухрядный шариковый подшипник 3204 B-2RS-TVH.",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/ae6/radialnyy_dvukhryadnyy_sharikovyy_podshipnik_3204_b_2rs_tvh_.jpg",
    cost: '1420 рублей',
    article: '2',
  ),
  Bearing(
    id: 2,
    title: "FAG 24152",
    description: "Сферический роликовый подшипник 24152 B-MB",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/d52/sfericheskiy_rolikovyy_podshipnik_24152_b_mb_.jpg",
    cost: '152400 рублей',
    article: '3',
  ),
  Bearing(
    id: 3,
    title: "FAG NU 309",
    description: "Роликовый цилиндрический подшипник NU 309 EM1 N",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/8d1/rolikovyy_tsilindricheskiy_podshipnik_nu_309_em1_n_.jpg",
    cost: '4650 рублей',
    article: '4',
  ),
  Bearing(
    id: 4,
    title: "FAG QJ 212",
    description: "Радиально-упорные шариковые подшипники (серия QJ) подшипник QJ 212 XL MPA",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/3bd/radialno_upornye_sharikovye_podshipniki_seriya_qj_podshipnik_qj_212_xl_mpa.jpg",
    cost: '7050 рублей',
    article: '5',
  ),
  Bearing(
    id: 5,
    title: "FAG QJ 214",
    description: "Радиально-упорные шариковые подшипники (серия QJ) подшипник QJ 214 MPA",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/fee/radialno_upornye_sharikovye_podshipniki_seriya_qj_podshipnik_qj_214_mpa.jpg",
    cost: '9580 рублей',
    article: '6',
  ),
  Bearing(
    id: 6,
    title: "FAG NJ2313E",
    description: "Роликовый цилиндрический подшипник NJ2313E-TVP2-C4",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/82a/rolikovyy_tsilindricheskiy_podshipnik_nj2313e_tvp2_c4_.jpg",
    cost: '30000 рублей',
    article: '7',
  ),
  Bearing(
    id: 7,
    title: "FAG HC 6214",
    description: "Сверхточный подшипник HC 6214-M-C4",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/d2a/sverkhtochnyy_podshipnik_hc_6214_m_c4_.jpg",
    cost: '54000 рублей',
    article: '8',
  ),
  Bearing(
    id: 8,
    title: "FAG НС 71914",
    description: "Радиально-упорный шариковый подшипник НС 71914-С-Т-Р4S-UL",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/239/radialno_upornye_sharikovyy_podshipnik_ns_71914_s_t_r4s_ul_.jpg",
    cost: '5,000,000 рублей',
    article: '9',
  ),
  Bearing(
    id: 9,
    title: "FAG T7FC085",
    description: "Конический роликовый подшипник T7FC085",
    imageUrl: "https://evropodshipnikm.ru/upload/iblock/15e/konicheskiy_rolikovyy_podshipnik_t7fc085_.png",
    cost: '7,000,000 рублей',
    article: '10',
  ),
];
