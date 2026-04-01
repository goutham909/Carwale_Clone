/// Demo specification rows for compare and detail tabs.
typedef CarSpecMap = Map<String, String>;

final Map<String, CarSpecMap> mockSpecsByCarId = {
  'ritz': _hatchPetrol('1197 cc', '18.5 kmpl', '4 Star (older)'),
  'fronx': _suvPetrol('998 cc Turbo', '20.01 kmpl', '5 Star'),
  'celerio': _hatchPetrol('998 cc', '26.68 kmpl', '4 Star'),
  'baleno': _hatchPetrol('1197 cc', '22.35 kmpl', '4 Star'),
  'punch': _suvPetrol('1199 cc', '18.8 kmpl', '5 Star'),
  'sierra': {
    'Fuel': 'Electric',
    'Battery': '60 kWh (est.)',
    'Range': '500 km (claimed)',
    'Charging': '10–80% in 35 min (DC fast)',
    'Power': '250 kW (est.)',
    'Body': 'SUV',
    'Safety': 'TBA',
  },
  'seltos': _suvDiesel('1493 cc', '20 kmpl', '3 Star'),
  'hyryder': {
    'Fuel': 'Petrol + Hybrid',
    'Engine': '1490 cc + Motor',
    'Mileage': '27.97 kmpl (ARAI)',
    'Power': '92 kW combined',
    'Body': 'SUV',
    'Safety': '5 Star',
  },
  'creta': _suvDiesel('1493 cc', '18.4 kmpl', '3 Star'),
  'landcruiser': {
    'Fuel': 'Diesel',
    'Engine': '3346 cc V6 Twin Turbo',
    'Mileage': '11 kmpl (est.)',
    'Power': '305 kW',
    'Body': 'SUV',
    'Safety': '5 Star',
  },
  'landcruiser-fj': {
    'Fuel': 'Petrol / Hybrid (TBA)',
    'Engine': 'TBA',
    'Mileage': '—',
    'Power': '—',
    'Body': 'SUV',
    'Safety': 'TBA',
  },
  'landcruiser-old': _suvDiesel('4461 cc V8', '7–9 kmpl', '—'),
  'prado': _suvDiesel('2982 cc', '8–10 kmpl', '—'),
  'exter': _suvPetrol('1197 cc', '19.2 kmpl', '4 Star'),
};

CarSpecMap _hatchPetrol(String engine, String mileage, String safety) => {
      'Body': 'Hatchback',
      'Fuel': 'Petrol',
      'Engine': engine,
      'Mileage': mileage,
      'Transmission': 'Manual / AMT',
      'Safety': safety,
    };

CarSpecMap _suvPetrol(String engine, String mileage, String safety) => {
      'Body': 'SUV',
      'Fuel': 'Petrol',
      'Engine': engine,
      'Mileage': mileage,
      'Transmission': 'Manual / AT',
      'Safety': safety,
    };

CarSpecMap _suvDiesel(String engine, String mileage, String safety) => {
      'Body': 'SUV',
      'Fuel': 'Diesel',
      'Engine': engine,
      'Mileage': mileage,
      'Transmission': 'Manual / AT',
      'Safety': safety,
    };

CarSpecMap specsForCar(String carId) {
  return Map<String, String>.from(mockSpecsByCarId[carId] ?? {
    'Body': '—',
    'Fuel': '—',
    'Engine': '—',
    'Mileage': '—',
    'Safety': '—',
  });
}
