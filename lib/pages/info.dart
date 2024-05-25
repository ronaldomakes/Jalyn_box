import 'package:firebase_defenite_project/constants/styles.dart';
import 'package:firebase_defenite_project/pages/register_page.dart';
import 'package:firebase_defenite_project/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import 'package:firebase_defenite_project/services/firebase_auth.dart';
class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int _selectedIndex = 1;
  final List<Item> items = [
    Item(
        title: 'Полотно',
        description:
        'Противопожарное полотно - это специальный материал, обладающий высокой огнестойкостью и используемый для защиты от распространения огня.',
        imageUrl: 'assets/fabric.jpg',
        color: Color(0xFF13804D),
    ),
    Item(
        title: 'Маска',
        description:
        'Марлевая маска используется для защиты дыхательных путей при пожаре, фильтруя дым, газы и токсичные вещества.',
        imageUrl: 'assets/mask.jpg',
        color: Color(0xFF13804D),
    ),
    Item(
        title: 'Аптечка',
        description:
        'Аптечка УНИВЕРСАЛЬНАЯ предназначена для оказания первой помощи при чрезвычайных ситуациях ',
        imageUrl: 'assets/medkit.jpg',
        color: Color(0xFF13804D),
    ),
    // Add more items
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Info Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
    if (index == 1) {
      // Navigate to Info Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfoPage()),
      );
    }
  }
  Auth auth = Auth();
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3AAC3F),
        actions: [
          IconButton(onPressed: () {
            signOut().then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            ));

          }, icon: Icon(Icons.door_front_door_outlined))
        ],
        title: Text('Информация о боксе', style: GoogleFonts.openSans(
          fontWeight: FontWeight.w800,
          color: Colors.white
        ),),
      ),
      body: Stack(
        children: [
        CardSwiper(

        cardsCount: items.length,

        cardBuilder: (context,index){
          return StackedCard(
            item: items[index],
          );
        },
        ),
        SizedBox(height: 10,),
          Positioned(
            top: 10,
            left: 16.0,
            right: 16.0,
            child: Positioned(
              left: 40,
              right: 40,
              bottom: 30,
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                ),
                child: InkWell(
                      onTap: () {
                        // Show dialog when the button is pressed
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Обучающее видео',style: openSans600),
                              content: Text('Хотите посмотреть видео?',style: openSans400),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    launch("https://www.youtube.com/watch?v=MednM9Oop0s");// Close the dialog
                                    // Implement logic to watch the video
                                  },
                                  child: Text('О полотне ',style: openSans600),
                                ),
                                TextButton(
                                  onPressed: () {
                                    launch("https://www.youtube.com/watch?v=MednM9Oop0s&t=2s");// Close the dialog
                                    // Implement logic to watch the video
                                  },
                                  child: Text('О аптечке',style: openSans600),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    // Implement logic if user doesn't want to watch the video
                                  },
                                  child: Text('Не сейчас',style: openSans600),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                            'Подробнее о составляющем',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            )
                        ),
                      ),
                    ),



              ),
            ),
          ),

        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF3AAC3F),
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главный экран',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Информация'
          )
        ],
      ),
    );
  }
}

class StackedCard extends StatelessWidget {
  final Item item;

  StackedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: item.color, // Adjust opacity here
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: AssetImage(item.imageUrl),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      item.title,
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        fontSize: 30
                      )
                  )
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                    item.description,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )
                ),
              ),
            ],
          )
      ),
    );
  }
}

class Item {
  final String title;
  final String description;
  final String imageUrl;
  final Color color;

  Item({required this.title, required this.description, required this.imageUrl, required this.color});
}
