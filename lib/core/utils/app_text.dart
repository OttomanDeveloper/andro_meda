/// All static copy: era titles/timestamps/descriptions and the portfolio text.
/// The era lists are parallel and indexed by era number (0..8).
abstract class AppText {
  const AppText._();

  // Era names (used by progress bar), index = era number 0..8
  static const List<String> eraNames = [
    'The Big Bang',
    'Cosmic Dark Ages',
    'First Stars & Light',
    'Galaxies Form',
    'Our Solar System',
    'Life Begins',
    'Age of Giants',
    'Rise of Humanity',
    'The Future',
  ];

  // Era timestamps
  static const List<String> eraTimestamps = [
    '13.8 BILLION YEARS AGO',
    '13.5 BILLION YEARS AGO',
    '13.2 BILLION YEARS AGO',
    '10 BILLION YEARS AGO',
    '4.6 BILLION YEARS AGO',
    '3.8 BILLION YEARS AGO',
    '230 MILLION YEARS AGO',
    '300,000 YEARS AGO',
    'NOW → ∞',
  ];

  // Era headlines
  static const List<String> eraHeadlines = [
    'Everything Began',
    'The Silent Cosmos',
    'Let There Be Light',
    'Islands of Stars',
    'Our Place in the Void',
    'Chemistry Became Biology',
    'Titans of the Earth',
    'The Spark of Consciousness',
    'What Comes Next?',
  ];

  // Era descriptions (1 mind-blowing paragraph each)
  static const List<String> eraDescriptions = [
    'In a fraction of a second, the universe expanded from smaller than an atom to larger than a galaxy. The temperature was 10 trillion degrees. Every particle of matter that would ever exist was created in this moment.',
    'For 200 million years, the universe was completely dark. No stars, no light — just an expanding fog of hydrogen and helium cooling in absolute silence. The longest night in history.',
    'Gravity pulled hydrogen clouds together until they ignited. The first stars were monsters — 1,000 times more massive than our sun, burning blue-white and dying in spectacular supernovae that forged every heavy element in your body.',
    'Billions of stars fell into gravitational dances, forming spiraling galaxies. The observable universe contains 2 trillion galaxies, each home to hundreds of billions of stars. We live in one called the Milky Way.',
    'A cloud of gas and dust collapsed into a spinning disk. At its center, our Sun ignited. The remaining debris became 8 planets, 200+ moons, and billions of asteroids — all orbiting in the same direction, a memory of that original spin.',
    'In warm shallow pools, simple molecules began copying themselves. Single cells appeared — the ancestor of every living thing. For 3 billion years, life was nothing but microbes. Then everything changed.',
    'Dinosaurs ruled for 165 million years — 800 times longer than humans have existed. A Tyrannosaurus stood 12 meters tall. An Argentinosaurus weighed 70 tonnes. They vanished in a single day when a 10km asteroid struck.',
    'A species learned to control fire, tell stories, and wonder about the stars. In 300,000 years we went from stone tools to quantum computers. We are the universe becoming aware of itself.',
    '13.8 billion years of cosmic evolution. Stardust became atoms. Atoms became life. Life became conscious. And consciousness learned to create.',
  ];

  // Portfolio section
  static const String portfolioIntro = 'This experience was crafted by';
  static const String portfolioName = 'Muhammad Usman';
  static const String portfolioRole = 'Senior Flutter Developer';
  static const String portfolioSubrole =
      'Mobile App Specialist · BLE & Healthcare';
  static const String portfolioTagline =
      '4+ years building cross-platform apps people actually use.';

  // Headline metrics, each entry is a [value, label] pair shown as a stat card.
  static const List<List<String>> portfolioStats = [
    ['50+', 'Apps shipped'],
    ['600K+', 'Users reached'],
    ['1K+', 'YouTube subscribers'],
    ['Google', 'Adopted my Dart package'],
  ];

  // Core stack.
  static const List<String> portfolioTech = [
    'Flutter',
    'Dart',
    'Firebase',
    'BLE',
    'Gemini AI',
    'BLoC',
  ];

  // Portfolio links.
  static const String portfolioGithub = 'github.com/OttomanDeveloper';
  static const String portfolioLinkedIn = 'linkedin.com/in/ottomancoder';
  static const String portfolioYouTube = 'youtube.com/@OttomanCoder';
  static const String portfolioEmail = 'usman243786@gmail.com';
}
