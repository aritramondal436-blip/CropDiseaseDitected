/// Static reference data for the crops shown on the home page and their
/// common diseases. Used by the crop details screen.
class CropInfo {
  const CropInfo({
    required this.name,
    required this.emoji,
    required this.scientificName,
    required this.description,
    required this.season,
    required this.soil,
    required this.water,
    required this.duration,
    required this.diseases,
  });

  final String name;
  final String emoji;
  final String scientificName;
  final String description;
  final String season;
  final String soil;
  final String water;
  final String duration;
  final List<CropDisease> diseases;
}

class CropDisease {
  const CropDisease({
    required this.name,
    required this.pathogen,
    required this.severity,
    required this.symptoms,
    required this.identification,
    required this.prevention,
    required this.treatment,
  });

  final String name;
  final String pathogen;

  /// One of: High, Medium, Low.
  final String severity;
  final List<String> symptoms;
  final List<String> identification;
  final List<String> prevention;
  final List<String> treatment;
}

const List<CropInfo> cropCatalog = [
  CropInfo(
    name: 'Tomato',
    emoji: '🍅',
    scientificName: 'Solanum lycopersicum',
    description:
        'A warm-season fruiting vegetable grown for fresh market and '
        'processing. Tomatoes need full sun, steady moisture and good '
        'airflow to keep foliage dry and healthy.',
    season: 'Kharif / Rabi',
    soil: 'Well-drained loam, pH 6.0–6.8',
    water: 'Regular, 2–3 times a week',
    duration: '90–120 days',
    diseases: [
      CropDisease(
        name: 'Early Blight',
        pathogen: 'Alternaria solani',
        severity: 'High',
        symptoms: [
          'Dark brown spots with concentric rings on older leaves.',
          'Yellow halo around spots; leaves dry and drop early.',
          'Sunken dark lesions on stems and fruit shoulders.',
        ],
        identification: [
          'Target-board or "bullseye" rings inside the spots.',
          'Starts on the lowest, oldest leaves and moves upward.',
          'Spreads fastest in warm, humid weather.',
        ],
        prevention: [
          'Rotate away from tomato and potato for 2–3 years.',
          'Remove and destroy crop debris after harvest.',
          'Stake plants and space them for better airflow.',
          'Mulch and water at the base, not the leaves.',
        ],
        treatment: [
          'Remove infected lower leaves immediately.',
          'Apply chlorothalonil, mancozeb or copper fungicide.',
          'Repeat every 7–10 days while conditions stay humid.',
        ],
      ),
      CropDisease(
        name: 'Late Blight',
        pathogen: 'Phytophthora infestans',
        severity: 'High',
        symptoms: [
          'Water-soaked, greasy grey-green patches on leaves.',
          'White fuzzy mould on the underside in humid weather.',
          'Firm brown rot on green fruit; plants collapse quickly.',
        ],
        identification: [
          'Fuzzy white growth on leaf undersides in the morning.',
          'Rapid spread during cool, wet and cloudy weather.',
          'Distinct from early blight: no concentric rings.',
        ],
        prevention: [
          'Use certified disease-free seed and transplants.',
          'Avoid overhead irrigation and keep foliage dry.',
          'Destroy infected plants and volunteers promptly.',
          'Plant resistant varieties where available.',
        ],
        treatment: [
          'Remove and destroy infected plants — do not compost.',
          'Apply copper-based or metalaxyl fungicide at once.',
          'Treat neighbouring plants protectively.',
        ],
      ),
      CropDisease(
        name: 'Leaf Mold',
        pathogen: 'Passalora fulva (Fulvia fulva)',
        severity: 'Medium',
        symptoms: [
          'Pale yellow spots on the upper leaf surface.',
          'Olive-green to brown velvety mould underneath.',
          'Leaves curl, wither and drop in severe cases.',
        ],
        identification: [
          'Velvety mould on the underside of yellow spots.',
          'Most common in greenhouses and high humidity.',
          'Spreads through splashing water and poor ventilation.',
        ],
        prevention: [
          'Improve ventilation and lower greenhouse humidity.',
          'Avoid wetting leaves; water early in the day.',
          'Remove lower leaves and keep plants spaced.',
          'Grow resistant varieties when possible.',
        ],
        treatment: [
          'Prune and remove infected leaves.',
          'Apply a recommended fungicide if it keeps spreading.',
          'Increase airflow and reduce leaf wetness.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Potato',
    emoji: '🥔',
    scientificName: 'Solanum tuberosum',
    description:
        'A cool-season tuber crop grown for its starchy underground stems. '
        'Potatoes perform best in loose soil with even moisture and cool '
        'nights.',
    season: 'Rabi (cool season)',
    soil: 'Loose sandy loam, pH 5.5–6.5',
    water: 'Moderate, keep soil evenly moist',
    duration: '70–120 days',
    diseases: [
      CropDisease(
        name: 'Late Blight',
        pathogen: 'Phytophthora infestans',
        severity: 'High',
        symptoms: [
          'Irregular water-soaked spots on leaves and stems.',
          'White mould on leaf undersides in damp weather.',
          'Brown, dry rot in tubers after harvest.',
        ],
        identification: [
          'Fast-moving greasy lesions during cool wet spells.',
          'White sporulation on the underside of leaves.',
          'Distinct rotten smell in stored tubers.',
        ],
        prevention: [
          'Plant certified seed tubers only.',
          'Hill soil well and avoid overhead irrigation.',
          'Remove volunteer plants and infected debris.',
        ],
        treatment: [
          'Apply protectant fungicide before wet weather.',
          'Cut and destroy heavily infected foliage.',
          'Harvest tubers only after vines die down.',
        ],
      ),
      CropDisease(
        name: 'Early Blight',
        pathogen: 'Alternaria solani',
        severity: 'Medium',
        symptoms: [
          'Brown target-spots on older leaves.',
          'Yellowing around lesions and premature leaf drop.',
          'Dark lesions on stems and tubers.',
        ],
        identification: [
          'Concentric rings inside the leaf spots.',
          'Begins on lower leaves late in the season.',
          'Favoured by warm days and humid nights.',
        ],
        prevention: [
          'Rotate with cereals and legumes.',
          'Maintain balanced nitrogen and potassium.',
          'Remove crop residue after harvest.',
        ],
        treatment: [
          'Apply mancozeb or chlorothalonil fungicide.',
          'Remove badly infected leaves.',
          'Repeat sprays at 7–10 day intervals.',
        ],
      ),
      CropDisease(
        name: 'Black Scurf',
        pathogen: 'Rhizoctonia solani',
        severity: 'Medium',
        symptoms: [
          'Black scurf-like patches on tuber surfaces.',
          'Reddish-brown cankers on underground stems.',
          'Poor emergence and stunted, yellow plants.',
        ],
        identification: [
          'Hard black bodies that do not wash off tubers.',
          'Lesions on stolons and stem bases.',
          'Worse in cool, wet soils and short rotations.',
        ],
        prevention: [
          'Use clean, certified seed tubers.',
          'Avoid planting in cold, waterlogged soil.',
          'Rotate with non-host crops for 3 years.',
        ],
        treatment: [
          'Treat seed tubers with a recommended fungicide.',
          'Improve soil drainage before planting.',
          'Remove and destroy affected plant debris.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Corn',
    emoji: '🌽',
    scientificName: 'Zea mays',
    description:
        'A tall cereal grown for grain, fodder and sweet corn. Corn is a '
        'heavy feeder that responds well to full sun, fertile soil and '
        'consistent moisture.',
    season: 'Kharif / Spring',
    soil: 'Fertile well-drained loam, pH 5.8–7.0',
    water: 'High, especially at tasselling',
    duration: '90–120 days',
    diseases: [
      CropDisease(
        name: 'Northern Corn Leaf Blight',
        pathogen: 'Exserohilum turcicum',
        severity: 'High',
        symptoms: [
          'Long grey-green to tan lesions on leaves.',
          'Lesions enlarge into cigar-shaped streaks.',
          'Severe blighting reduces grain fill.',
        ],
        identification: [
          'Cigar-shaped lesions running along the leaf.',
          'Greyish centre with darker margins.',
          'Starts on lower leaves and moves upward.',
        ],
        prevention: [
          'Grow resistant hybrids.',
          'Rotate with non-cereal crops.',
          'Bury or remove infected residue.',
        ],
        treatment: [
          'Apply a foliar fungicide when lesions appear.',
          'Remove badly infected lower leaves.',
          'Repeat treatment if weather stays humid.',
        ],
      ),
      CropDisease(
        name: 'Common Rust',
        pathogen: 'Puccinia sorghi',
        severity: 'Medium',
        symptoms: [
          'Small reddish-brown pustules on both leaf surfaces.',
          'Pustules rupture and release powdery spores.',
          'Leaves yellow and dry under heavy infection.',
        ],
        identification: [
          'Raised rust-coloured pustules scattered on leaves.',
          'Favoured by cool, humid nights and warm days.',
          'Pustules rub off as brown powder on fingers.',
        ],
        prevention: [
          'Plant rust-resistant varieties.',
          'Avoid late planting in humid regions.',
          'Keep fields free of grassy weeds.',
        ],
        treatment: [
          'Spray a recommended rust fungicide early.',
          'Repeat after 10–14 days if needed.',
          'Remove volunteer corn that harbours spores.',
        ],
      ),
      CropDisease(
        name: 'Gray Leaf Spot',
        pathogen: 'Cercospora zeae-maydis',
        severity: 'Medium',
        symptoms: [
          'Rectangular grey-brown lesions between leaf veins.',
          'Lesions join and blight large leaf areas.',
          'Premature leaf death and poor grain fill.',
        ],
        identification: [
          'Lesions stay bounded by leaf veins.',
          'Greyish centre with a thin yellow halo.',
          'Worst in humid, minimum-tillage fields.',
        ],
        prevention: [
          'Rotate crops and manage residue.',
          'Use resistant hybrids where available.',
          'Avoid dense planting in humid areas.',
        ],
        treatment: [
          'Apply foliar fungicide at first symptoms.',
          'Improve field airflow and drainage.',
          'Remove residue after harvest.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Rice',
    emoji: '🌾',
    scientificName: 'Oryza sativa',
    description:
        'A staple cereal grown in flooded or well-irrigated paddies. Rice '
        'needs warm temperatures, abundant water and fertile puddled soil.',
    season: 'Kharif (monsoon)',
    soil: 'Clayey loam, pH 5.5–6.5',
    water: 'High, flooded or saturated field',
    duration: '100–150 days',
    diseases: [
      CropDisease(
        name: 'Rice Blast',
        pathogen: 'Magnaporthe oryzae',
        severity: 'High',
        symptoms: [
          'Spindle-shaped grey lesions with dark borders.',
          'Lesions on leaves, nodes and panicles.',
          'Neck rot causes empty or broken panicles.',
        ],
        identification: [
          'Diamond or spindle-shaped spots on leaves.',
          'Grey centre with a brown margin.',
          'Worst with high nitrogen and humid weather.',
        ],
        prevention: [
          'Grow blast-resistant varieties.',
          'Avoid excess nitrogen fertiliser.',
          'Use clean seed and balanced nutrition.',
        ],
        treatment: [
          'Apply a recommended blast fungicide early.',
          'Drain the field briefly to reduce humidity.',
          'Repeat treatment if new lesions appear.',
        ],
      ),
      CropDisease(
        name: 'Bacterial Leaf Blight',
        pathogen: 'Xanthomonas oryzae',
        severity: 'High',
        symptoms: [
          'Water-soaked streaks along leaf edges.',
          'Streaks turn yellow then grey-white.',
          'Wilting of seedlings and empty grains.',
        ],
        identification: [
          'Yellow-to-white wavy lesions from leaf tips.',
          'Bacterial ooze on cut leaves in the morning.',
          'Spreads through irrigation water and storms.',
        ],
        prevention: [
          'Use resistant varieties and clean seed.',
          'Avoid clipping seedlings at transplanting.',
          'Drain fields and reduce standing water.',
        ],
        treatment: [
          'Remove infected clumps where practical.',
          'Apply copper-based bactericide if advised.',
          'Stop excess nitrogen and improve drainage.',
        ],
      ),
      CropDisease(
        name: 'Sheath Blight',
        pathogen: 'Rhizoctonia solani',
        severity: 'Medium',
        symptoms: [
          'Oval green-grey lesions on the leaf sheath.',
          'Lesions banded with brown margins.',
          'Lodging and poor grain filling in severe cases.',
        ],
        identification: [
          'Irregular snake-skin pattern on leaf sheaths.',
          'Starts near the water line and moves upward.',
          'Favoured by dense planting and high humidity.',
        ],
        prevention: [
          'Avoid dense planting and excess nitrogen.',
          'Remove weed hosts around the field.',
          'Rotate with non-host crops where possible.',
        ],
        treatment: [
          'Apply a recommended sheath blight fungicide.',
          'Drain the field to lower humidity.',
          'Remove infected stubble after harvest.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Wheat',
    emoji: '🌱',
    scientificName: 'Triticum aestivum',
    description:
        'A cool-season cereal grown for grain and flour. Wheat needs cool '
        'growth weather, full sun and well-drained fertile soil.',
    season: 'Rabi (cool season)',
    soil: 'Loam to clay loam, pH 6.0–7.5',
    water: 'Moderate, 4–6 irrigations',
    duration: '100–140 days',
    diseases: [
      CropDisease(
        name: 'Leaf Rust',
        pathogen: 'Puccinia triticina',
        severity: 'High',
        symptoms: [
          'Orange-brown round pustules on leaves.',
          'Pustules mainly on the upper leaf surface.',
          'Yellowing and early drying of leaves.',
        ],
        identification: [
          'Rust-coloured powdery pustules on leaves.',
          'Pustules rub off as orange dust.',
          'Spreads quickly in warm, humid weather.',
        ],
        prevention: [
          'Grow rust-resistant wheat varieties.',
          'Sow at the recommended time.',
          'Remove volunteer wheat and grassy weeds.',
        ],
        treatment: [
          'Spray a recommended rust fungicide early.',
          'Repeat after 10–14 days if the disease persists.',
          'Monitor neighbouring fields for spread.',
        ],
      ),
      CropDisease(
        name: 'Powdery Mildew',
        pathogen: 'Blumeria graminis',
        severity: 'Medium',
        symptoms: [
          'White powdery patches on leaves and stems.',
          'Patches merge and cover the leaf surface.',
          'Leaves yellow and dry under heavy infection.',
        ],
        identification: [
          'Fluffy white powder that rubs off easily.',
          'Favoured by cool nights and humid days.',
          'Common in dense, well-fertilised crops.',
        ],
        prevention: [
          'Avoid excessive nitrogen fertiliser.',
          'Use resistant varieties and wider spacing.',
          'Remove infected volunteer plants.',
        ],
        treatment: [
          'Apply a recommended powdery mildew fungicide.',
          'Improve airflow by avoiding dense stands.',
          'Repeat treatment if conditions stay humid.',
        ],
      ),
      CropDisease(
        name: 'Yellow Rust',
        pathogen: 'Puccinia striiformis',
        severity: 'High',
        symptoms: [
          'Yellow pustules arranged in stripes on leaves.',
          'Powdery yellow spores rub off on fingers.',
          'Early leaf drying and shrivelled grain.',
        ],
        identification: [
          'Yellow stripes of pustules along leaf veins.',
          'Favoured by cool, moist weather.',
          'Can spread rapidly over long distances.',
        ],
        prevention: [
          'Plant resistant wheat varieties.',
          'Avoid early sowing in high-risk areas.',
          'Remove volunteer wheat and alternate hosts.',
        ],
        treatment: [
          'Apply a recommended fungicide at first symptoms.',
          'Treat the whole field, not just patches.',
          'Repeat after 10–14 days if needed.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Sugarcane',
    emoji: '🎋',
    scientificName: 'Saccharum officinarum',
    description:
        'A tall perennial grass grown for sugar and juice. Sugarcane needs '
        'long warm growing days, deep fertile soil and steady irrigation '
        'through the season.',
    season: 'Kharif / Annual',
    soil: 'Deep loam, pH 6.0–7.5',
    water: 'High, regular irrigation',
    duration: '10–12 months',
    diseases: [
      CropDisease(
        name: 'Red Rot',
        pathogen: 'Colletotrichum falcatum',
        severity: 'High',
        symptoms: [
          'Reddish discoloration inside the stalk.',
          'Yellowing and drying of upper leaves.',
          'Sour, alcoholic smell from infected cane.',
        ],
        identification: [
          'Red internal lesions crossed by white bands.',
          'Stalks split lengthwise when cut open.',
          'Spread through infected setts and soil.',
        ],
        prevention: [
          'Use disease-free seed setts.',
          'Rotate with non-host crops for 2–3 years.',
          'Avoid waterlogging and ratooning infected fields.',
        ],
        treatment: [
          'Remove and destroy infected clumps promptly.',
          'Plant resistant varieties where available.',
          'Treat setts with a recommended fungicide before planting.',
        ],
      ),
      CropDisease(
        name: 'Wilt',
        pathogen: 'Fusarium sacchari',
        severity: 'Medium',
        symptoms: [
          'Yellowing and drying of leaves from the tips.',
          'Hollow, rotted base of the stalk.',
          'Stunted growth and poor juice quality.',
        ],
        identification: [
          'Brownish discoloration at the stalk base.',
          'Wilting that often starts on one side.',
          'Worse in waterlogged or repeatedly cropped fields.',
        ],
        prevention: [
          'Plant healthy setts from clean nurseries.',
          'Rotate away from sugarcane for at least two years.',
          'Improve field drainage before planting.',
        ],
        treatment: [
          'Rogue out and destroy infected clumps.',
          'Treat setts with a recommended fungicide.',
          'Avoid ratooning fields with a history of wilt.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Cotton',
    emoji: '☁️',
    scientificName: 'Gossypium hirsutum',
    description:
        'A warm-season fibre crop grown for its lint. Cotton needs full sun, '
        'moderate water and careful pest management during boll formation.',
    season: 'Kharif',
    soil: 'Black cotton soil, pH 6.0–8.0',
    water: 'Moderate, drip preferred',
    duration: '150–180 days',
    diseases: [
      CropDisease(
        name: 'Cotton Leaf Curl Virus',
        pathogen: 'Begomovirus (spread by whitefly)',
        severity: 'High',
        symptoms: [
          'Upward curling and thickening of leaves.',
          'Leaf-like enations on the underside.',
          'Stunted plants with reduced boll formation.',
        ],
        identification: [
          'Curled leaves with prominent dark veins.',
          'High whitefly activity around the crop.',
          'Symptoms spread from field edges inward.',
        ],
        prevention: [
          'Grow resistant or tolerant varieties.',
          'Control whitefly with recommended practices.',
          'Remove weeds that host the virus and vector.',
        ],
        treatment: [
          'There is no cure once a plant is infected.',
          'Remove and destroy severely infected plants.',
          'Manage whitefly to slow further spread.',
        ],
      ),
      CropDisease(
        name: 'Fusarium Wilt',
        pathogen: 'Fusarium oxysporum f. sp. vasinfectum',
        severity: 'Medium',
        symptoms: [
          'Yellowing and wilting of leaves.',
          'Brown discoloration inside the stem.',
          'Premature defoliation and boll drop.',
        ],
        identification: [
          'Dark streaks in the vascular tissue.',
          'Wilting that often begins on one side.',
          'Common in fields with a long cotton history.',
        ],
        prevention: [
          'Use resistant varieties and clean seed.',
          'Rotate with cereals or legumes.',
          'Avoid moving infested soil between fields.',
        ],
        treatment: [
          'Remove and destroy infected plants.',
          'Improve drainage and avoid plant stress.',
          'Use a recommended seed treatment before sowing.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Soybean',
    emoji: '🫘',
    scientificName: 'Glycine max',
    description:
        'A protein-rich legume grown for oil and meal. Soybean fixes nitrogen '
        'and performs best in well-drained soil with even moisture at pod fill.',
    season: 'Kharif',
    soil: 'Well-drained loam, pH 6.0–7.0',
    water: 'Moderate, critical at pod fill',
    duration: '90–120 days',
    diseases: [
      CropDisease(
        name: 'Soybean Rust',
        pathogen: 'Phakopsora pachyrhizi',
        severity: 'High',
        symptoms: [
          'Small brown to reddish lesions on leaves.',
          'Yellowing and premature leaf drop.',
          'Thin pods and reduced seed weight.',
        ],
        identification: [
          'Pustules on the underside of leaves.',
          'Angular lesions bounded by leaf veins.',
          'Spreads quickly in humid, cloudy weather.',
        ],
        prevention: [
          'Grow rust-resistant varieties.',
          'Sow early at the recommended time.',
          'Rotate with non-host crops.',
        ],
        treatment: [
          'Apply a foliar fungicide at first symptoms.',
          'Repeat after 10–14 days if weather stays humid.',
          'Monitor neighbouring fields for spread.',
        ],
      ),
      CropDisease(
        name: 'Yellow Mosaic',
        pathogen: 'Mungbean yellow mosaic virus (whitefly)',
        severity: 'Medium',
        symptoms: [
          'Bright yellow and green mosaic patches on leaves.',
          'Puckered, distorted leaves.',
          'Stunted plants with fewer pods.',
        ],
        identification: [
          'Irregular yellow patches across the leaf.',
          'Whitefly activity on the underside.',
          'Symptoms appear soon after emergence.',
        ],
        prevention: [
          'Use resistant varieties and clean seed.',
          'Manage whitefly with recommended practices.',
          'Remove weed hosts around the field.',
        ],
        treatment: [
          'There is no cure for the virus.',
          'Remove and destroy infected plants.',
          'Control whitefly to limit spread.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Onion',
    emoji: '🧅',
    scientificName: 'Allium cepa',
    description:
        'A bulb vegetable grown for fresh market and storage. Onion needs '
        'loose soil, moderate water and good airflow to keep bulbs healthy.',
    season: 'Rabi / Kharif',
    soil: 'Loose sandy loam, pH 6.0–7.0',
    water: 'Moderate, avoid waterlogging',
    duration: '90–150 days',
    diseases: [
      CropDisease(
        name: 'Purple Blotch',
        pathogen: 'Alternaria porri',
        severity: 'High',
        symptoms: [
          'Purple to white sunken lesions on leaves.',
          'Yellowing and dieback of leaf tips.',
          'Reduced bulb size and poor storage quality.',
        ],
        identification: [
          'Concentric rings inside the lesions.',
          'Purple centre with a yellow halo.',
          'Worst in warm, humid weather.',
        ],
        prevention: [
          'Rotate with non-allium crops.',
          'Use certified seed and clean transplants.',
          'Avoid overhead irrigation and dense planting.',
        ],
        treatment: [
          'Apply a recommended fungicide at first symptoms.',
          'Remove infected leaves and crop debris.',
          'Improve airflow around the plants.',
        ],
      ),
      CropDisease(
        name: 'Downy Mildew',
        pathogen: 'Peronospora destructor',
        severity: 'Medium',
        symptoms: [
          'Pale elongated patches on leaves.',
          'Grey-violet fuzzy growth in damp weather.',
          'Leaf collapse and poor bulb development.',
        ],
        identification: [
          'Fuzzy growth visible on mornings after dew.',
          'Yellowing patches that enlarge quickly.',
          'Common in cool, humid and dense crops.',
        ],
        prevention: [
          'Ensure good field drainage.',
          'Rotate away from onion and garlic.',
          'Avoid dense planting and excess nitrogen.',
        ],
        treatment: [
          'Apply a recommended fungicide early.',
          'Remove and destroy infected leaves.',
          'Reduce humidity and improve airflow.',
        ],
      ),
    ],
  ),
  CropInfo(
    name: 'Chilli',
    emoji: '🌶️',
    scientificName: 'Capsicum annuum',
    description:
        'A warm-season spice crop grown for fresh and dried fruit. Chilli '
        'needs full sun, well-drained soil and steady moisture without '
        'waterlogging.',
    season: 'Kharif / Rabi',
    soil: 'Well-drained loam, pH 6.0–7.0',
    water: 'Moderate, avoid drought stress',
    duration: '120–150 days',
    diseases: [
      CropDisease(
        name: 'Anthracnose',
        pathogen: 'Colletotrichum capsici',
        severity: 'High',
        symptoms: [
          'Sunken dark lesions on ripening fruit.',
          'Circular spots on leaves and stems.',
          'Fruit rot with pink to orange spore masses.',
        ],
        identification: [
          'Concentric rings inside fruit lesions.',
          'Pinkish spore masses in humid weather.',
          'Spreads through rain splash and seed.',
        ],
        prevention: [
          'Use certified disease-free seed.',
          'Rotate with non-solanaceous crops.',
          'Avoid overhead irrigation and dense planting.',
        ],
        treatment: [
          'Remove and destroy infected fruit.',
          'Apply a recommended fungicide.',
          'Improve airflow and reduce leaf wetness.',
        ],
      ),
      CropDisease(
        name: 'Leaf Curl Virus',
        pathogen: 'Begomovirus (spread by whitefly)',
        severity: 'Medium',
        symptoms: [
          'Upward curling and puckering of leaves.',
          'Stunted plants with short internodes.',
          'Fewer, smaller fruit.',
        ],
        identification: [
          'Curled leaves with thickened veins.',
          'Whitefly activity on leaf undersides.',
          'Symptoms spread from nearby infected fields.',
        ],
        prevention: [
          'Grow resistant or tolerant varieties.',
          'Manage whitefly with recommended practices.',
          'Remove weeds that host the virus and vector.',
        ],
        treatment: [
          'There is no cure once a plant is infected.',
          'Rogue out and destroy infected plants.',
          'Control whitefly to slow further spread.',
        ],
      ),
    ],
  ),
];

CropInfo? cropByName(String name) {
  for (final crop in cropCatalog) {
    if (crop.name == name) return crop;
  }
  return null;
}
