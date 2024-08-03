const gameLevels = <GameLevel>[
  (
    number: 1,
    winScore: 3,
    canSpawnTall: false,
  ),
  (
    number: 2,
    winScore: 5,
    canSpawnTall: false,
  ),
  (
    number: 3,
    winScore: 10,
    canSpawnTall: false,
  ),
  (
    number: 4,
    winScore: 15,
    canSpawnTall: false,
  ),
  (
    number: 5,
    winScore: 20,
    canSpawnTall: false,
  ),
    (
    number: 6,
    winScore: 25,
    canSpawnTall: true,
  ),
  (
    number: 7,
    winScore: 30,
    canSpawnTall: true,
  ),
  (
    number: 8,
    winScore: 35,
    canSpawnTall: true,
  ),
  (
    number: 9,
    winScore: 40,
    canSpawnTall: true,
  ),
  (
    number: 10,
    winScore: 45,
    canSpawnTall: true,
  ),
];

typedef GameLevel = ({
  int number,
  int winScore,
  bool canSpawnTall,
});
