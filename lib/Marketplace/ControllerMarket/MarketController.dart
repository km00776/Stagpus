abstract class Item {
  final String imagePath,title,description;
  

  Item(this.imagePath, this.title, this.description);
  
}
class Controller extends Item {
  final String imagePath, title, description;
  Controller(this.imagePath, this.title, this.description) : super(imagePath, title, description);  
}
class GameScreen extends Item {
  final String imagePath, title, description; 
  GameScreen(this.imagePath, this.title, this.description) : super(imagePath, title, description);
}
class Mice extends Item {
  final String imagePath, title, description;
  Mice(this.imagePath, this.title, this.description) : super(imagePath, title, description);
}
final controllers = [
  Controller('assets/images/ps5.jpg', 'New Controller', 'Official ps5 controller'),
  Controller('assets/images/mac.png', 'New MacBook', 'Official Macbook 15 Air'),
];
final macs = [
  Controller('assets/images/ps5.jpg', 'New Controller', 'Official ps5 controller'),
  Controller('assets/images/mac.png', 'New MacBook', 'Official Macbook 15 Air'),
];
final mice = [
  Controller('assets/images/ps5.jpg', 'New Controller', 'Official ps5 controller'),
  Controller('assets/images/mac.png', 'New MacBook', 'Official Macbook 15 Air'),
];




