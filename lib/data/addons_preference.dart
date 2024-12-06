const Map<String, Map<String, double>> addonsByType = {
  'food': {
    'Extra Cheese': 5000,    
    'Extra Sauce': 5000,     
    'Extra Spice': 2000,
  },
  'beverage': {
    'Coconut Jelly': 5000,  
    'Whipped Cream': 5000,   
    'Soy Milk': 7000,        
    'Boba': 5000,            
    'Chocolate': 3000,      
    'Oreo': 5000,            
  },
  'breakfast': {
    'Extra Egg': 8000, 
    'Bacon': 10000,     
    'Sausage': 7000,   
  },
};

const Map<String, List<String>> preferencesByType = {
  'food': [
    'original',
    'hot',
    'very hot',
    'no sauce',
    'no MSG',
    'no salt'
  ],
  'beverage': ['less sugar', 'less ice'],
  'breakfast': ['small', 'medium', 'jumbo'],
};
